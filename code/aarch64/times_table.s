 .text
 .globl _start
 inner = 1              /* starting value of inner loop */
 outer = 1		/* starting value of outer loop */
 max =   13		/* loop exits when the index hits this number */
 mod =   10		/* divide by this to get quotient and remainder */

 _start:

	mov     x19, outer		/* initial value of outer loop -> r20 */
	mov	x20, inner		/* initial value of inner loop -> r19 */
	mov	x21, mod		/* x20 is constant 10 */

 outer_loop:
	mov	x24, x19		/* point r24 at outer loop iterator */
	adr	x27, msg		/* num pos1 */
	adr	x28, msg+1		/* num pos2 */

	udiv	x22, x19, x21		/* place into r22, r19 / r21 (r19 is iter, r21 is 10
					   when x19 is less than 10, x22 is 0 (one digit)
					*/
	cmp	x19, #10
	b.lt	lt_10

	b gt_10
	

 inner_loop:
	mov	x24, x20		/* point r24 at inner loop iterator */
	adr	x27, msg+5		/* num pos1 */
	adr	x28, msg+6		/* num pos2 */
	
	udiv	x22, x20, x21		/* place into r22, r20 / r21 (r20 is iteration, r21 is 10
					   when x20 is less than 10, x22 is 0 (one digit)
					*/
	cmp	x20, #10
	b.lt	lt_10			/* quotient was 0, branch */


 /* quotient was not zero ... */
 gt_10:
	
	msub	x23, x21, x22, x24
 
	/* store in x15,  */
	add	x15, x22, #48		/* bump value to char value */
	strb	w15, [x27]

	/* second char */		/* bump value to char value */
	add	x16, x23, #48
	strb	w16, [x28]

	adr	x25, msg
	cmp	x27, x25
	b.eq	inner_loop

 continue:

	/* multiply and write result to message */

	mul	x29, x19, x20		/* multiple inner loop iter, outer loop iter */
	mov	x21, #100		/* make divisor 100 */
	udiv	x22, x29, x21		/* x22 = multiple / divisor = quotient (1) */
	/* x22 holds quotient of division by 100 */
	msub	x28, x21, x22, x29 	/* remainder - (divisor * quotient)
	/* x28 holds remainder of division by 100 */
	mov	x21, #10
	udiv	x27, x28, x21		/* x27 = remainder / divisor = quotient (2) */
	msub	x28, x21, x27, x28

	/* write to message addresses as before */	

/* don't forget to do { add x15, x22, #48 } to make it a char */

	adr	x14, msg+10	/* msg pos 1 */

	cmp	x22, #0
	b.eq	suppress_1	
	/* write */
	add	x15, x22, #48
	strb	w15, [x14]

 	b	end1
 suppress_1:
	/* suppress */
	mov	x15, #32
	strb	w15, [x14] 	

 end1:
	/* done */
	adr	x14, msg+11	/* msg pos 2 */

	cmp	x22, #1
	b.eq	skip

	cmp	x27, #0
	b.eq	suppress_2
	
 skip:
	add	x15, x27, #48
	strb	w15, [x14] 	

 	b	end2
 suppress_2:

	mov	x15, #32
	strb	w15, [x14]	

 end2:
	adr	x14, msg+12	/* msg pos 3 */

	add	x15, x28, #48
	strb	w15, [x14]

 return:
	/* print the message */
	mov	x0, 1		/* file descriptor: 1 is stdout */
	adr	x1, msg		/* message loc (address) */
	mov	x2, len_msg     /* message len (bytes) */

	mov	x8, 64		/* write is syscall #64 */
	svc	0		/* invoke syscall */

	mov	x21, #10	/* restore original divisor */

	/* continue the loop */
	add     x20, x20, 1
	cmp     x20, max
	b.ne    inner_loop

	mov	x20, 1
	
	mov	x0, 1
	adr	x1, brk
	mov	x2, len_brk
	mov	x8, 64
	svc	0

	
	add	x19, x19, 1
	cmp	x19, max
	b.ne	outer_loop
	

	mov     x0, 0           /* status -> 0 */
	mov     x8, 93          /* exit is syscall #93 */
	svc     0               /* invoke syscall */

 lt_10:
	mov	x15, #32
	strb	w15, [x27]

				/* use indirect address to get outer vs inner loop iterator */
	add	x16, x24, 0x30
	strb	w16, [x28]

	adr	x25, msg	/* compare if we are entering the inner loop 
				   by checking what positions we are working with
				*/
	cmp	x27, x25
	b.eq	inner_loop

	b	continue	/* continue to print */

/* if first quotient is zero, suppress position */
 suppress:
	mov	x15, #32
	strb	w15, [x14]
	ret

/* if first quotient is not zero, write positions */
 write:
	add	x15, x22, #48
	strb	w15, [x14]
	ret

.data
msg:	.ascii	"## x ## =    \n\0"	/* times table string */
len_msg=	. - msg
brk:	.ascii	"------------\n\0"	/* line break */
len_brk=	. - brk
