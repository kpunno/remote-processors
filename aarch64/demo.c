
// Check to see if we are running on the correct system (aarch64)
#ifdef __aarch64__

#include <stdio.h>
#include <sys/auxv.h>

// Three implementations of foo() for three HW configs
//
// These don't really take advantage of hardware,
// just for demonstration purposes.

void *foo_sve2() {
	printf("Using SVE2 implementation.\n");
}

void *foo_sve() {
	printf("Using SVE implementation.\n");
}

void *foo_nonsve() {
	printf("Using non-SVE/SVE2 implementation.\n");
}

// Resolver function - this function picks 
// which of the implementations will be executed when foo() is called.


static void (*resolve_foo(void)) {
	// Each of the two vars is populated
	// with a bitfield that indiciates specific
	// hardware capabilities. hwcaps includes a bit for
	// SVE, and hwcaps2 includes a bit for SVE2
	
	long hwcaps  = getauxval(AT_HWCAP);
	long hwcaps2 = getauxval(AT_HWCAP2);

	printf("\n### RESOLVER: Selecting the implementation to use for foo()\n");
	if (hwcaps2 & HWCAP2_SVE2) {
		return foo_sve2;
	} else if (hwcaps & HWCAP_SVE) {
		return foo_sve;
	} else {
		return foo_nonsve;
	}
}

// Prototype for function foo(), which resolves to
// one of the following three implementations
void *foo() __attribute__((ifunc("resolve_foo")));

int main() {
	for (int i=0; i < 3; i++) {
			printf("Calling foo() from main()...");
			foo();
	}
}

#else
#error Wrong architecture - this code is for Aarch64 ONLY
#endif
