#/bin/sh

echo "" > results.txt

L1_BLOCK_SIZE=16
L1_SIZE=1024
L2_BLOCK_SIZE=128
L2_SIZE=$((1024*16))
WAYS=4
PRICE=0.0172656
MEMORY_TIME=140

../../d4-7/dineroIV -l1-dsize $L1_SIZE -l1-dbsize $L1_BLOCK_SIZE -l2-dsize $L2_SIZE -l2-dbsize $L2_BLOCK_SIZE -l1-dassoc $WAYS < ../trace.log > dump.log

L1_MISS_RATE=$(cat dump.log | rg -m1 "Demand miss rate" | cut -d" " -f11)
L2_MISS_RATE=$(cat dump.log | rg "Demand miss rate" | tail -n1 | cut -d" " -f11)
echo "L1 miss rate: $L1_MISS_RATE" >> results.txt
echo "L2 miss rate: $L2_MISS_RATE" >> results.txt
TOTAL_MISS_RATE=$(echo "scale=10; $L1_MISS_RATE * $L2_MISS_RATE" | bc -l)
echo "TOTAL MISS RATE: $TOTAL_MISS_RATE" >> results.txt
L1_HIT_TIME=$(echo "scale=10; 2 * (0.7 + 0.35 * l($WAYS) / l(2))" | bc -l)
L2_HIT_TIME=$(echo "scale=10; 10 * (0.7 + 0.55 * l($WAYS) / l(2))" | bc -l)
echo "L1 hit time: $L1_HIT_TIME" >> results.txt
echo "L2 hit time: $L2_HIT_TIME" >> results.txt
AMAT=$(echo "scale=10; $L1_HIT_TIME + ($L1_MISS_RATE * $L2_HIT_TIME) + ($L1_MISS_RATE * $L2_MISS_RATE * $MEMORY_TIME)" | bc -l)
COST=$(echo "scale=10; $AMAT * $PRICE" | bc -l)
echo "AMAT: $AMAT" >> results.txt
echo "PRICE: $PRICE" >> results.txt
echo "COST: $COST" >> results.txt