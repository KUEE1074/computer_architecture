.text
main:
    li $v0, 4
    la $a0, msg1
    syscall
    la $a1, c1r1
    li $t1, 0
    li $t0, 9

input:
    li $v0, 6
    syscall
    add $s0, $a1, $t1
    swc1 $f0, 0($s0)
    addi $t0, $t0, -1
    addi $t1, $t1, 4
    bgtz $t0, input

inverse:
    lwc1 $f1, c1r1
    lwc1 $f2, c1r2
    lwc1 $f3, c1r3
    lwc1 $f4, c2r1
    lwc1 $f5, c2r2
    lwc1 $f6, c2r3
    lwc1 $f7, c3r1
    lwc1 $f8, c3r2
    lwc1 $f9, c3r3
    lwc1 $f10, det

    mul.s $f13, $f1, $f5
    mul.s $f13, $f13, $f9

    mul.s $f14, $f2, $f6
    mul.s $f14, $f14, $f7

    mul.s $f15, $f3, $f4
    mul.s $f15, $f15, $f8

    mul.s $f16, $f3, $f5
    mul.s $f16, $f16, $f7

    mul.s $f17, $f2, $f4
    mul.s $f17, $f17, $f9

    mul.s $f18, $f1, $f6
    mul.s $f18, $f18, $f8

    add.s $f10, $f13, $f14
    add.s $f10, $f10, $f15
    sub.s $f10, $f10, $f16
    sub.s $f10, $f10, $f17
    sub.s $f10, $f10, $f18   ## $f10에 determinant값 입력  
    
    swc1 $f10, det 

    li.s $f19, 0.0      ## $f19에 0입력 
    swc1 $f10, det      
    c.eq.s $f10, $f19
    bc1t error          ## determinant값이 0이면 error로 jump

    mul.s $f20, $f5, $f9
    mul.s $f21, $f6, $f8
    sub.s $f22, $f20, $f21
    div.s $f22, $f22, $f10
    swc1 $f22, c1r1

    mul.s $f20, $f2, $f9
    mul.s $f21, $f3, $f8
    sub.s $f22, $f21, $f20
    div.s $f22, $f22, $f10
    swc1 $f22, c1r2

    mul.s $f20, $f2, $f6
    mul.s $f21, $f3, $f5
    sub.s $f22, $f20, $f21
    div.s $f22, $f22, $f10
    swc1 $f22, c1r3

    mul.s $f20, $f4, $f9
    mul.s $f21, $f6, $f7
    sub.s $f22, $f21, $f20
    div.s $f22, $f22, $f10
    swc1 $f22, c2r1

    mul.s $f20, $f1, $f9
    mul.s $f21, $f3, $f7
    sub.s $f22, $f20, $f21
    div.s $f22, $f22, $f10
    swc1 $f22, c2r2

    mul.s $f20, $f1, $f6
    mul.s $f21, $f3, $f4
    sub.s $f22, $f21, $f20
    div.s $f22, $f22, $f10
    swc1 $f22, c2r3

    mul.s $f20, $f4, $f8
    mul.s $f21, $f5, $f7
    sub.s $f22, $f20, $f21
    div.s $f22, $f22, $f10
    swc1 $f22, c3r1

    mul.s $f20, $f1, $f8
    mul.s $f21, $f2, $f7
    sub.s $f22, $f21, $f20
    div.s $f22, $f22, $f10
    swc1 $f22, c3r2

    mul.s $f20, $f1, $f5
    mul.s $f21, $f2, $f4
    sub.s $f22, $f20, $f21
    div.s $f22, $f22, $f10
    swc1 $f22, c3r3

    li $v0, 4
    la $a0, msg2
    syscall
    li $t1, 0
    li $t0, 3

print:
    add $s0, $a1, $t1
    li $v0, 2
    lwc1 $f12, 0($s0)
    syscall
    li $v0, 4
    la $a0, msg4
    syscall
    li $v0, 2
    lwc1 $f12, 4($s0)
    syscall
    li $v0, 4
    la $a0, msg4
    syscall
    li $v0, 2
    lwc1 $f12, 8($s0)
    syscall
    
    addi $t0, $t0, -1
    addi $t1, $t1, 12
    li $v0, 4
    la $a0, msg3
    syscall
    bgtz $t0, print
    j exit

error:
    li $v0, 4
    la $a0, msg5
    syscall
    j exit

exit:
    li $v0, 10
    syscall


.data
c1r1: .float 0.0
c1r2: .float 0.0
c1r3: .float 0.0
c2r1: .float 0.0
c2r2: .float 0.0
c2r3: .float 0.0
c3r1: .float 0.0
c3r2: .float 0.0
c3r3: .float 0.0
det: .float 0.0
msg1: .asciiz "***** 행렬의 성분 값을 입력해주세요 *****\n"
msg2: .asciiz "\n 역행렬 : \n "
msg3: .asciiz "\n"
msg4: .asciiz "  "
msg5: .asciiz "\n이 행렬은 역행렬이 존재하지 않습니다."
