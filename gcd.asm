    j main
    j interrupt
    j exception
main:
    lui $s0, 0x4000
    lui $s1, 0x4000
    addi $s1, $a1, 0x0002
timer:
    sw $0, 8($s0)
    addi $t0, $0, -1000
    sw $t0, 0($s0)
    addi $t0, $0, -1
    sw $t0, 4($s0)
    addi $t0, $0, 3
    sw $t0, 8($s0)
    add $v0, $0, $0
UART_receiver1:
    lw $t0, 32($s0)
    and $t1, $t0, $s1
    beq $t1, $0, UART_receiver1
    lw $a0, 28($s0)
UART_receiver2:
    lw $t0, 32($s0)
    and $t1, $t0, $s1
    beq $t1, $0, UART_receiver2
    lw $a1, 28($s0)
    add $a2, $0, $a0
    add $a3, $0, $a1
    j judge
div:
    sub $t1, $a0, $a1
    blez $t1, swap
    add $a0, $t1, $0
    j judge
swap:
    add $t1, $a1, $0
    add $a1, $a0, $0
    add $a0, $t1, $0
judge:
    bne $a0, $a1, div
    add $v0, $a0, $0
UART_sender:
    sw $v0, 12($s0)
    sw $v0, 24($s0)
foever_loop:
    add $v1, $0, $0,
    j foever_loop
exception:
    jr $k1
interrupt:
    addi $t5, $0, -7
    lui $s7, 0x4000
    lw $t6, 8($s7)
    and $t5, $t5, $t6
    sw $t5, 8($s7)
    lw $t5, 12($s7)
    andi $s6, $t5, 0x0F00
    addi $t6, $0, 0x100
    beq $s6, $0, one_high
    beq $s6, $t6, one_low
    sll $t6, $t6, 1
    beq $s6, $t6, two_high
    sll $t6, $t6, 1
    beq $s6, $t6, two_low
    sll $t6, $t6, 1
    beq $s6, $t6, one_high
one_high:
    andi $t7, $a3, 0x00F0
    srl $t7, $t7, 4
    jal BCD_decode
    addi $t7, $t7, 0x0100
    sw $t7, 14($s7)
    j exit
one_low:
    andi $t7, $a3, 0x000F
    jal BCD_decode
    addi $t7, $t7, 0x0200
    sw $t7, 14($s7)
    j exit
two_high:
    andi $t7, $a2, 0x00F0
    srl $t7, $t7, 4
    jal BCD_decode
    addi $t7, $t7, 0x0400
    sw $t7, 14($s7)
    j exit
two_low:
    andi $t7, $a2, 0x000F
    jal BCD_decode
    addi $t7, $t7, 0x0800
    sw $t7, 14($s7)
    j exit
BCD_decode:
    addi $t5, $t7, 0
    beq $t5, $0, zero
    addi $t5, $t7, -1
    beq $t5, $0, one
    addi $t5, $t7, -2
    beq $t5, $0, two
    addi $t5, $t7, -3
    beq $t5, $0, three
    addi $t5, $t7, -4
    beq $t5, $0, four
    addi $t5, $t7, -5
    beq $t5, $0, five
    addi $t5, $t7, -6
    beq $t5, $0, six
    addi $t5, $t7, -7
    beq $t5, $0, seven
    addi $t5, $t7, -8
    beq $t5, $0, eight
    addi $t5, $t7, -9
    beq $t5, $0, nine
    addi $t5, $t7, -10
    beq $t5, $0, ten
    addi $t5, $t7, -11
    beq $t5, $0, eleven
    addi $t5, $t7, -12
    beq $t5, $0, twelve
    addi $t5, $t7, -13
    beq $t5, $0, thirteen
    addi $t5, $t7, -14
    beq $t5, $0, fourteen
    addi $t5, $t7, -15
    beq $t5, $0, fifteen
zero:
    addi $t7, $0, 0x0040
    jr $ra
one:
    addi $t7, $0, 0x0079
    jr $ra
two:
    addi $t7, $0, 0x0024
    jr $ra
three:
    addi $t7, $0, 0x0030
    jr $ra
four:
    addi $t7, $0, 0x0019
    jr $ra
five:
    addi $t7, $0, 0x0012
    jr $ra
six:
    addi $t7, $0, 0x0002
    jr $ra
seven:
    addi $t7, $0, 0x0078
    jr $ra
eight:
    addi $t7, $0, 0x0000
    jr $ra
nine:
    addi $t7, $0, 0x0010
    jr $ra
ten:
    addi $t7, $0, 0x0008
    jr $ra
eleven:
    addi $t7, $0, 0x0003
    jr $ra
twelve:
    addi $t7, $0, 0x0046
    jr $ra
thirteen:
    addi $t7, $0, 0x0021
    jr $ra
fourteen:
    addi $t7, $0, 0x0006
    jr $ra
fifteen:
    addi $t7, $0, 0x000E
    jr $ra
exit:
    lui $s7, 0x4000
    lw $t6, 8($s7)
    addi $t7, $0, 2
    or $t6, $t7, $t6
    sw $t6, 0($s7)
    jr $k0
