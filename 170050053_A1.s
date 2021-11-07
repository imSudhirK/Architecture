#A1
.data

prompt1: .asciiz  "Enter the size of the array\n"
prompt2: .asciiz  "Enter the elements of the array\n"

.align 2
arr: .space 200

.align 2
sb1: .space 200

.align 2
sb2: .space 200


.text

main:
    li $v0, 4               #to print string
    la $a0, prompt1         #printing prompt1
    syscall

    li $v0, 5               #take N-integer input
    syscall
    move $s0, $v0           #store N in $s0
    li $t0, 4               #temp  t0=4
    mul $s0, $s0, $t0       #space N*4

    li $v0, 4               # printing prompt2
    la $a0, prompt2
    syscall


    li $s3, 1               #answer = 1
    li $t0, 0               # iterator i for arr[i]

inpArr:
    li $s1, 1               #sb1i      a1 < a2
    sw $s1, sb1($t0)        #sb1i = 1
    li $s2, 1               #sb2i       a1 > a2
    sw $s2, sb2($t0)        #sb2i = 1
    li $v0, 5                   #take input
    syscall
    move $s5, $v0              #s5 for arr_i
    sw $v0,  arr($t0)            # store input
    li $t1, 0               # iterator j for j<i
forJloop:
    beq $t1, $t0, increase_i
    lw $s6, arr($t1)        #s6 = arr[j]
    blt $s6, $s5, sbi1      #update  sb1i if a_j< a_i
    blt $s5, $s6, sbi2      #update sb2i  if a_j >a_i
    j increase_j

sbi1:
    lw $t3, sb2($t1)           #t3 = sb2j
    addi $t3, $t3, 1          #t3 = sbi2 +1
    lw $s1, sb1($t0)
    bge $s1, $t3, increase_j   #sb1i = max(sb2j+1, sb1i)
    sw $t3, sb1($t0)
    j increase_j

sbi2:
    lw $t2, sb1($t1)           #t2 = sb1_j
    addi $t2, $t2, 1           #t2  +=1
    lw $s2, sb2($t0)
    bge $s2, $t2, increase_j   #sb2i = max(sb1j+1, sb2i)
    sw $t2, sb2($t0)

increase_j:
    addi $t1, $t1, 4        # j+=4 updated
    bne $t1, $t0, forJloop

update_ans:
    lw $t2, sb1($t0)
    lw $t3, sb2($t0)
    blt $t3, $t2, up1
    blt $t2, $t3, up2
    j increase_i

up1:
    blt $t2, $s3, increase_i
    move $s3, $t2
    j increase_i

up2:
    blt $t3, $s3, increase_i
    move $s3, $t3

increase_i:
    addi $t0, $t0, 4          # i +=1
    bne $t0, $s0, inpArr

    li $v0, 1
    move $a0, $s3
    syscall

    li $v0, 10
    syscall
