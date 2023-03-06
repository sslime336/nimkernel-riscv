# nimkernel-riscv

I wrote this just for fun.

Run:

```shell
nake run
```

And then you'll see:

```plaintext
Compiling nakefile...
Done.
[rustsbi] RustSBI version 0.2.2, adapting to RISC-V SBI v1.0.0
.______       __    __      _______.___________.  _______..______   __
|   _  \     |  |  |  |    /       |           | /       ||   _  \ |  |
|  |_)  |    |  |  |  |   |   (----`---|  |----`|   (----`|  |_)  ||  |
|      /     |  |  |  |    \   \       |  |      \   \    |   _  < |  |
|  |\  \----.|  `--'  |.----)   |      |  |  .----)   |   |  |_)  ||  |
| _| `._____| \______/ |_______/       |__|  |_______/    |______/ |__|

[rustsbi] Implementation: RustSBI-QEMU Version 0.1.1
[rustsbi-dtb] Hart count: cluster0 with 1 cores
[rustsbi] misa: RV64ACDFHIMSU
[rustsbi] mideleg: ssoft, stimer, sext (0x1666)
[rustsbi] medeleg: ima, ia, bkpt, la, sa, uecall, ipage, lpage, spage (0xb1ab)
[rustsbi] pmp0: 0x10000000 ..= 0x10001fff (rw-)
[rustsbi] pmp6: 0x2000000 ..= 0x200ffff (rw-)
[rustsbi] pmp12: 0xc000000 ..= 0xc3fffff (rw-)
[rustsbi] enter supervisor 0x80200000
[nimkernel] Nya~
```

Here we got the `[nimkernel] Nya~` output 😃

![fufu](fufu.gif)

~~真下饭~~

## Reference

- slimeOS
- nimkernel
- xv6-riscv
