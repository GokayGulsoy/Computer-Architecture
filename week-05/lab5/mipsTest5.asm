
.data
msg1: .asciiz "\nenter first number\n"
msg2: .asciiz "enter second number\n"
res: .asciiz "the max is: "
eqnum: .asciiz "the numbers are equal"

.text

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
	
	
	beq $t0, $t1, printEq
	
	la $a0, res
	li $v0, 4
	syscall
	blt $t0, $t1, print1

print0:
	li $v0, 1
    	move $a0, $t0
    	syscall
	j exit
	
print1:
	li $v0, 1
    	move $a0, $t1
    	syscall
	j exit
	
printEq:
	la $a0, eqnum
	li $v0, 4
    	syscall
	j exit

exit:
	li $v0, 10
	syscall
	
