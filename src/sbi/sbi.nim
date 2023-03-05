
type
  SbiError {.pure.} = enum
    Success = 0
    Failed = -1
    NotSupported = -2
    InvalidParam = -3
    Denied = -4
    InvalidAddress = -5
    AlreadyAvailable = -6
    AlreadyStarted = -7
    AlreadyStopped = -8
