import console

proc meow {.exportc: "main".} =
  println("[nimkernel] Nya~")
