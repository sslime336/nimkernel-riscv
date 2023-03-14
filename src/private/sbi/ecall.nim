proc sbicall*(eid, arg0, arg1, arg2: uint): uint =
  asm """
    mv a7, %[`eid`]
    mv a0, %[`arg0`]
    mv a1, %[`arg1`]
    mv a2, %[`arg2`]
    ecall
    : [`arg0`] "+r"(`arg0`)
    : [`arg1`] "r"(`arg1`), [`arg2`] "r"(`arg2`), [`eid`]"r"(`eid`)
    : "memory"
  """
  result = arg0

type
  SbiRet* = tuple[value, error: uint]

# TODO: wait testing
proc sbicallv02*(eid, fid, arg0, arg1: uint): SbiRet =
  asm """
    mv a7, %[`eid`]
    mv a6, %[`fid`]
    mv a0, %[`arg0`]
    mv a1, %[`arg1`]
    ecall
    : [`arg0`] "+r"(`arg0`), [`arg1`]"+r"(`arg1`)
    : [`eid`]"r"(`eid`), [`fid`]"r"(`fid`)
    : "memory"
  """
  result = (arg0, arg1)
