/* Copyright 2011-2012 Nicholas J. Kain, licensed under standard MIT license */
/*
 * seL4/Microkit adaptation of the x86_64 TLS bootstrap.
 *
 * Upstream musl implements this with `syscall` to perform
 * arch_prctl(ARCH_SET_FS, tp), which assumes the Linux syscall ABI. A seL4 PD
 * has no such ABI: executing `syscall` there enters the seL4 kernel's own
 * syscall path and is reported as an "Unknown fault", so the thread pointer
 * would never be set.
 *
 * This mirrors libsel4muslcsys/vsyscall.c, which sets the thread pointer with
 * WRFSBASE when the kernel is built with CONFIG_FSGSBASE_INST (the Microkit
 * x86_64_generic board enables it, so CR4.FSGSBASE is set and the instruction
 * is permitted at CPL3).
 */
.text
.global __set_thread_area
.hidden __set_thread_area
.type __set_thread_area,@function
__set_thread_area:
	mov %rdi,%rax           /* thread pointer (TP_ADJ(p)) */
	wrfsbase %rax           /* set FS base from user mode */
	xor %eax,%eax           /* musl expects 0 on success */
	ret
