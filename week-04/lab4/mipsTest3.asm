
.data
msg1: .asciiz "\nenter the first number\n"
msg2: .asciiz "enter the second number\n"
msg3: .asciiz "enter the third number\n"
res: .asciiz "average is: "

.text
.globl main
		
main:   
	la $a0, msg1
	li $v0, 4
    syscall
	
	li $v0, 5
	syscall
	move $t0, $v0
	
	la $a0, msg2
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	move $t1, $v0
	
	la $a0, msg3
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	move $t2, $v0
	
	add $s0, $t0, $t1
	add $s0, $s0, $t2
	
	li $t0, 3
    div $s0, $t0
	mflo $s0
	
	la $a0, res
	li $v0, 4
	syscall
	
	li $v0, 1
    move $a0, $s0
    syscall
	
	li $v0, 10
	syscall
	