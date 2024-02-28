.text
.globl _start
min = 0                         /* starting value for the loop index */
max = 30                        /* loop exits when the index hits this number */
div = 10			/* the divisior, for positioning two vs. one figure values */

 _start:
	mov     $min,%r15		/* index */
	mov	$div,%r10		/* divisor (may need to be moved inside the loop) */
 loop:
	mov	$0,%rdx			/* ensure that rdx is 0 */

	mov	%r15,%rax		/* move index value from r15 to rax */
	div	%r10			/* divide index(rax) by 10(r10) 
						quotient  in rax
						remainder in rdx
					*/
	cmp $0,%rax
	je less_than_10

	/* greater than 10 */
	mov	%rax,%r14	

	add	$'0',%r14		/* add '0' to value at r14 */
	mov	$msg+5,%r13		/* r13 points now to msg[6] */
	mov	%r14b,(%r13)		/* store it in what r13 is pointing to... */

	mov	%rdx,%r14
	add	$'0',%r14
	mov	$msg+6,%r13
	mov	%r14b,(%r13)
	
lt10_continue:

	movq    $len,%rdx		/* message length */
	movq    $msg,%rsi		/* message location */
	movq    $1,%rdi			/* file descriptor stdout */
	movq    $1,%rax			/* syscall sys_write */
	syscall

	/* jump to loop if max is not reached by index */
	inc     %r15			/* increment index */
	cmp     $max,%r15		/* see if we're done */
	jne     loop			/* loop if we're not */

	/* exit loop */
	mov     $0,%rdi			/* exit status */
	mov     $60,%rax		/* syscall sys_exit */
	syscall

less_than_10:
	mov	$' ',%r14
	mov	$msg+5,%r13
	mov	%r14b,(%r13)
	
	mov	%r15,%r14
	add	$'0',%r14		/* add '0' to value at r14 */
	mov	$msg+6,%r13		/* r13 points now to msg[6] */
	mov	%r14b,(%r13)		/* store it in what r13 is pointing to... */

	/* store value, msg+6 */
	/* store space char in msg+5 */
	jmp lt10_continue


.section .data
msg:    .ascii      "Loop #!\n"
len = . - msg
