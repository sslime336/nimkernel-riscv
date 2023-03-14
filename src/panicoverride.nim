import console, sbi

proc rawoutput*(msg: string) =
  info(msg)

proc panic*(info: string) =
  rawoutput info
  shutdown()
