.globl main
.data
	pedirTam: .asciiz "Ingrese el tamano del arreglo: "
	pedirElemI: .asciiz "Ingrese un numero: "
	msg_error: .asciiz "ERROR. Valor invalido"
	salto: .asciiz "\n"
	espacio: .asciiz " "
	vector: .word 0:10 #vector que almacena 10 elementos (4 bytes * elem)	#para fines academicos se puso limite de 10 elementos, 
										#pero esto se puede incrementar segun la cantidad de elemntos se necesite 
										#(no numeros muy grandes porque se desborda)		
	test: .asciiz "fin.\n"
.text

main:
	#imprime msg para pedir el tamaño n del vector
	li $v0,4
	la $a0,pedirTam
	syscall
	#recibe entrada
	li $v0,5
	syscall
	move $s0,$v0	#s0 = n
	
	#Errores
	blez $s0, error #numero < 0
	li $t0,10
	bgt $s0,$t0, error	#numero > tamaño total del arreglo
	
	li $t0,0	#t0 = i =0
	la $s1,vector	#s1 = V[]
	
	#ciclo para llenar el vecotr
getElemFor:
	beq $t0,$s0, exitGetElem
	
	#imprime pedir elemento i
	li $v0,4
	la $a0,pedirElemI
	syscall
	#guada entrada en v0
	li $v0,5
	syscall
	#guarda valor en el arreglo (s1)
	sll $t1,$t0,2
	add $t1,$s1,$t1
	sw $v0, 0($t1)
	
	#aumenta el contador
	addi $t0,$t0,1
	
	j getElemFor
	
exitGetElem:
	move $a0, $s0 	#a0 = n
	move $a1, $s1	#a1 = arr
	
	jal selectionSort
	
	li $t0,0	#contador inicializado en 0
	move $s0, $a0	#s0 = n

printElemFor:
	beq $t0,$s0, fin
	
	#imprime los valores
	sll $t1,$t0,2
	add $t1,$a1,$t1
	lw $a0, 0($t1)
	
	li $v0,1
	syscall
	
	#imprime espacio en banco
	li $v0,4
	la $a0,espacio
	syscall
	
	#amumenta el contador
	addi $t0,$t0,1
	
	j printElemFor
	
fin:
	li $v0,10
	syscall
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

error:
	#imprime mensaje de error
	li $v0,4
	la $a0,msg_error
	syscall
	
	j fin
	
selectionSort:
	li $s0,1	#s0 = 1, step = 1
for:
	bge $s0,$a0, exitFor	#si  step >= n saltar a exit
	
	#asignacion key = arr[step]
	sll $t0,$s0,2
	add $t0,$a1,$t0
	lw $s1, 0($t0)	#s1 = key = arr [step]
	
	#j = step -1
	addi $s2, $s0, -1
	addi $s0,$s0,1

while:
	bltz $s2, exitWhile #si j < 0 sal del ciclo
	
	#asignacion arr[j]
	sll $t1,$s2,2
	add $t1,$a1,$t1
	lw $t2, 0($t1)	#t2 = arr[j]
	
	bge $s1,$t2, exitWhile #si key >= arr[j] sal del ciclo
	
	#j = j+1
	addi $t3,$s2,1
	
	#mover elementos del vector
	sll $t3,$t3,2
	add $t3,$a1,$t3
	sw $t2, 0($t3) #arr[j+1] = arr[j]
	
	#j = j-1
	addi $s2,$s2,-1
	j while
	
exitWhile:
	#j = j+1
	addi $t3,$s2,1
	# arr[j+1] = key
	sll $t3,$t3,2
	add $t3,$a1,$t3
	sw $s1, 0($t3)	#arr[j+1] = key
	
	j for

exitFor:
	jr $ra
	
	
	
	
