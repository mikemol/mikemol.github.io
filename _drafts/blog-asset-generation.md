---
layout: post
title:  "Asset regeneration script"
date:   2018-02-11 15:00:00 -0500
categories: technique colorblind
---
# An Asset Regeneration Script

So, in the interest of trying to be lazy (really!), I wrote a script to automate the generation of SVG PNG artifacts from the `dot` source files. Here's the source:

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

If you know `bash`, the behavior should be pretty clear, but here's what it does in a nutshell:

1. Find all `dot` files in my `assets` folder.
1. For each `dot` file
    1. For each format (I specify SVG and PNG)
        1. Check to see if the `dot` file is newer than the corresponding PNG or SVG.
            1. If it's newer:
                1. Commit the `dot` file to the `git` repository, in case the work-in-progress hasn't been committed already.
                1. Render the asset
                1. If the asset is a PNG:
                    1. Force the PNG into indexed RGBA mode using `pngquant`; for many images, this grossly reduces the PNG file size.
                    1. Run `pngcrush` on the indexed PNG, trying all strategies that use the maximum `zlib` compression. For PNG images which `pngquant` didn't make a significant file size dent in, this will.
                1. Stage the asset for commit.
    1. If there are changes staged for commit, commit them.
