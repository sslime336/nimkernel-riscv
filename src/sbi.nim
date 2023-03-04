
const
  SET_TIMER = 0
  CONSOLE_PUTCHAR = 1
  CONSOLE_GETCHAR = 2
  CLEAR_IPI = 3
  SEND_IPI = 4
  REMOTE_FENCE_I = 5
  REMOTE_SFENCE_VMA = 6
  REMOTE_SFENCE_VMA_ASID = 7
  SHUTDOWN = 8

{.emit: """

#ifndef _ASM_RISCV_ECALL_H
#define _ASM_RISCV_ECALL_H
#define RISCV_ECALL(which, arg0, arg1, arg2) ({            \
    register unsigned long a0 asm ("a0") = (unsigned long)(arg0);   \
    register unsigned long a1 asm ("a1") = (unsigned long)(arg1);   \
    register unsigned long a2 asm ("a2") = (unsigned long)(arg2);   \
    register unsigned long a7 asm ("a7") = (unsigned long)(which);  \
    asm volatile ("ecall"                   \
              : "+r" (a0)               \
              : "r" (a1), "r" (a2), "r" (a7)        \
              : "memory");              \
    a0;                         \
})
long sbi_call(long which, long arg0, long arg1, long arg2) {
  return RISCV_ECALL(which, arg0, arg1, arg2);
}
#define RISCV_ECALL_0(which) RISCV_ECALL(which, 0, 0, 0)
#endif

""".}

proc sbicall(which, arg0, arg1, arg2: clong): clong{.nodecl, importc: "sbi_call", discardable.}


template echo*(s: string): untyped =
  for _, ch in s:
    putchar(ch.clong)

proc putchar*(ch: clong): void =
  sbicall(CONSOLE_PUTCHAR.clong, ch, 0, 0)

proc shutdown*(): void =
  sbicall(SHUTDOWN, 0, 0, 0)
