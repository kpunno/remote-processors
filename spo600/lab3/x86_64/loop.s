.text
.globl _start
min = 0                         /*starting value for the loop index*/
 max = 10                       /*loop exits when the index hits this number*/

 _start:
     mov     $min,%r15          /*loop index*/
 loop:
	mov	%r15, %r14
	add	$'0', %r14
	mov	$msg+6, %r13
	mov	%r14b,(%r13)	   /* store it in what r13 is pointing to... */
	movq    $len,%rdx          /* message length */
	movq    $msg,%rsi          /* message location */
	movq    $1,%rdi            /* file descriptor stdout */
	movq    $1,%rax            /* syscall sys_write */
	syscall

	inc     %r15                /* increment index */
	cmp     $max,%r15           /* see if we're done */
	jne     loop                /* loop if we're not */

	/* exit loop */
	mov     $0,%rdi             /* exit status */
	mov     $60,%rax            /* syscall sys_exit */
	syscall

.section .data
msg:    .ascii      "Loop #!\n"
len = . - msg
