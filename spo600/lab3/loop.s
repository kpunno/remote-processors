 .text
 .globl _start
 min = 0                          /* starting value for the loop index; **note that this is a symbol (constant)**, not a variable */
 max = 10                         /* loop exits when the index hits this number (loop condition is i<max) */
 _start:
	mov     x19, min	/* initial value of loop counter into r19 */
 loop:
	add	x15, x19, 0x30	/* add 48 to convert to char value */
	adr	x14, msg+6	/* save this to msg, msg+6 is an immediate 
				   value, the 6th position of msg 
				*/
	strb	w15, [x14]	/* we use 'w', instead of 'x'
				   this indicates that we want 1 byte stored
				   store it not into the register, but the
				   address that is pointed to by the register
				   indicated by the square brackets [].
				*/
/*	
	str	x15, msg+6	   we can't do this!
'str' puts it into a memory location pointed at another register, we cannot put it directly into a register. we must prep a register with the address that we want to store this in.
/*

	/* print the message */
	mov	x0, 1		/* file descriptor: 1 is stdout */
	adr	x1, msg		/* message loc (address) */
	mov	x2, len		/* message len (bytes) */

	mov	x8, 64		/* write is syscall #64 */
	svc	0		/* invoke syscall */

	/* continue the loop */
	add     x19, x19, 1
	cmp     x19, max
	b.ne    loop

	mov     x0, 0           /* status -> 0 */
	mov     x8, 93          /* exit is syscall #93 */
	svc     0               /* invoke syscall */

.data
msg:	.ascii	"Loop: #\n"
len=	. - msg
