.data
Enter:	.asciiz	"
"
base:
.text
.data
V0:
	.word	0
	.word	0
.data
V1:
	.word	0
	.word	0
.text
main:
	la	$t1	V1
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
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	li	$t1	0
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	li	$t1	1
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	add	$t3	$fp	-8
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
	li	$t1	1
	sw	$t1	0($sp)
	addi	$sp	$sp	-4
	add	$t3	$fp	-8
	sw	$t3	0($sp)
	addi	$sp	$sp	-4
	li	$t2	0
	add	$t2	$t2	4
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
	lw	$ra	0($fp)
	move	$sp	$fp
	lw	$fp	4($sp)
	addi	$sp	$sp	4
	addi	$sp	$sp	4
	jr	$ra
