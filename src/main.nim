import console
import sbi

proc meow {.exportc: "main".} =
  if gethartid() == 0: println("[nimkernel] Nya~")
