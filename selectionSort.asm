.data
array: .word 64, 34, 25, 12, 22, 11, 90
size: .word 7
space: .asciiz " "
newline: .asciiz "\n"

.text
main:
    la $a0, array
    lw $t0, size
    beq $t0, $zero, end_program
    sll $t0, $t0, 2
    add $a1, $a0, $t0
    addi $a1, $a1, -4

    jal sort

    # Imprimir array ordenado
    la $t2, array         # puntero actual
    lw $t0, size
    move $t1, $zero       # contador i = 0
print_loop:
    beq $t1, $t0, print_done
    lw $a0, 0($t2)
    li $v0, 1
    syscall

    la $a0, space
    li $v0, 4
    syscall

    addi $t2, $t2, 4      # avanzar al siguiente elemento
    addi $t1, $t1, 1
    j print_loop
print_done:
    la $a0, newline
    li $v0, 4
    syscall

end_program:
    li $v0, 10
    syscall

# sort: ordena de forma recursiva del menor al mayor
sort:
    beq $a0, $a1, done
    slt $t0, $a1, $a0
    bne $t0, $zero, done

    addi $sp, $sp, -4
    sw $ra, 0($sp)

    jal max
    lw $t0, 0($a1)     # último elemento
    sw $t0, 0($v0)     # copiar último en posición max
    sw $v1, 0($a1)     # poner max al final

    addi $a1, $a1, -4
    jal sort

    lw $ra, 0($sp)
    addi $sp, $sp, 4
done:
    jr $ra

# max: encuentra la posición y valor del máximo en [$a0, $a1]
max:
    move $v0, $a0
    lw $v1, 0($v0)
    addi $t0, $a0, 4
loop:
    bgt $t0, $a1, ret
    lw $t1, 0($t0)
    slt $t2, $v1, $t1
    beq $t2, $zero, skip
    move $v0, $t0
    move $v1, $t1
skip:
    addi $t0, $t0, 4
    j loop
ret:
    jr $ra
