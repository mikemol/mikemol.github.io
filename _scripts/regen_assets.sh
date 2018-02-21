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
