loop:	loop.s
	as -g loop.s -o loop.o
	ld -g loop.o -o loop

times_table:	times_table.s
	as -g times_table.s -o times_table.o
	ld -g times_table.o -o times_table

clean:  
	rm -f loop*[!s]
	rm -f loop
	rm -f times_table*[!s]

