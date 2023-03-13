import ecall

const
  SET_TIMER              {.used.} = 0
  CONSOLE_PUTCHAR        {.used.} = 1
  CONSOLE_GETCHAR        {.used.} = 2
  CLEAR_IPI              {.used.} = 3
  SEND_IPI               {.used.} = 4
  REMOTE_FENCE_I         {.used.} = 5
  REMOTE_SFENCE_VMA      {.used.} = 6
  REMOTE_SFENCE_VMA_ASID {.used.} = 7
  SHUTDOWN               {.used.} = 8

proc settimer*(stimeValue: uint64): int = 
  result = sbicall(SET_TIMER, culong(stimeValue), 0, 0).int

proc putchar*(ch: char): int =
  result = sbicall(CONSOLE_PUTCHAR, culong(ch), 1, 0)

proc getchar*(): char =
  result = sbicall(CONSOLE_GETCHAR, 0, 0, 0).char

proc shutdown*() =
  discard sbi_call(SHUTDOWN, 0, 0, 0)