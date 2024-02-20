BINARIES=hello hello-static hello-opt hello2 hello3
CCFLAGS=-g -O0 -fno-builtin

all:		${BINARIES}

hello:		hello.c
		gcc	${CCFLAGS}	-o hello			hello.c

# Statically-linked version
hello-static:	hello.c
		gcc	${CCFLAGS}	-o hello-static	-static		hello.c

# Optimized version
hello-opt:	hello.c
		gcc	-O3 -g		-o hello-opt			hello.c

hello2:		hello2.c
		gcc	${CCFLAGS}	-o hello2			hello2.c

hello3:		hello3.c
		gcc	${CCFLAGS}	-o hello3			hello3.c

clean:		
		rm ${BINARIES} *.o || true


