.data
Enter:	.asciiz	"
"
base:
.text
.data
V0:
.text
main:
	la	$t1	V0
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	sw	$fp	0($sp)
	addi	$sp	$sp	-4
	move	$fp	$sp
	sw	$ra	0($sp)
	addi	$sp	$sp	-4
	li	$t1	0
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	li	$t1	0
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	li	$v0	5
	syscall
	add	$t3	$fp	-4
	sw	$t3	0($sp)
	addi	$sp	$sp	-4
	li	$t2	0
	lw	$t3	4($sp)
	addi	$sp	$sp	4
	add	$t1	$t3	$t2
	sw	$v0	0($t1)
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
	li	$t1	10
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	lw	$t1	4($sp)
	addi	$sp	$sp	4
	lw	$t2	4($sp)
	addi	$sp	$sp	4
	sgt	$t1	$t2	$t1
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	lw	$t1	4($sp)
	addi	$sp	$sp	4
	beqz	$t1	L1
	li	$t1	1
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	add	$t3	$fp	-8
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
	b	L0
L1:
L0:
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
	li	$t1	6
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	lw	$t1	4($sp)
	addi	$sp	$sp	4
	lw	$t2	4($sp)
	addi	$sp	$sp	4
	sgt	$t1	$t2	$t1
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	lw	$t1	4($sp)
	addi	$sp	$sp	4
	beqz	$t1	L3
	li	$t1	2
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	add	$t3	$fp	-8
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
L3:
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
	li	$t1	3
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	lw	$t1	4($sp)
	addi	$sp	$sp	4
	lw	$t2	4($sp)
	addi	$sp	$sp	4
	sgt	$t1	$t2	$t1
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	lw	$t1	4($sp)
	addi	$sp	$sp	4
	beqz	$t1	L4
	li	$t1	3
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	add	$t3	$fp	-8
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
L4:
	li	$t1	4
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	add	$t3	$fp	-8
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
L2:
.data
V1:	.asciiz	"i="
.text
	li	$v0	4
	la	$a0	V1
	syscall
	add	$t3	$fp	-8
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
V2:
.data
V3:
.text
L5:
	sw	$fp	0($sp)
	addi	$sp	$sp	-4
	move	$fp	$sp
	sw	$ra	0($sp)
	addi	$sp	$sp	-4
	lw	$ra	0($fp)
	move	$sp	$fp
	lw	$fp	4($sp)
	addi	$sp	$sp	4
	addi	$sp	$sp	4
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	jr	$ra
