.data
Enter:	.asciiz	"
"
base:
.text
.data
V0:
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	5
.text
L0:
	sw	$fp	0($sp)
	addi	$sp	$sp	-4
	move	$fp	$sp
	sw	$ra	0($sp)
	addi	$sp	$sp	-4
.data
V1:	.asciiz	"Before x="
.text
	li	$v0	4
	la	$a0	V1
	syscall
	lw	$t3	8($fp)
	add	$t3	$t3	52
	sw	$t3	0($sp)
	addi	$sp	$sp	-4
	li	$t2	0
	lw	$t3	4($sp)
	addi	$sp	$sp	4
	add	$t1	$t3	$t2
	lw	$t1	0($t1)
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	li	$v0	1
	lw	$a0	4($sp)
	addi	$sp	$sp	4
	syscall
	li	$v0	4
	la	$a0	Enter
	syscall
	lw	$t3	8($fp)
	add	$t3	$t3	52
	sw	$t3	0($sp)
	addi	$sp	$sp	-4
	li	$t2	0
	lw	$t3	4($sp)
	addi	$sp	$sp	4
	add	$t1	$t3	$t2
	lw	$t1	0($t1)
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	lw	$t3	8($fp)
	add	$t3	$t3	52
	sw	$t3	0($sp)
	addi	$sp	$sp	-4
	li	$t2	0
	lw	$t3	4($sp)
	addi	$sp	$sp	4
	add	$t1	$t3	$t2
	lw	$t1	0($t1)
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	lw	$t1	4($sp)
	addi	$sp	$sp	4
	lw	$t2	4($sp)
	addi	$sp	$sp	4
	mul	$t1	$t2	$t1
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	lw	$t3	8($fp)
	add	$t3	$t3	52
	sw	$t3	0($sp)
	addi	$sp	$sp	-4
	li	$t2	0
	lw	$t3	4($sp)
	addi	$sp	$sp	4
	add	$t2	$t3	$t2
	lw	$t1	4($sp)
	addi	$sp	$sp	4
	sw	$t1	0($t2)
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	lw	$t1	4($sp)
	addi	$sp	$sp	4
	li	$t1	1
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	lw	$t3	8($fp)
	add	$t3	$t3	48
	sw	$t3	0($sp)
	addi	$sp	$sp	-4
	li	$t2	0
	lw	$t3	4($sp)
	addi	$sp	$sp	4
	add	$t2	$t3	$t2
	lw	$t1	4($sp)
	addi	$sp	$sp	4
	sw	$t1	0($t2)
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	lw	$t1	4($sp)
	addi	$sp	$sp	4
L2:
	lw	$t3	8($fp)
	add	$t3	$t3	48
	sw	$t3	0($sp)
	addi	$sp	$sp	-4
	li	$t2	0
	lw	$t3	4($sp)
	addi	$sp	$sp	4
	add	$t1	$t3	$t2
	lw	$t1	0($t1)
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	li	$t1	12
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	lw	$t1	4($sp)
	addi	$sp	$sp	4
	lw	$t2	4($sp)
	addi	$sp	$sp	4
	slt	$t1	$t2	$t1
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	lw	$t1	4($sp)
	addi	$sp	$sp	4
	beqz	$t1	L1
	lw	$t3	8($fp)
	add	$t3	$t3	0
	sw	$t3	0($sp)
	addi	$sp	$sp	-4
	li	$t2	0
	sw	$t2	0($sp)
	addi	$sp	$sp	-4
	lw	$t3	8($fp)
	add	$t3	$t3	48
	sw	$t3	0($sp)
	addi	$sp	$sp	-4
	li	$t2	0
	lw	$t3	4($sp)
	addi	$sp	$sp	4
	add	$t1	$t3	$t2
	lw	$t1	0($t1)
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	li	$t1	1
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	lw	$t1	4($sp)
	addi	$sp	$sp	4
	lw	$t2	4($sp)
	addi	$sp	$sp	4
	sub	$t1	$t2	$t1
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	lw	$t1	4($sp)
	addi	$sp	$sp	4
	lw	$t2	4($sp)
	addi	$sp	$sp	4
	mul	$t1	$t1	4
	add	$t2	$t2	$t1
	lw	$t3	4($sp)
	addi	$sp	$sp	4
	add	$t1	$t3	$t2
	lw	$t1	0($t1)
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	li	$t1	1
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	lw	$t1	4($sp)
	addi	$sp	$sp	4
	lw	$t2	4($sp)
	addi	$sp	$sp	4
	add	$t1	$t2	$t1
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	lw	$t3	8($fp)
	add	$t3	$t3	0
	sw	$t3	0($sp)
	addi	$sp	$sp	-4
	li	$t2	0
	sw	$t2	0($sp)
	addi	$sp	$sp	-4
	lw	$t3	8($fp)
	add	$t3	$t3	48
	sw	$t3	0($sp)
	addi	$sp	$sp	-4
	li	$t2	0
	lw	$t3	4($sp)
	addi	$sp	$sp	4
	add	$t1	$t3	$t2
	lw	$t1	0($t1)
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	lw	$t1	4($sp)
	addi	$sp	$sp	4
	lw	$t2	4($sp)
	addi	$sp	$sp	4
	mul	$t1	$t1	4
	add	$t2	$t2	$t1
	lw	$t3	4($sp)
	addi	$sp	$sp	4
	add	$t2	$t3	$t2
	lw	$t1	4($sp)
	addi	$sp	$sp	4
	sw	$t1	0($t2)
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	lw	$t1	4($sp)
	addi	$sp	$sp	4
	lw	$t3	8($fp)
	add	$t3	$t3	48
	sw	$t3	0($sp)
	addi	$sp	$sp	-4
	li	$t2	0
	lw	$t3	4($sp)
	addi	$sp	$sp	4
	add	$t1	$t3	$t2
	lw	$t1	0($t1)
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	li	$t1	1
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	lw	$t1	4($sp)
	addi	$sp	$sp	4
	lw	$t2	4($sp)
	addi	$sp	$sp	4
	add	$t1	$t2	$t1
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	lw	$t3	8($fp)
	add	$t3	$t3	48
	sw	$t3	0($sp)
	addi	$sp	$sp	-4
	li	$t2	0
	lw	$t3	4($sp)
	addi	$sp	$sp	4
	add	$t2	$t3	$t2
	lw	$t1	4($sp)
	addi	$sp	$sp	4
	sw	$t1	0($t2)
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	lw	$t1	4($sp)
	addi	$sp	$sp	4
	b	L2
L1:
.data
V2:	.asciiz	"After x="
.text
	li	$v0	4
	la	$a0	V2
	syscall
	lw	$t3	8($fp)
	add	$t3	$t3	52
	sw	$t3	0($sp)
	addi	$sp	$sp	-4
	li	$t2	0
	lw	$t3	4($sp)
	addi	$sp	$sp	4
	add	$t1	$t3	$t2
	lw	$t1	0($t1)
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	li	$v0	1
	lw	$a0	4($sp)
	addi	$sp	$sp	4
	syscall
	li	$v0	4
	la	$a0	Enter
	syscall
	lw	$ra	0($fp)
	move	$sp	$fp
	lw	$fp	4($sp)
	addi	$sp	$sp	4
	addi	$sp	$sp	4
	jr	$ra
.data
V3:
	.word	12
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	5
.text
L3:
	sw	$fp	0($sp)
	addi	$sp	$sp	-4
	move	$fp	$sp
	sw	$ra	0($sp)
	addi	$sp	$sp	-4
.data
V4:	.asciiz	"Before t1="
.text
	li	$v0	4
	la	$a0	V4
	syscall
	lw	$t3	8($fp)
	add	$t3	$t3	0
	sw	$t3	0($sp)
	addi	$sp	$sp	-4
	li	$t2	0
	lw	$t3	4($sp)
	addi	$sp	$sp	4
	add	$t1	$t3	$t2
	lw	$t1	0($t1)
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	li	$v0	1
	lw	$a0	4($sp)
	addi	$sp	$sp	4
	syscall
	li	$v0	4
	la	$a0	Enter
	syscall
	li	$t1	1024
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	lw	$t3	8($fp)
	add	$t3	$t3	0
	sw	$t3	0($sp)
	addi	$sp	$sp	-4
	li	$t2	0
	lw	$t3	4($sp)
	addi	$sp	$sp	4
	add	$t2	$t3	$t2
	lw	$t1	4($sp)
	addi	$sp	$sp	4
	sw	$t1	0($t2)
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	lw	$t1	4($sp)
	addi	$sp	$sp	4
	lw	$t3	8($fp)
	add	$t3	$t3	4
	sw	$t3	0($sp)
	addi	$sp	$sp	-4
	li	$t2	0
	lw	$t3	4($sp)
	addi	$sp	$sp	4
	add	$t1	$t3	$t2
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	jal	L0
.data
V5:	.asciiz	"After t1="
.text
	li	$v0	4
	la	$a0	V5
	syscall
	lw	$t3	8($fp)
	add	$t3	$t3	0
	sw	$t3	0($sp)
	addi	$sp	$sp	-4
	li	$t2	0
	lw	$t3	4($sp)
	addi	$sp	$sp	4
	add	$t1	$t3	$t2
	lw	$t1	0($t1)
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	li	$v0	1
	lw	$a0	4($sp)
	addi	$sp	$sp	4
	syscall
	li	$v0	4
	la	$a0	Enter
	syscall
	lw	$ra	0($fp)
	move	$sp	$fp
	lw	$fp	4($sp)
	addi	$sp	$sp	4
	addi	$sp	$sp	4
	jr	$ra
.data
V6:
	.word	12
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	5
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	0
	.word	5
	.word	0
.text
main:
	la	$t1	V6
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	sw	$fp	0($sp)
	addi	$sp	$sp	-4
	move	$fp	$sp
	sw	$ra	0($sp)
	addi	$sp	$sp	-4
	li	$t1	22
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	li	$t1	0
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	la	$t3	V0
	sw	$t3	0($sp)
	addi	$sp	$sp	-4
	li	$t2	0
	lw	$t3	4($sp)
	addi	$sp	$sp	4
	add	$t1	$t3	$t2
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	jal	L0
	lw	$t3	8($fp)
	add	$t3	$t3	0
	sw	$t3	0($sp)
	addi	$sp	$sp	-4
	li	$t2	0
	lw	$t3	4($sp)
	addi	$sp	$sp	4
	add	$t1	$t3	$t2
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	jal	L3
	add	$t3	$fp	-4
	sw	$t3	0($sp)
	addi	$sp	$sp	-4
	li	$t2	0
	lw	$t3	4($sp)
	addi	$sp	$sp	4
	add	$t1	$t3	$t2
	lw	$t1	0($t1)
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	add	$t3	$fp	-64
	sw	$t3	0($sp)
	addi	$sp	$sp	-4
	li	$t2	0
	add	$t2	$t2	4
	add	$t2	$t2	52
	lw	$t3	4($sp)
	addi	$sp	$sp	4
	add	$t2	$t3	$t2
	lw	$t1	4($sp)
	addi	$sp	$sp	4
	sw	$t1	0($t2)
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	lw	$t1	4($sp)
	addi	$sp	$sp	4
	add	$t3	$fp	-64
	sw	$t3	0($sp)
	addi	$sp	$sp	-4
	li	$t2	0
	add	$t2	$t2	4
	lw	$t3	4($sp)
	addi	$sp	$sp	4
	add	$t1	$t3	$t2
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	jal	L0
	li	$t1	133
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	lw	$t3	8($fp)
	add	$t3	$t3	0
	sw	$t3	0($sp)
	addi	$sp	$sp	-4
	li	$t2	0
	add	$t2	$t2	0
	lw	$t3	4($sp)
	addi	$sp	$sp	4
	add	$t2	$t3	$t2
	lw	$t1	4($sp)
	addi	$sp	$sp	4
	sw	$t1	0($t2)
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	lw	$t1	4($sp)
	addi	$sp	$sp	4
	lw	$t3	8($fp)
	add	$t3	$t3	0
	sw	$t3	0($sp)
	addi	$sp	$sp	-4
	li	$t2	0
	lw	$t3	4($sp)
	addi	$sp	$sp	4
	add	$t1	$t3	$t2
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	jal	L3
.data
V7:	.asciiz	"p21.p1.x="
.text
	li	$v0	4
	la	$a0	V7
	syscall
	lw	$t3	8($fp)
	add	$t3	$t3	0
	sw	$t3	0($sp)
	addi	$sp	$sp	-4
	li	$t2	0
	add	$t2	$t2	4
	add	$t2	$t2	52
	lw	$t3	4($sp)
	addi	$sp	$sp	4
	add	$t1	$t3	$t2
	lw	$t1	0($t1)
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	li	$v0	1
	lw	$a0	4($sp)
	addi	$sp	$sp	4
	syscall
	li	$v0	4
	la	$a0	Enter
	syscall
	lw	$t3	8($fp)
	add	$t3	$t3	60
	sw	$t3	0($sp)
	addi	$sp	$sp	-4
	li	$t2	0
	lw	$t3	4($sp)
	addi	$sp	$sp	4
	add	$t1	$t3	$t2
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	jal	L0
	li	$t1	0
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	lw	$t3	8($fp)
	add	$t3	$t3	116
	sw	$t3	0($sp)
	addi	$sp	$sp	-4
	li	$t2	0
	lw	$t3	4($sp)
	addi	$sp	$sp	4
	add	$t2	$t3	$t2
	lw	$t1	4($sp)
	addi	$sp	$sp	4
	sw	$t1	0($t2)
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	lw	$t1	4($sp)
	addi	$sp	$sp	4
L5:
	lw	$t3	8($fp)
	add	$t3	$t3	116
	sw	$t3	0($sp)
	addi	$sp	$sp	-4
	li	$t2	0
	lw	$t3	4($sp)
	addi	$sp	$sp	4
	add	$t1	$t3	$t2
	lw	$t1	0($t1)
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	li	$t1	12
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	lw	$t1	4($sp)
	addi	$sp	$sp	4
	lw	$t2	4($sp)
	addi	$sp	$sp	4
	slt	$t1	$t2	$t1
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	lw	$t1	4($sp)
	addi	$sp	$sp	4
	beqz	$t1	L4
.data
V8:	.asciiz	"p20.parr0:"
.text
	li	$v0	4
	la	$a0	V8
	syscall
	lw	$t3	8($fp)
	add	$t3	$t3	60
	sw	$t3	0($sp)
	addi	$sp	$sp	-4
	li	$t2	0
	add	$t2	$t2	0
	sw	$t2	0($sp)
	addi	$sp	$sp	-4
	lw	$t3	8($fp)
	add	$t3	$t3	116
	sw	$t3	0($sp)
	addi	$sp	$sp	-4
	li	$t2	0
	lw	$t3	4($sp)
	addi	$sp	$sp	4
	add	$t1	$t3	$t2
	lw	$t1	0($t1)
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	lw	$t1	4($sp)
	addi	$sp	$sp	4
	lw	$t2	4($sp)
	addi	$sp	$sp	4
	mul	$t1	$t1	4
	add	$t2	$t2	$t1
	lw	$t3	4($sp)
	addi	$sp	$sp	4
	add	$t1	$t3	$t2
	lw	$t1	0($t1)
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	li	$v0	1
	lw	$a0	4($sp)
	addi	$sp	$sp	4
	syscall
	li	$v0	4
	la	$a0	Enter
	syscall
	lw	$t3	8($fp)
	add	$t3	$t3	116
	sw	$t3	0($sp)
	addi	$sp	$sp	-4
	li	$t2	0
	lw	$t3	4($sp)
	addi	$sp	$sp	4
	add	$t1	$t3	$t2
	lw	$t1	0($t1)
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	li	$t1	1
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	lw	$t1	4($sp)
	addi	$sp	$sp	4
	lw	$t2	4($sp)
	addi	$sp	$sp	4
	add	$t1	$t2	$t1
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	lw	$t3	8($fp)
	add	$t3	$t3	116
	sw	$t3	0($sp)
	addi	$sp	$sp	-4
	li	$t2	0
	lw	$t3	4($sp)
	addi	$sp	$sp	4
	add	$t2	$t3	$t2
	lw	$t1	4($sp)
	addi	$sp	$sp	4
	sw	$t1	0($t2)
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	lw	$t1	4($sp)
	addi	$sp	$sp	4
	b	L5
L4:
	la	$t3	V3
	sw	$t3	0($sp)
	addi	$sp	$sp	-4
	li	$t2	0
	lw	$t3	4($sp)
	addi	$sp	$sp	4
	add	$t1	$t3	$t2
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	jal	L3
.data
V9:	.asciiz	"p20.x="
.text
	li	$v0	4
	la	$a0	V9
	syscall
	lw	$t3	8($fp)
	add	$t3	$t3	60
	sw	$t3	0($sp)
	addi	$sp	$sp	-4
	li	$t2	0
	add	$t2	$t2	52
	lw	$t3	4($sp)
	addi	$sp	$sp	4
	add	$t1	$t3	$t2
	lw	$t1	0($t1)
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	li	$v0	1
	lw	$a0	4($sp)
	addi	$sp	$sp	4
	syscall
	li	$v0	4
	la	$a0	Enter
	syscall
	lw	$ra	0($fp)
	move	$sp	$fp
	lw	$fp	4($sp)
	addi	$sp	$sp	4
	addi	$sp	$sp	4
	jr	$ra
