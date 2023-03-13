import console, sbi

proc rawoutput*(msg: string) =
  echo msg

proc panic*(info: string) =
  rawoutput info
  shutdown()
