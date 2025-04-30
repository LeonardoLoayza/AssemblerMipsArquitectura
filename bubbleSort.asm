.data
# Ejemplo de arreglo
array: .word 5, 3, 8, 1, 2
n:     .word 5

.text
.globl main

main:
    la $a0, array             # Dirección de inicio
    lw $t0, n                 # Número de elementos
    mul $t0, $t0, 4           # Tamaño en bytes
    add $a1, $a0, $t0         # Dirección después del último elemento
    sub $a1, $a1, 4           # Dirección del último elemento real

    jal bubble_sort

    # Termina programa
    li $v0, 10
    syscall


# Procedimiento: bubble_sort($a0 = inicio, $a1 = fin)
bubble_sort:
    # Stack frame
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s0, 4($sp)

outer_loop:
    move $s0, $a0            # $s0 = current_start (ptr)
    li $t7, 0                # swap_flag = 0

inner_loop:
    # Salir si $s0 >= $a1
    bge $s0, $a1, end_inner_loop

    lw $t1, 0($s0)           # t1 = *s0
    lw $t2, 4($s0)           # t2 = *(s0 + 4)

    ble $t1, $t2, no_swap

    # Intercambio
    sw $t2, 0($s0)
    sw $t1, 4($s0)
    li $t7, 1                # swap_flag = 1

no_swap:
    addi $s0, $s0, 4         # s0 += 4
    blt $s0, $a1, inner_loop

end_inner_loop:
    beqz $t7, done           # Si no hubo swaps, salir
    subi $a1, $a1, 4         # Reduce final ptr (último ya está en su lugar)
    j outer_loop

done:
    # Restaurar stack
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    addi $sp, $sp, 8
    jr $ra
