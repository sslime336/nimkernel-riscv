  .section .text.entry
  .globl _start
_start:
  la sp, boot_stack_top
  call nya_main

  .section .bss.stack
  .globl boot_stack
boot_stack:
  .space 64 * 1024
  .globl boot_stack_top
boot_stack_top:
