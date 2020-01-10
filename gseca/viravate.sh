#!/bin/bash


while getopts ":e:c:g:" OPTION; do
    case "$OPTION" in
    e)
        GEM=$OPTARG
        ;;
    c)
        CCL=$OPTARG
        ;;
    g)
        AGS=$OPTARG
        ;;
    *)
        echo "Incorrect options provided"
        exit 1
        ;;
    esac
done

set -u
#: $GEM $CCL $AGS
set +u

usage="Usage: make sure to provide the following arguments -e GEM -c CCL -g GSET"

if [ -z "$GEM" ] || [ -z "$CCL" ] || [ -z "$AGS" ]; then
    echo $usage
    exit 1;
fi

GEM=/home/results/$GEM
CCL=/home/results/$CCL
AGS=/home/results/$AGS
docker run --env GEM=$GEM --env CCL=$CCL --env AGS=$AGS -v $(PWD):/home/results virushunter/base_viravate
#docker run --env GEM=$GEM --env CCL=$CCL --env GSL=$GSL -v $(PWD):/home/results virushunter/base_viravate

