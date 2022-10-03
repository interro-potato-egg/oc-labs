#/bin/sh

set -e

echo "" > results.txt

FRAME_MEMORY_COST=0.00125

for BYTE in 256 512 1024
do
    for BLOCK_SIZE in 8 16 32 64
    do
        echo "Running for BYTE = $BYTE and BLOCK_SIZE = $BLOCK_SIZE" | tee -a results.txt
        MISS_RATE=$(../../d4-7/dineroIV -l1-dsize $BYTE -l1-dbsize $BLOCK_SIZE -l1-dccc < ../trace.log | grep "Demand miss rate" | cut -d" " -f11)
        PRICE=$(echo "scale=10; $FRAME_MEMORY_COST + ((10 * $BYTE) / (2^20))" | bc)
        COST=$(echo "scale=10; $PRICE * $MISS_RATE" | bc)
        echo "MISS_RATE: $MISS_RATE" >> results.txt
        echo "PRICE: $PRICE" >> results.txt
        echo "COST: $COST" >> results.txt
    done
done

CHEAPEST_COST=$(grep "COST" results.txt | cut -d" " -f2 | sort -n | head -n1)
SECOND_CHEAPEST_COST=$(grep "COST" results.txt | cut -d" " -f2 | sort -n | head -n2 | tail -n1)

echo "CHEAPEST_COST: $CHEAPEST_COST" >> results.txt
echo "SECOND_CHEAPEST_COST: $SECOND_CHEAPEST_COST" >> results.txt
