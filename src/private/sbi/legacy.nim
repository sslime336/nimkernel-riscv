import ecall

const
  EID_SET_TIMER              {.used.} = 0
  EID_CONSOLE_PUTCHAR        {.used.} = 1
  EID_CONSOLE_GETCHAR        {.used.} = 2
  EID_CLEAR_IPI              {.used.} = 3
  EID_SEND_IPI               {.used.} = 4
  EID_REMOTE_FENCE_I         {.used.} = 5
  EID_REMOTE_SFENCE_VMA      {.used.} = 6
  EID_REMOTE_SFENCE_VMA_ASID {.used.} = 7
  EID_SHUTDOWN               {.used.} = 8

proc settimer*(stimeValue: uint64): int = 
  result = sbicall(EID_SET_TIMER, culong(stimeValue), 0, 0).int

proc putchar*(ch: char): int =
  result = sbicall(EID_CONSOLE_PUTCHAR, culong(ch), 1, 0)

proc getchar*(): char =
  result = sbicall(EID_CONSOLE_GETCHAR, 0, 0, 0).char

proc clearipi*() = discard

proc sendipi*() = discard

proc shutdown*() =
  discard sbi_call(EID_SHUTDOWN, 0, 0, 0)
