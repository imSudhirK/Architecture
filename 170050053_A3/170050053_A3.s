#Q-1
#--------------5 Stage, without forwarding or hazard detection:
li t0, 10
li t1, 1
li t2, 5
nop
nop
nop
nop
add t1, t2, t0
add s0, t1, t0



#Q2
#-----------------5 Stage, without forwarding, with hazard detection

#part - a
#give stalls without forwarding
#and no stalls when forwarding
li t0, 10
li t1, 1
li t2, 5
nop
nop
nop
nop
add t1, t2, t0
lw s0, 0(t1)

#part - b
#-----needs stalls
li t2, 5
li t0, 10
li t1, 1
nop
nop
nop
nop
add t1, t2, t0

add s0, t1, t0

add s1, t2, t0
add a0, t2, t0

#after rearrange
#no need of stalls
li t2, 5
li t0, 10
li t1, 1
nop
nop
nop
nop
add t1, t2, t0

add s1, t2, t0
add a0, t2, t0

add s0, t1, t0



#Q-3
#part-e
#code snippet after modification
li t0 2
li t1 10
add t0 t0 t1
li t2 5
add t2 t0 t2
li a7 1
add a0 t2 x0
nop
nop
nop
ecall


#Q-4
#code
#num cycles = 29
#num registers = 5
li t1 1
li t2 2
li a0 3
li s0 4
add t1 t1 t2
li t2 5
add a0 a0 s0
li s0 6
add t1 t1 t2
li t2 7
add a0 a0 s0
li s0 8
add t1 t1 t2
li t2 9
add a0 a0 s0
li s0 10
add t1 t1 t2
li a7 1
add a0 a0 s0
add a0 a0 t1
ecall
