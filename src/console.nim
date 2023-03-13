import sbi

template echo*(s: string) =
  for i in 0..s.len-1:
    discard putchar(s[i])

