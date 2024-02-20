Example code for the GNU ifunc mechanism on Aarch64.

To use:
* Clone this repository onto a aarch64 (armv8-a or higher) Linux system
* Build the software: make
* Execute the code: ./ifunc-test

On a system that does not have SVE/SVE2, you can emulate these capabilities using qemu usermode emulation:

   qemu-aarch64 ./ifunc-test
  
This software will not build on a non-aarch64 system (eg. x86_64) -- the principles apply but the details are different.
