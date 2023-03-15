import console
import sbi, sync
import std/volatile

var booted = false

proc meow {.exportc: "main".} =
  if gethartid() == 0:
    println("[nimkernel] Nya~")
    fence()
    volatileStore(booted.addr, true)
  else:
    while not volatileLoad(booted.addr):
      discard
    println("done") # may need a lock?
