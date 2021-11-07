.data

promptA: .asciiz "Enter a:​ "
promptM: .asciiz "Enter m:​ "
promptW: .asciiz "\nWish to continue?:​ "

star: .asciiz "*"
eqmod: .asciiz "= 1 (mod "
cb: .asciiz ")"
newline: .asciiz "\n"

.text
.globl main

main:
#------------------------- prompt and input
    li $v0, 4
    la $a0, promptA
    syscall

    li $v0, 5
    syscall

    move $s0, $v0           #$s0 for a
    move $s2, $v0           #$s2 for a0

    li $v0, 4
    la $a0, promptM
    syscall

    li $v0, 5
    syscall

    move $s1, $v0           #$s1 for m
    move $s4, $s1           #$s4 for m0

mmi:
#------------------------- modular multiplicative inverse function
    beq $s1, 1, ret_0       #if m==1
    li $t0, 0               #helper value u
    li $t1, 1               #return value v
    blt $s0, 2, ret_v       #if a < 2

loop:
    div $s0, $s1
    move $s0, $s1           # a = m
    mfhi $s1                #m = a%m
    mflo $t4                #q = a/m

    move $t3, $t0           #temp = u
    mul $t0, $t4, $t0       # u = u*q
    sub $t0, $t1, $t0       #u = v - u
    move $t1, $t3           # v = temp

    bgt $s0, 1, loop
    j ret_v


ret_0:
#--------------------------if m==1 return v = 0
    li $t1, 0
    j exit_mmi

ret_v:
#------------------------- if a <=1 return +ve v
    blt $t1, 0, add_m0     #if v < 0
    j exit_mmi

add_m0:
    add $t1, $t1, $s4       #positive result

exit_mmi:
#------------------------- print return values
    li $v0, 1              #print a0
    move $a0, $s2
    syscall

    li $v0, 4              #print *
    la $a0, star
    syscall

    li $v0, 1              #answer
    move $a0, $t1
    syscall

    li $v0, 4              #print =( mod
    la $a0, eqmod
    syscall

    li $v0, 1              #print m0
    move $a0, $s4
    syscall

    li $v0, 4             #print )
    la $a0, cb
    syscall
#------------------------- want to repeat for another a0, m0
    li $v0, 4
    la $a0, promptW        #print promptW
    syscall

    li $t2, 'Y'
    li $v0, 12              #input Y for yes, N for NO
    syscall

    move $t5 $v0            #for enter functionality
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
