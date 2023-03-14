import sbi

template print*(s: string) =
  for i in 0..s.len-1: putchar(s[i])

template println*(s: string) =
  print(s)
  putchar('\n')

template info*(s: string) = 
  print(s)
  putchar('\n')
