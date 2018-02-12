#!/bin/bash
fmts="svg png"

while IFS= read -r -d '' dotfile ; do
    assetdir=$(dirname "${dotfile}")
    assetname=$(basename "${assetdir}")
    echo "Generating renders for $(basename ${assetdir})"
    for fmt in ${fmts} ; do
        dstfile="${assetdir}/${assetname}.${fmt}"
        if [[ "${dotfile}" -nt "${dstfile}" ]] ; then
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
        fi
    done
done < <(find assets -type f -name '*.dot' -print0)
