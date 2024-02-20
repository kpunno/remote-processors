/*
 * ifunc-test :: demonstrate ifunc operation on aarch64
 *
 * This code selects, at runtime, between three different
 * implementations of the (dummy) function foo(): 'sve', 
 * 'sve2', and 'non-sve/sve2'. The dummy functions simply
 * print a diagnostic messge.
 *
 * Selection between the functions is performed by the
 * resolver function, which queries the system to see which
 * SVE implementation(s) are supported. The resolver
 * function resolve_foo() is called only once, regardless of
 * how many times the foo() function is called.
 *
 * Copyright (C)2022 Seneca College.
 * Chris Tyler 2022-11-09
 * Licensed under the terms of the GPL v2+.
 * See the LICENSE file for details.
 *
 */

#ifdef __aarch64__

#include <stdio.h>
#include <sys/auxv.h>

// Three implementations of foo() for three HW configurations
//
// (Obviously, these don't take advantage of the hardware,
// they're just for demonstration purposes!)
//
void *foo_sve2() {
	printf("  Using SVE2 implementation.\n");
};
          
void *foo_sve() {
	printf("  Using SVE implementation.\n");
};
          
void *foo_nonsve() {
	printf("  Using non-SVE/SVE2 implementation.\n");
};
          

// Resolver function - this function picks which of the
// implementations will be executed when foo() is called
//
// The resolver function is only run once, the first time
// that foo() is called.
//
static void (*resolve_foo(void)) {
	// Each of these two variables is populated with
	// a bitfield indicating specific hardware 
	// capabilities. hwcaps includes a bit for SVE,
	// and hwcaps2 includes a bit for SVE2
	//
	long hwcaps  = getauxval(AT_HWCAP);
	long hwcaps2 = getauxval(AT_HWCAP2);

	printf("\n### Resolver function - selecting the implementation to use for foo()\n");
	if (hwcaps2 & HWCAP2_SVE2) {
		return foo_sve2;
	} else if (hwcaps & HWCAP_SVE) {
		return foo_sve;
	} else {
		return foo_nonsve;
	}
};

// Prototype for function foo(), which will resolve to
// one of the three implementations depending on system
// capabilities     
void *foo () __attribute__((ifunc("resolve_foo")));


// Main code
int main() {

	for (int i=0; i<3; i++) {
		printf("Calling foo() from main()...");
		foo();
	}

}

#else
#error Wrong architecture - this code is for Aarch64 systems only.
#endif
