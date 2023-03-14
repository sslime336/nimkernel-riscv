import console
import sbi, sync

var booted = false

proc meow {.exportc: "main".} =
  if gethartid() == 0:
    println("[nimkernel] Nya~")
    fence()
    booted = true
  else:
    while not booted: discard
    println("done") # some problems here :(
