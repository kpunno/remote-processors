# sve2-test

This is test code for the Seneca SPO600 project for Fall 2023.
It is derived from the code at https://github.com/ctyler/sve2-test

scripts/autoifunc is a bash script which will take a C source code
file containing one or more functions and rewrite the code to have
multiple versions for aarch64 advanced SIMD, SVE, and (optionally)
SVE2 vector implementations. The output file will have the same
name as the input file, with \_ifunc appended to the name 
(before the .c extension).

The Makefile will build main.c and function.c into a binary named
"main".

