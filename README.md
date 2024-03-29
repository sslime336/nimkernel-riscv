# nimkernel-riscv

I wrote this just for fun.

Support multi-CPUs.

## Deps

I just listed my environment 😛

- Nim >= 1.6.10
- qemu v7.0.0(qemu-system-riscv64, better higher than v5.x.x)
- Nimble(for nake)
- nake
- C compiler(riscv64-unknown-elf-*)

## Run

```shell
nake run
```

And then you'll see:

```plaintext
cleaned all previous build.
[rustsbi] RustSBI version 0.2.2, adapting to RISC-V SBI v1.0.0
.______       __    __      _______.___________.  _______..______   __
|   _  \     |  |  |  |    /       |           | /       ||   _  \ |  |
|  |_)  |    |  |  |  |   |   (----`---|  |----`|   (----`|  |_)  ||  |
|      /     |  |  |  |    \   \       |  |      \   \    |   _  < |  |
|  |\  \----.|  `--'  |.----)   |      |  |  .----)   |   |  |_)  ||  |
| _| `._____| \______/ |_______/       |__|  |_______/    |______/ |__|

[rustsbi] Implementation: RustSBI-QEMU Version 0.1.1
[rustsbi-dtb] Hart count: cluster0 with 3 cores
[rustsbi] misa: RV64ACDFHIMSU
[rustsbi] mideleg: ssoft, stimer, sext (0x1666)
[rustsbi] medeleg: ima, ia, bkpt, la, sa, uecall, ipage, lpage, spage (0xb1ab)
[rustsbi] pmp0: 0x10000000 ..= 0x10001fff (rw-)
[rustsbi] pmp6: 0x2000000 ..= 0x200ffff (rw-)
[rustsbi] pmp12: 0xc000000 ..= 0xc3fffff (rw-)
[rustsbi] enter supervisor 0x80200000
[nimkernel] Nya~
QEMU 7.0.0 monitor - type 'help' for more information
(qemu) q
```

Here we got the `[nimkernel] Nya~` output 😃

Type Ctrl + A then singly type c to shutdown this kernel.

![fufu](fufu.gif)

~~真下饭~~

## How to debug

I have config debug-sever which should be started first.

```bash
nake debug-server
```

There would not print anything though, the server is already started.

The next step is to start debugging in another shell.

```bash
nake debug
```

Then make a breakpoint at 0x8020000 by:

```bash
b *0x80200000
```

Press `c` and `Enter` to continue.

Now we have enter the nimkernel's `_entry`, where you can start debugging :P
