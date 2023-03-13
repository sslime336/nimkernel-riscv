import ecall

type
  HartState* {.pure.} = enum

    Started = 0        ##\
    ## The hart is physically powered-up and executing normally.

    Stopped = 1        ##\
    ## The hart is not executing in supervisor-mode or any lower privilege mode.
    ## It is probably powered-down by the SBI implementation if the underlying platform
    ## has a mechanism to physically power-down harts.

    StartPending = 2   ##\
    ## Some other hart has requested to start (or power-up) the hart from the STOPPED
    ## state and the SBI implementation is still working to get the hart in the STARTED state.

    StopPending = 3    ##\
    ## The hart has requested to stop (or power-down) itself from the STARTED state
    ## and the SBI implementation is still working to get the hart in the STOPPED state.

    Suspended = 4      ##\
    ## This hart is in a platform specific suspend (or low power) state.

    SuspendPending = 5 ##\
    ## The hart has requested to put itself in a platform specific low power state
    ## from the STARTED state and the SBI implementation is still working to get the
    ## hart in the platform specific SUSPENDED state.

    ResumePending = 6, ##\
    ## An interrupt or platform specific hardware event has caused the hart to
    ## resume normal execution from the SUSPENDED state and the SBI implementation
    ## is still working to get the hart in the STARTED state.

const EID_HSM {.used.} = 0x48534D

const
  FID_START      {.used.} = 0
  FID_STOP       {.used.} = 1
  FID_GET_STATUS {.used.} = 2
  FID_SUSPEND    {.used.} = 3


discard """

proc gethartstatus*(): uint = 

"""
