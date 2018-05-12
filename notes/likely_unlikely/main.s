	.file	"main.c"
	.text
	.p2align 4,,15
	.globl	a
	.type	a, @function
a:
	testq	%rdi, %rdi
	je	.L3
	movsbl	(%rdi), %eax
	ret
.L3:
	movl	$-1, %eax
	ret
	.size	a, .-a
	.p2align 4,,15
	.globl	b
	.type	b, @function
b:
	testq	%rdi, %rdi
	movl	$-1, %eax
	je	.L6
	movsbl	(%rdi), %eax
.L6:
	rep ret
	.size	b, .-b
	.p2align 4,,15
	.globl	c
	.type	c, @function
c:
	testq	%rdi, %rdi
	movl	$-1, %eax
	jne	.L13
	rep ret
	.p2align 4,,10
	.p2align 3
.L13:
	movsbl	(%rdi), %eax
	ret
	.size	c, .-c
	.p2align 4,,15
	.globl	d
	.type	d, @function
d:
	testq	%rdi, %rdi
	je	.L17
	cmpq	$536870912, %rdi
	ja	.L18
	movsbl	(%rdi), %eax
	ret
	.p2align 4,,10
	.p2align 3
.L18:
	movsbl	-2(%rdi), %eax
	ret
.L17:
	movl	$-1, %eax
	ret
	.size	d, .-d
	.p2align 4,,15
	.globl	e
	.type	e, @function
e:
	testq	%rdi, %rdi
	movl	$-1, %eax
	je	.L19
	cmpq	$536870912, %rdi
	jbe	.L21
	movsbl	-2(%rdi), %eax
	ret
	.p2align 4,,10
	.p2align 3
.L21:
	movsbl	(%rdi), %eax
.L19:
	rep ret
	.size	e, .-e
	.ident	"GCC: (Debian 6.3.0-18) 6.3.0 20170516"
	.section	.note.GNU-stack,"",@progbits
