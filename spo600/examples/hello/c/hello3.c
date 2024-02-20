#include <sys/syscall.h>
#include <unistd.h>

int main() {
	syscall(__NR_write,1,"Hello World!\n",13);
}

