 .text
 .globl _start
 min = 0                        /* starting value for the loop index; */
 max = 30                       /* loop exits when the index hits this number */
 mod = 10			/* divide by this to get quotient and remainder */  
 _start:
	mov     x19, min	/* initial value of loop counter into r19 */
	mov	x20, mod	/* x20 is constant 10 */
 loop:
	// try this:
	/* divide x19 by 10: 
		if: quotient is zero, 1st byte is whitespace
		otherwise, quotient is first position, remainder is second position
		in any case: remainder is the second byte
	*/
	udiv	x21, x19, x20		/* place into r21, r19 / r20 (r19 is iteration, r20 is 10
					   when x19 is less than 10, x21 is 0
					*/
	cmp	x19, #10
	b.lt	lt_10			/* quotient was 0, branch */

/* quotient was not zero */

	/* get remainder, e.g. 24th iteration...
	/*      x19 - (x20 * x21) */
	/* _4_ = 24 - ( 10 *   2) */
	
	msub	x22, x20, x21, x19
 
	/* store in x15,  */
	add	x15, x21, #48		/* bump value to char value */
	adr	x14, msg+6		/* address */
	strb	w15, [x14]

	/* second char */		/* bump value to char value */
	add	x16, x22, #48
	adr	x14, msg+7		/* address  */
	strb	w16, [x14]

lt10_continue:

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

lt_10:
	mov	x15, #32
	adr	x14, msg+6
	strb	w15, [x14]

	add	x16, x19, 0x30
	adr	x14, msg+7
	strb	w16, [x14]
	b	lt10_continue
	
gt_10:

.data
msg:	.ascii	"Loop: ##\n"
len=	. - msg
