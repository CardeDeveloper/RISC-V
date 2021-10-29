lui s0,0x10100
ori s1, s0, 0x24
addi s2, zero, 0x1
andi s3,s2,0
xori s4,s3,1
slli t0, s2,4
slli t1, s3,4
sub t2, t0,t1
lui s5,0x10010
sw s2,0(s5)
lw t4, 0(s5)
bne s0,s5,salto 
addi s2, s2, 0x1
salto: jal ra,exit
exit:
