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

# TODO

proc settimer*(stimeValue: uint64): int {.discardable.} = sbicall(EID_SET_TIMER, uint(stimeValue), 0, 0).int

proc putchar*(ch: char): int {.discardable.} = sbicall(EID_CONSOLE_PUTCHAR, uint(ch), 1, 0).int

proc getchar*(): char {.discardable.} = sbicall(EID_CONSOLE_GETCHAR, 0, 0, 0).char

proc clearipi*(): int {.discardable.} = sbicall(EID_CLEAR_IPI, 0, 0, 0).int

proc sendipi*(hartMask: uint):  int {.discardable.} = sbicall(EID_SEND_IPI, 0, 0, 0).int

proc shutdown*(): int {.discardable.} = sbicall(EID_SHUTDOWN, 0, 0, 0).int
