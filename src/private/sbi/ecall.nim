{.emit: """
#ifndef __RISCV_ENV_CALL
#define __RISCV_ENV_CALL

#define LEGACY_ECALL(eid, arg0, arg1, arg2) ({  \
    register unsigned long a0 asm ("a0") = (unsigned long)(arg0);   \
    register unsigned long a1 asm ("a1") = (unsigned long)(arg1);   \
    register unsigned long a2 asm ("a2") = (unsigned long)(arg2);   \
    register unsigned long a7 asm ("a7") = (unsigned long)(eid);    \
    asm volatile ("ecall"                       \
              : "+r" (a0)                       \
              : "r" (a1), "r" (a2), "r" (a7)    \
              : "memory");                      \
    a0;                                         \
})

long
legacy_sbi_call(unsigned long eid, unsigned long arg0,
                unsigned long arg1, unsigned long arg2)
{
  return LEGACY_ECALL(eid, arg0, arg1, arg2);
}

struct sbiret {
  long error;
  long value;
};

#define ECALL_V02(eid, fid, arg0, arg1) ({    \
  register unsigned long a7 asm ("a7") = (unsigned long)(eid);   \
  register unsigned long a6 asm ("a6") = (unsigned long)(fid);   \
  register unsigned long a0 asm ("a0") = (unsigned long)(arg0);  \
  register unsigned long a1 asm ("a1") = (unsigned long)(arg1);  \
  asm volatile ("ecall"                              \
            : "+r" (a0), "+r" (a1)                   \
            : "r" (a6), "r" (a7) \
            : "memory");                             \
  struct sbiret ret = { arg0, arg1 };                \
  ret;                                               \
})

struct sbiret
sbi_call_v02(unsigned long eid, unsigned long fid,
             unsigned long arg0, unsigned long arg1)
{
  return ECALL_V02(eid, fid, arg0, arg1);
}

#endif
""".}

type
  sbiret {.nodecl, importc: "sbiret".} = object 

proc sbicall*(eid, arg0, arg1, arg2: culong): clong  {.nodecl, importc: "legacy_sbi_call".}

proc sbicallv02*(eid, fid, arg0, arg1: culong): sbiret {.nodecl, importc: "sbi_call_v02",.}
