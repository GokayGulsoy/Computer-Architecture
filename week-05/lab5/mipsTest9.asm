#Taken from the youtube channel Amell Peralta on 3-Nov-2021 https://www.youtube.com/watch?v=B6ky4Weahm4

.data
msg1: .asciiz "\nEnter a number to find its factorial: "
msg2: .asciiz "\nThe factorial is: "
theNumber: .word 0
theAnswer: .word 0

.text

main:
    li $v0,  4
    la $a0,  msg1
    syscall             
	
    li $v0,  5
    syscall             
    sw $v0, theNumber

	#call the function
    lw $a0, theNumber
	jal factorial
	sw $v0, theAnswer

	#display result
    li $v0, 4
	la $a0, msg2
	syscall
	li $v0, 1
	lw $a0, theAnswer
	syscall

    li $v0, 10
    syscall

factorial:
    subu $sp, $sp, 8 
    sw   $ra, 0($sp)
    sw   $s0, 4($sp)

    #base case
	li $v0, 1
	beq $a0, $zero, factorialDone
	
	#recursion
	move $s0, $a0
	sub $a0, $a0, 1
	jal factorial
	
	#operation in rewind
	mul $v0, $s0, $v0
	
	factorialDone:
		lw $ra, 0($sp)
		lw $s0, 4($sp)
		addu $sp, $sp, 8
		jr $ra
