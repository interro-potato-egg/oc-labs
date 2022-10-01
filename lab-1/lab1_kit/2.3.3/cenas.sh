#/bin/sh

echo "" > results.txt

BYTE=1024
PRICE=$(echo "scale=10; 10/$BYTE + 0.01/8" | bc)

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
        AMAT_RIGHT=$(echo "scale=10; $TOTAL_MISS_RATE * 140" | bc)
        AMAT_LEFT=$(echo "scale=10; 2 * (0.7 + 0.35 * (l($WAYS) / l(10)))" | bc -l)
        AMAT=$(echo "scale=10; $AMAT_LEFT + $AMAT_RIGHT" | bc)
        echo "AMAT, with $WAYS ways: $AMAT" >> results.txt
        COST=$(echo "scale=10; $PRICE * $AMAT" | bc) # from EQ.1, as suggested in the question's statement
        echo "COST: $COST" >> results.txt
        echo "---" >> results.txt
    done
done

echo "Price, for both configs, is $PRICE" >> results.txt