proc sbicall*(eid, arg0, arg1, arg2: uint): uint =
  asm """
    mv a7, %3
    mv a0, %0
    mv a1, %1
    mv a2, %2
    ecall
    : "+r"(`arg0`)
    : "r" (`arg1`), "r" (`arg2`), "r" (`eid`)
    : "memory"
  """
  result = arg0

type
  SbiRet* = tuple[value, error: uint]

# TODO: wait testing
proc sbicallv02*(eid, fid, arg0, arg1: uint): SbiRet =
  asm """
    mv a7, %2
    mv a6, %3
    mv a0, %0
    mv a1, %1
    ecall
    : "+r"(`arg0`), "r" (`arg1`)
    : "r" (`eid`), "r" (`fid`)
    : "memory"
  """
  result = (arg0, arg1)
