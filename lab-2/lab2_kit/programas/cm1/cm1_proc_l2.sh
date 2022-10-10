#!/bin/bash

ARRAY_SIZE=`cat cm1-l2.out | cut -f1 | cut -d"=" -f2 |sort -gu`
STRIDE_LIST=`cat cm1-l2.out | cut -f2 | cut -d"=" -f2 |sort -gu`

rm cm1-l2_plot.dat 2> /dev/null
touch cm1-l2_plot.dat

for stride in $STRIDE_LIST; do
    echo -e "# $stride" >> cm1-l2_plot.dat
    echo -n "$stride " >> cm1-l2_plot.dat
    for cache in $ARRAY_SIZE; do
        METRIC=$(cat cm1-l2.out | grep "cache_size=$cache	" | grep "stride=$stride	"  | cut -f3 | cut -d"=" -f2)
        if [[ -z $METRIC ]]; then
            METRIC=0.0;
        fi
        echo "($stride, $cache): \"$METRIC\""
        echo -n "$METRIC " >> cm1-l2_plot.dat
    done
    echo >> cm1-l2_plot.dat
done

echo "call \"cm1-l2_plot.gp\"" | gnuplot