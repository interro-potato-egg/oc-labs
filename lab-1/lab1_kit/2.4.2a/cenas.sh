#/bin/sh

set -e

echo "" > results.txt

L1_BLOCK_SIZE=16
L1_SIZE=1024
L2_BLOCK_SIZE=128
L2_SIZE=$((1024*16))
WAYS=4

DINERO=$(../../d4-7/dineroIV -l1-dsize $L1_SIZE -l1-dbsize $L1_BLOCK_SIZE -l2-dsize $L2_SIZE -l2-dbsize $L2_BLOCK_SIZE -l1-dassoc $WAYS -l2-dccc < ../trace.log)

TOTAL_MISS_RATE=$(echo "$DINERO" | grep "Demand miss rate" | tail -n1 | cut -d" " -f11)
echo "TOTAL MISS RATE: $TOTAL_MISS_RATE" >> results.txt
for MISS_TYPE in "Capacity" "Conflict" "Compulsory"; do
    MISS_RATE=$(echo "$DINERO" | grep "$MISS_TYPE fraction" | tail -n1 | cut -f2)
    echo "$MISS_TYPE MISS RATE: $MISS_RATE">> results.txt
done
