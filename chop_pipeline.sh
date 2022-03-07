#!/bin/sh

for i in $@
do
    mkdir results/$i

    ./chopchop.py -G hg38 -o results/$i -Target $i --scoringMethod DOENCH_2016 -consensusUnion > results/$i/$i.txt

    echo "$i done!"
done

echo "All done!"