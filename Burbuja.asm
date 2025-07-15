.data
vector:     .space 40          # Reserva espacio para maximo 10 enteros (10 * 4 bytes)
msg_tam:    .asciiz "Ingrese el tama�o del vector (minimo 1 y maximo 10): "
msg_error:  .asciiz "Error: Tama�o inv�lido.\n"
msg_elemento: .asciiz "Ingrese el elemento: "
msg_resultado: .asciiz "Vector ordenado: "
espacio:    .asciiz " "         # Espacio para separar elementos al imprimir
salto:      .asciiz "\n"        # Salto de l�nea

.text
.globl main

main:
    
    li $v0, 4
    la $a0, msg_tam           # Solicitar tama�o del vector
    syscall
    
    li $v0, 5                 # Leer tama�o
    syscall
    move $s0, $v0             # Guarda tama�o en $s0
    
    blez $s0, error           # Si $s0 <= 0, error
    li $t0, 10
    bgt $s0, $t0, error       # Si $s0 > 10, error
    
    la $s1, vector            # $s1 = direcci�n base
    li $t0, 0                 # $t0 = �ndice (i = 0)

loop_input:
    beq $t0, $s0, preparar_ordenamiento
    
    li $v0, 4
    la $a0, msg_elemento      # Solicitar elemento
    syscall
    
    li $v0, 5                 # Leer elemento
    syscall

    sw $v0, 0($s1)             # Almacena en vector[i]
    addi $s1, $s1, 4           # Mueve puntero
    addi $t0, $t0, 1           # i++
    j loop_input

preparar_ordenamiento:
    la $s1, vector             # Restaurar direcci�n base
    jal bubble_sort            # Llamar a rutina de ordenamiento

print_init:
    li $t0, 0                  # Reiniciar �ndice
    la $s1, vector             # Reiniciar puntero
    
    li $v0, 4
    la $a0, msg_resultado      # Imprimir encabezado
    syscall

loop_print:
    beq $t0, $s0, exit
   
    lw $a0, 0($s1)
    li $v0, 1                 # Imprimir elemento
    syscall
    
    li $v0, 4                 # Imprimir espacio
    la $a0, espacio
    syscall
    
    addi $s1, $s1, 4
    addi $t0, $t0, 1         # Actualizar puntero e �ndice
    j loop_print

error:
    
    li $v0, 4                # Manejo de error
    la $a0, msg_error
    syscall
    j main                   # Volver a solicitar

exit:
    
    li $v0, 4                # Salto de l�nea final
    la $a0, salto
    syscall

    # Terminar programa
    li $v0, 10
    syscall

#============================================= ALGORITMO BURBUJA =============================================
bubble_sort:
    addi $t0, $s0, -1        # $t0 = n-1 (contador externo)
    li $t3, 0                # Bandera de intercambios

outer_loop:
    li $t3, 0                # Reset bandera
    li $t1, 0                # $t1 = j (contador interno)

inner_loop:
    bge $t1, $t0, end_inner  # Salir si j >= n-1
    
    sll $t4, $t1, 2          # Offset = j * 4
    add $t4, $s1, $t4        # Direcci�n de vector[j]
    lw $t5, 0($t4)           # $t5 = vector[j]
    lw $t6, 4($t4)           # $t6 = vector[j+1]
    
    ble $t5, $t6, no_swap    # Saltar si ordenados
    
    sw $t6, 0($t4)
    sw $t5, 4($t4)           # Intercambiar elementos
    li $t3, 1                # Marcar intercambio
    
no_swap:
    addi $t1, $t1, 1         # j++
    j inner_loop

end_inner:
    beqz $t3, end_sort       # Si no hubo intercambios, terminar
    addi $t0, $t0, -1        # Reducir rango
    bgtz $t0, outer_loop     # Continuar si quedan elementos

end_sort:
    jr $ra                   # Regresar al caller
