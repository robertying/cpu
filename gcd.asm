    j main
illop:
    j interrupt
xadr:
    j exception
main:
    lui $a0, 0x4000
    addi $t1, $0, 1
    addi $t2, $0, 2
    addi $t6, $0, 3
    add $t3, $0, $0
    add $s3, $0, $0
UART_receiver:
	addi $s6, $0, 0
receive:
    lw $t0, 32($a0)
    andi $t0, $t0, 8
    beq $t0, $0, receive
    beq $s6, $0, first_load
    lw $s1, 28($a0)
    j time
first_load:
    lw $s0, 28($a0)
    addi $s6, $s0, 1
    j receive
time:
    sw $zero, 8($a0)
    addi $t0, $0, -10000
    sw $t0, 0($a0)
    addi $t0, $0, -1
    sw $t0, 4($a0)
    sw $t6, 8($a0)
    add $s4, $0, $s0
    add $s5, $0, $s1
    slt $s2, $s0, $s1
    beq $s2, $0, judge
    add $s2, $s1, $0
    add $s1, $s0, $0
    add $s0, $s2, $0
judge:
	beq $s1, $0, exit0
	beq $s1, $t1, exit1
loop:
    sub $s2, $s0, $s1
    beq $s2, $0, exit
    slt $t4, $s2, $s1
    beq $t4, $t1, swap
    sub $s0, $s0, $s1
    j loop
swap:
    add $s0, $s1, $0
    add $s1, $s2, $0
    j loop
exit0:
    add $v0, $s0, $0
    j UART_sender
exit1:
    addi $v0, $0, 1
    j UART_sender
exit:
    add $v0, $s1, $0
    j UART_sender
UART_sender:
    sw $v0, 12($a0)
    sw $v0, 24($a0)
BCD_decode:
    addi $a2, $a1, 0
    beq $a2, $0, zero
    addi $a2, $a1, 1
    beq $a2, $0, one
    addi $a2, $a1, 2
    beq $a2, $0, two
    addi $a2, $a1, 3
    beq $a2, $0, three
    addi $a2, $a1, 4
    beq $a2, $0, four
    addi $a2, $a1, 5
    beq $a2, $0, five
    addi $a2, $a1, 6
    beq $a2, $0, six
    addi $a2, $a1, 7
    beq $a2, $0, seven
    addi $a2, $a1, 8
    beq $a2, $0, eight
    addi $a2, $a1, 9
    beq $a2, $0, nine
    addi $a2, $a1, 10
    beq $a2, $0, ten
    addi $a2, $a1, 11
    beq $a2, $0, eleven
    addi $a2, $a1, 12
    beq $a2, $0, twelve
    addi $a2, $a1, 13
    beq $a2, $0, thirteen
    addi $a2, $a1, 14
    beq $a2, $0, fourteen
    addi $a2, $a1, 15
    beq $a2, $0, fifteen
zero:
    addi $a3, $0,
    jr $ra
one:
    addi $a3, $0,
    jr $ra
two:
    addi $a3, $0,
    jr $ra
three:
    addi $a3, $0,
    jr $ra
four:
    addi $a3, $0,
    jr $ra
five:
    addi $a3, $0,
    jr $ra
six:
    addi $a3, $0,
    jr $ra
seven:
    addi $a3, $0,
    jr $ra
eight:
    addi $a3, $0,
    jr $ra
nine:
    addi $a3, $0,
    jr $ra
ten:
    addi $a3, $0,
    jr $ra
eleven:
    addi $a3, $0,
    jr $ra
twelve:
    addi $a3, $0,
    jr $ra
thirteen:
    addi $a3, $0,
    jr $ra
fourteen:
    addi $a3, $0,
    jr $ra
fifteen:
    addi $a3, $0,
    jr $ra
interrupt:
   lw $t8, 8($a0)
   addi $t7 , $0, -7
   and $t8, $t8, $t7
   sw $t8, 8($a0)
   bne $s3, $t6, back_jr
   addi $s3, $0, -1
 back_jr:
    addi $s3, $s3, 1
    jr $k0
one_high:
    sll $a1, $s4, 24
    srl $a1,$a1, 28
    jal BCD_decode
    addi $a3, $a3, 1920
    j back
one_low:
    sll $a1, $s4, 28
    srl $a1,$a1, 28
    jal BCD_decode
    addi $a3, $a3, 2944
    j back
two_high:
    sll $a1, $s5, 24
    srl $a1,$a1, 28
    jal BCD_decode
    addi $a3, $a3, 3456
two_low:
    sll $a1, $s5, 24
    srl $a1,$a1, 28
    jal BCD_decode
    addi $a3, $a3, 3712
exception:
    j exception
 UART_Sender:
 	sw $v0, 12($a0)
 	sw $v0, 24($a0)
 	j main