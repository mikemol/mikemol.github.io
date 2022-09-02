---
layout: post
title:  "Asset regeneration script"
date:   2018-02-13 15:00:00 -0500
categories: tools code blog
---

So, in the interest of trying to be lazy (really!), I wrote a script to automate the generation of graphic assets from the `dot` source files. It does a few things for me:

* It only generates files that have been updated (with similar behavior to `make`; it only updates assets if the source file is newer than the asset).
* It generates both PNG and SVG files (and could generate any format `dot` supports).
* It quantizes and crushes PNG assets, drastically reducing file size.
* It commits modified source files to avoid losing work (a generated asset is a conscious effort. I presume it represents a significant change in the source.)
* It commits generated assets.
* It saves me manually typing the `dot` commands or relying on shell history to keep them.

## Workflow

![An illustration of the script flow.]({{ site.url }}/assets/blog-asset-generation/script-flow/script-flow.svg)

Here's how it works:

1. Find all `dot` files in my `assets` folder.
1. For each `dot` file
    1. For each format (I specify SVG and PNG)
        1. Check to see if the `dot` file is newer than the corresponding PNG or SVG.
            1. If it's newer:
                1. Commit the `dot` file to the `git` repository, in case the work-in-progress hasn't been committed already.
                1. Render the asset
                1. If the asset is a PNG:
                    1. Force the PNG into indexed RGBA mode using `pngquant`; for many images, this grossly reduces the PNG file size.
                    1. Run `pngcrush` on the indexed PNG, trying all strategies that use the maximum Zlib compression. For PNG images which `pngquant` didn't make a significant file size dent in, this will.
                1. Stage the asset for commit.
    1. If there are changes staged for commit, commit them.

## Source

```bash
#!/bin/bash
fmts="svg png"
banned_branches="master regen-assets"

current_branch=$(git branch -l | grep -e '^*' | cut -d' ' -f2)

for b in ${banned_branches} ; do
    if [[ "${current_branch}" == "${b}" ]]; then
        echo "Not regenerating assets. ${b} is a protected branch."
        exit 1
    fi
done

git_status=$(git status)

if echo "${git_status}" | grep "Changes to be committed" > /dev/null ; then
    echo "Not regenerating assets. You have staged, uncommitted changes."
    exit 1
fi

while IFS= read -r -d '' dotfile ; do
    assetdir=$(dirname "${dotfile}")
    assetname=$(basename "${assetdir}")
    echo "Generating renders for $(basename ${assetdir})"
    for fmt in ${fmts} ; do
        dstfile="${assetdir}/${assetname}.${fmt}"
        if [[ "${dotfile}" -nt "${dstfile}" ]] ; then
            echo "${dotfile} has been updated. Committing $dotfile"
            git commit --quiet -m "Caught uncommited changes to ${assetname}. Preserving separately." "${dotfile}"
            echo "Building ${fmt} for $(basename ${assetdir})"
            dot "-T${fmt}" -o "${assetdir}/${assetname}.${fmt}" "${dotfile}"
            if [[ $fmt == "png" ]] ; then
                orig_size=$(stat -c %s "${dstfile}")
                pngquant --force --ext .png -Q 100-100 "${dstfile}"
                quant_size=$(stat -c %s "${dstfile}")
                pngcrush -ow -brute -l 9 -q "${dstfile}"
                crushed_size=$(stat -c %s "${dstfile}")
                echo "Original: ${orig_size}b. Quantized: ${quant_size}b. Crushed: ${crushed_size}"
            fi
            echo "Adding ${dstfile}"
            git add "${dstfile}"
        fi
        echo "checking for changes"
        if git status | grep "Changes to be committed" > /dev/null ; then
            echo "Committing changes for ${assetname}"
            git commit --quiet -m "Preserving binary renders for ${assetname}"
        fi
    done
done < <(find assets -type f -name '*.dot' -print0)
```

Pretty handy. We'll have to see how automating munging of my `git` repo works out, but I think there's going to be more value in automating it than is lost digging through some strange git history. At least the visual renders will accompany the various versions of the dotfiles, so understanding the impacts of changes will be easier, and I'll have snapshots of works-in-progress to go back to illustrate _why__ I took one approach or another while demonstrating more about Dot and Graphviz.
