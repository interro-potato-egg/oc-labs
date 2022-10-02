#/bin/sh

echo "" > results.txt

BASE_BLOCK_SIZE=16
L1_SIZE=1024
L2_SIZE=$((1024*16))
WAYS=4

for MULTIPLIER in 1 2 4 8
do
    BLOCK_SIZE=$(($BASE_BLOCK_SIZE * $MULTIPLIER))
    echo "Running for block size $BLOCK_SIZE" >> results.txt
    MISS_RATE=$(../../d4-7/dineroIV -l1-dsize $L1_SIZE -l1-dbsize $BASE_BLOCK_SIZE -l2-dsize $L2_SIZE -l2-dbsize $BLOCK_SIZE -l1-dassoc $WAYS < ../trace.log | rg "Demand miss rate" | tail -n1 | cut -d" " -f11)
    echo "MISS_RATE: $MISS_RATE" >> results.txt
done
