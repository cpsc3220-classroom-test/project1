# Project 1b: XV6 Intro - Syscall

You will be doing kernel hacking projects with xv6. xv6 is a re-implementation 
of Dennis Ritchie's and Ken Thompson's Unix Version 6 (v6). You will
use the xv6 implementation for risc-v architectures in this project. Xv6 is
 a much smaller and simpler kernel than the Linux kernel, making it more
accessible for projects and study.

## Requirements
You will add a new system call to the xv6 kernel. The system call, `getprocs()`, simply returns how many processes exist in the system at the time of the call. This project is just a warmup, and thus relatively light on
actual coding.

- The prototype of the new syscall should be: `int getprocs(void)`
- This system call returns the number of processes that exist in the
system at the time of the call.

## Hint

-   Study how other system calls, like `getpid()`, are implemented in xv6. 
    Basically, you can copy an existing system call following the system call implementation process and then then modify the new kernel call implementation 
    to do what you need.

-   You will spend most of your time on understanding the code. There
    should not have much new code to be added.

-   Using `gdb` (the debugger) may be helpful in understanding code,
    doing code traces, and is helpful for later projects too. Get
    familiar with this fine tool!

-   Remember that you will be writing *kernel code* to implement this
    system call. You must also write `userspace` code to test it.
    Remember that *kernel code* can impact the entire system. Think
    about your changes!
 

## The Code

You may find the first few chapters of the following book useful:
https://pdos.csail.mit.edu/6.828/2019/xv6/book-riscv-rev0.pdf


Remember that xv6 is *not* Linux. Every OS provides a standard library:
a grouping of functions for interacting with the operating system and
doing basic programming tasks. You may be familiar with the GNU C
standard library, and you probably used it in Project 1a. In xv6, you
will not have access to this standard library. xv6 does provide some
utility functions for you, and syscalls for interacting with the kernel.
In practice, this means that if you find yourself writing system-scope
includes (`#include <…>`, not `#include ".."`), you have made a mistake.
Be careful, because your code may still compile but not run correctly in
the xv6 environment.

## Submission

-   Your archive should not contain temporary object files or
    executables when you submit it. To ensure this, just run
    `make clean` before archiving the directory.

-   Your code must run on the lab 110 machines, at minimum.

-   Your program must be written in C (not C++ or other languages).

-   You will have to modify the Makefile and kernel files. Do not
    *delete* anything from the Makefile - it may be used for grading.
