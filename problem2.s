.text
main:
    li $s0, 0    ##heap안에 데이터 갯수
    la $a1, heap
    la $a2, out 
    
input:
    li $t7, 4
    li $v0, 4
    la $a0, msg1
    syscall
    addi $s0, $s0, 1  
    move $s1, $s0
    li $v0, 5
    syscall
    move $t1, $v0
    mul $t0, $s0, 4
    add $t0, $t0, $a1
    sw $t1, 0($t0)
    move $t2, $s0  
    li $v0, 4
    la $a0, msg2
    syscall
    
heapify_insert:     
    div $t3, $t2, 2        ## $t2 == current   ## $t3 == parent
    beq $t3, $zero, copy    ## $t2가 root인 경우 출력으로 이동
    
    mul $t0, $t2, 4
    add $t0, $t0, $a1
    lw $s3, 0($t0)    ## $s3 == current value
    mul $t0, $t3, 4
    add $t0, $t0, $a1
    lw $s4, 0($t0)    ## $s4 == parent value

    slt $t0, $s3, $s4
    beq $t0, $zero, swap1 
    j copy

print:                    ## sort 결과 print
    mul $t6, $s1, 4
    add $t6, $t6, $a2
    lw $t5, 0($t6)
    li $v0, 1
    move $a0, $t5
    syscall

    li $v0, 4
    la $a0, msg3
    syscall

    addi $s1, $s1, -1
    bgtz $s1, set
    j input
    
copy:                      ## heapify된 heap에서 out으로 data 복사
    add $t6, $a1, $t7
    lw $t5, 0($t6)
    add $t6, $a2, $t7
    sw $t5, 0($t6)
    addi $s1, $s1, -1
    addi $t7, $t7, 4
    bgtz $s1, copy
    move $s1, $s0 
    j set

set:                ## 최댓값을 뽑아 내고 다시 heapify하기 위한 setting        
    lw $t2, 4($a2)  ## root의 값
    mul $t6, $s1, 4
    add $t6, $t6, $a2
    lw $t3, 0($t6)  ## 말단노드의 값
    sw $t2, 0($t6)
    sw $t3, 4($a2)
    li $s3, 1       ### root 부터 heapify하기 위함
    j heapify_pop

heapify_pop:            ## top->bottom heapify
    mul $t8, $s3, 2     
    addi $t2, $t8, 0        ## left child의 index
    addi $t3, $t8, 1        ## right child의 index
    slt $t4, $t2, $s1       ## left child의 index가 배열 크기보다 
    beq $t4, $zero, print   ## 크거나 같으면 바로 print로 jump (child가 x)
    beq $t3, $s1, swap2     ## right child의 index가 배열 크기와 같으면 jump (child가 1개)
    j swap4                 ## 일반적인 경우(child가 둘다 있는 경우)

swap1:
    mul $t0, $t2, 4
    add $t0, $t0, $a1
    sw $s4, 0($t0)
    mul $t0, $t3, 4
    add $t0, $t0, $a1
    sw $s3, 0($t0)
    move $t2, $t3
    j heapify_insert

swap2:
    mul $t8, $s3, 4
    add $t8, $t8, $a2 
    lw $s5, 0($t8)      ## current node value
    mul $t9, $t2, 4
    add $t9, $t9, $a2 
    lw $s6, 0($t9)      ## left child node value
    slt $t6, $s5, $s6
    bne $t6, $zero, swap3   ## current < left_child 이면 swap3로 점프
    j print

swap3:              ## current와 left child값 변경
    sw $s5, 0($t9)
    sw $s6, 0($t8)
    j print

swap4:
    mul $t8, $t2, 4
    add $t8, $t8, $a2 
    lw $s5, 0($t8)      ## left child value
    mul $t9, $t3, 4
    add $t9, $t9, $a2 
    lw $s6, 0($t9)      ## right child value
    slt $s4, $s5, $s6   ## right, left 값 비교
    beq $s4, $zero, win_left
    j win_right

win_left:  ## left > right
    mul $t9 $s3, 4
    add $t9, $t9, $a2 
    lw $t3, 0($t9)       ## root
    slt $t4, $t3, $s5
    beq $t4, $zero, print
    sw $s5, 0($t9)
    sw $t3, 0($t8) 
    move $s3, $t2
    j heapify_pop

win_right: ## left < right
    mul $t8 $s3, 4
    add $t8, $t8, $a2 
    lw $t3, 0($t8)       ## root
    slt $t4, $t3, $s6
    beq $t4, $zero, print
    sw $s6, 0($t8)
    sw $t3, 0($t9)
    move $s3, $t3
    j heapify_pop

.data
heap: .space 100
out: .space 100
msg1: .asciiz "\n숫자를 입력하세요 "
msg2: .asciiz "Heap sort출력 결과 "
msg3: .asciiz " "
