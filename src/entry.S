# <https://github.com/riscv-non-isa/riscv-asm-manual/blob/master/riscv-asm.md>

.section .text.entry
.global _entry
_entry:
    mv tp, a0
    la sp, stack0
    li a0, 0x1000 
    addi a1, tp, 1
    mul a0, a0, a1
    add sp, sp, a0

    call main # proc in main.nim named `meow` actually.
spin:
    j spin

.section .bss.stack
stack0:
    .space 0x1000 * 3
