import sbi

proc nya() {.exportc: "nya_main".} =
  ## nya is our boot proc in Nim, nya~
  echo "[nimkernel] Nya~\n"
  shutdown()

