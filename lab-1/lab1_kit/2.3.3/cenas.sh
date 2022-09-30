#/bin/sh

echo "" > results.txt

BYTE=1024

for WAYS in 1 2 4 8
do
    for BLOCK_SIZE in 8 16
    do
        echo "Running for $BYTE B, BLOCK_SIZE = $BLOCK_SIZE and WAYS = $WAYS" >> results.txt
        DINERO=$(../../d4-7/dineroIV -l1-dsize 1024 -l1-dbsize $BLOCK_SIZE -l1-dassoc $WAYS -l1-dccc < ../trace.log)
        MISS_RATE=$(echo "$DINERO" | rg "Demand miss rate" | cut -d" " -f11)
        TOTAL_MISS_RATE=0
        for MISS_TYPE in "Compulsory" "Conflict" "Capacity"
        do
            FRACTION=$(echo "$DINERO" | rg "$MISS_TYPE fraction" | cut -f2)
            PERCENTAGE=$(echo "$FRACTION * 100" | bc -l)
            TYPE_MISS_RATE=$(echo "scale=10; $MISS_RATE * $FRACTION" | bc)
            echo "$MISS_TYPE miss rate, with $WAYS ways: $TYPE_MISS_RATE" >> results.txt
            echo "$MISS_TYPE RELATIVE miss rate (% among types), with $WAYS ways: $PERCENTAGE" >> results.txt
            TOTAL_MISS_RATE=$(echo "scale=10; $TOTAL_MISS_RATE + $TYPE_MISS_RATE" | bc)
        done
        echo "Total miss rate, with $WAYS ways: $TOTAL_MISS_RATE" >> results.txt
    done
done