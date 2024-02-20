
# Useful CFLAGS values:
#    Basic aarch64 target:	-march=armv8-a
#    aarch64 with SVE:		-march=armv8.5-a+sve
#    aarch64 with SVE2:		-march=armv8.5-a+sve2
#
# Note that armv9-a does not appear to be accepted
# by some versions of gcc that can emit sve2 
# instructions (contrary to the docs).
#
CFLAGS = -g -O3 -march=armv8-a 
# Set the RUNTOOL to qemu-aarch64 if you want to try sve2
# code on a system without sve2 capability
RUNTOOL = 
BINARIES = main

all:				${BINARIES}

function_ifunc.c:		function.c
				scripts/autoifunc function.c

all-test:			${BINARIES}
				echo "Making and testing all versions..."
				${RUNTOOL} ./main tests/input/bree.jpg 1.0 1.0 1.0 tests/output/bree1a.jpg 10
				${RUNTOOL} ./main tests/input/bree.jpg 0.5 0.5 0.5 tests/output/bree1b.jpg 10
				${RUNTOOL} ./main tests/input/bree.jpg 2.0 2.0 2.0 tests/output/bree1c.jpg 10
	
main:				main.c function_ifunc.c
				gcc ${CFLAGS} main.c function_ifunc.c -o main

clean:			
				rm ${BINARIES} *_ifunc.c *.o *.s *.gimple tests/output/bree??.jpg tests/output/montage.jpg || true


