                .data
A:              .word   1, 3, 1, 6, 4
                .word   2, 4, 3, 9, 5
mult:   .word   0

        .code
        daddi   $1, $0, A      ; *A[0]
        daddi   $5, $0, 1      ; $5 = 1 ;; i    
        daddi   $6, $0, 9      ; $6 = N - 1 ;; N = 10
        lw      $9, 0($1)      ; $9 = A[0]  ;; mult
        lw      $12, 8($1)     ; $12 = A[i]

loop:   dmul    $12, $12, $9   ; $12 = A[i]*mult
        daddi   $5, $5, 2      ; i += 2
        lw      $22, 16($1)    ; $22 = A[i+1]
        dadd    $9, $9, $12    ; mult = mult + A[i]*mult

        dmul    $22, $22, $9   ; $22 = A[i+1]*mult
        daddi   $1, $1, 16     ; 
        lw      $12, 8($1)     ; $12 = A[i+2]
        dadd    $9, $9, $22    ; mult = mult + A[i+1]*mult
        bne     $6, $5, loop   ; Exit loop if i == (N-1)

        ; 9 iters - missing 1
        dmul    $12, $12, $9   ; $12 = A[i]*mult
        dadd    $9, $9, $12    ; mult = mult + A[i]*mult
        
        sw      $9, mult($0)   ; Store result
        halt

;; Expected result: mult = f6180 (hex), 1008000 (dec)

