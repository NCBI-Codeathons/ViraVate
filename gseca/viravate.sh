#!/bin/bash

usage() {
   echo "
Usage: $0 -e GEM -c CCL [-g GS] [-nh]

Options
-e GEM  Gene expression matrix file (REQUIRED)
-c CCL  Case Control list file (REQUIRED)
-g GS   Gene signatures to search against
-n      Don't search against ViraVate viral gene signatures (REQUIRES -g GS)
-h      Help

---------- Three ways to run ViraVate -------------
1.  Search against ViraVate's viral gene signatures
$0 -e GEM -c CCL

2.  Add '-g GS' option to search additional gene signatures
$0 -e GEM -c CCL -g GS

3.  Add -n option with -g GS option to search only gene signatures in GS. 
This is useful for the case when shortening runtime is important or if you
only want to see your gene signatures in the output
$0 -e GEM -c CCL -g GS -n

"
   exit 1
}

while getopts "e:c:g:nh" OPTION; do
  case "$OPTION" in
    e) GEM=$OPTARG  # gene expression matrix file
       ;;
    c) CCL=$OPTARG  # case control list file
       ;;
    g) AGS=$OPTARG  # gene signature file
       ;;
    n) NOVIRAL=1    # don't use viral gene lists
       ;;
    h) h=1
       ;;
    *) usage
  esac
done

# set defaults if not already set by 'getopts'
AGS=${AGS:-NULL}
NOVIRAL=${NOVIRAL:-0}
h=${h:-0}

if [[ $h == 1 ]]; then
  usage
fi

if [[ -z $GEM || -z $CCL ]]; then
  usage
fi

if [[ $AGS == "NULL" && $NOVIRAL == 1 ]]; then
  usage
fi

GEM=/home/results/$GEM   # /home/results is the volume mount in docker that connects to the current directory
CCL=/home/results/$CCL

if [[ $AGS != "NULL" ]]; then
  AGS=/home/results/$AGS
fi

#echo "GEM is <$GEM>"
#echo "CCL is <$CCL>"
#echo "AGS is <$AGS>"
#echo "NOVIRAL is <$NOVIRAL>"
#echo "h       is <$h>"

docker run --env GEM=$GEM --env CCL=$CCL --env AGS=$AGS --env NOVIRAL=$NOVIRAL \
           -v $(PWD):/home/results virushunter/base_viravate

#docker run --env GEM=$GEM --env CCL=$CCL --env GSL=$GSL -v $(PWD):/home/results virushunter/base_viravate
