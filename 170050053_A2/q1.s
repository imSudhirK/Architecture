.data

promptN: .asciiz "Enter n:​ "
promptR: .asciiz "Enter r:​ "
promptW: .asciiz "\nWish to continue?:​ "
C: .asciiz "C"
coln: .asciiz ": "
newline: .asciiz "\n"


.text
.globl main

main:
#------------------------- prompt and input
    li $v0, 4
    la $a0, promptN
    syscall

    li $v0, 5
    syscall
    move $t0, $v0          #$t0 for N

    li $v0, 4
    la $a0, promptR
    syscall

    li $v0, 5
    syscall
    move $t1, $v0          #$t1 for R

#------------------------- call function ncr
    jal ncr

#------------------------- print return values
    move $s3, $v0          #store ans temporarily

    li $v0, 1
    move $a0, $t0         #print N
    syscall
    li $v0, 4
    la $a0, C              #print C
    syscall
    li $v0, 1
    move $a0, $t1          #print r
    syscall
    li $v0, 4
    la $a0, coln            #print :_
    syscall

    li $v0, 1
    move $a0, $s3
    syscall

#------------------------- want ot repeat for another N, R
    li $v0, 4
    la $a0, promptW           #print promptW
    syscall

    li $t2, 'Y'
    li $v0, 12              #input Y for yes, N for NO
    syscall

    move $t5 $v0
    li $v0, 5
    syscall

    bne $t5, $t2, exit        # Y
    
    li $v0, 4
    la $a0, newline        #print newline
    syscall

    j main

#------------------------- exit if N
exit:
    li $v0, 10
    syscall

ncr:
#------------------------- stack to store previous values
    addi $sp, $sp, -16
    sw $ra, 0($sp)              #return address
    sw $t0, 4($sp)              # N
    sw $t1, 8($sp)              # R

    bgt $t1, $t0, ret0          #if r > n

    beq $t1, $0, ret1           #if r<=n && r==1


    addi $t0, $t0, -1           # n = n-1
    addi $t1, $t1, -1           # r = r-1
    jal ncr

    sw $v0, 12($sp)             #store first value safe

    lw $t0, 4($sp)             # retrieve n
    lw $t1, 8($sp)             # retrieve r
    addi $t0, $t0, -1          # n = n-1
    jal ncr

    lw $t3, 12($sp)
    add $v0, $v0, $t3          # return sum of both


exit_ncr:
#------------------------retrieve values
    lw $ra, 0($sp)
    lw $t0, 4($sp)              # N
    lw $t1, 8($sp)              # R
    addi $sp $sp, 16            # stack pointer

    jr $ra

ret0:
#-----------------if r > n return 0
    li $v0, 0
    j exit_ncr

ret1:
#----------------if r<=n && r==1  return 1
    li $v0, 1
    j exit_ncr
