import sbi
import console

proc meow {.exportc: "main".} =
  echo "[nimkernel] Nya~\n"

  # Currently we supported multi-hart, so when you called shutdown, you may not
  # be able to see the [nimkernel] output as one of three harts would shutdown as
  # we will meet the race from other harts.
  # shutdown() 
