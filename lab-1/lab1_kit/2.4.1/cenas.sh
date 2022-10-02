#/bin/sh

echo "" > results.txt

# FRAME_MEMORY_COST=0.00125
BASE_BLOCK_SIZE=16
L1_SIZE=1024
L2_SIZE=$((1024*16))

for MULTIPLIER in 1 2 4 8
do
    BLOCK_SIZE=$(($BASE_BLOCK_SIZE * $MULTIPLIER))
    echo "Running for block size $BLOCK_SIZE" >> results.txt
    MISS_RATE=$(../../d4-7/dineroIV -l1-dsize $L1_SIZE -l1-dbsize $BASE_BLOCK_SIZE -l2-dsize $L2_SIZE -l2-dbsize $BLOCK_SIZE < ../trace.log | rg "Demand miss rate" | tail -n1 | cut -d" " -f11)
    # PRICE=$(echo "scale=10; $FRAME_MEMORY_COST + (10/(1024*1024) * $BYTE)" | bc)
    # COST=$(echo "scale=10; $PRICE * $MISS_RATE" | bc)
    echo "MISS_RATE: $MISS_RATE" >> results.txt
    # echo "PRICE: $PRICE" >> results.txt
    # echo "COST: $COST" >> results.txt
done

# CHEAPEST_COST=$(cat results.txt | rg "COST" | cut -d" " -f2 | sort -n | head -n1)
# SECOND_CHEAPEST_COST=$(cat results.txt | rg "COST" | cut -d" " -f2 | sort -n | head -n2 | tail -n1)

# echo "CHEAPEST_COST: $CHEAPEST_COST" >> results.txt
# echo "SECOND_CHEAPEST_COST: $SECOND_CHEAPEST_COST" >> results.txt
