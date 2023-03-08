import nake
import std/strformat
import std/os
import std/strutils

{.hint[XDeclaredButNotUsed]: off.}

const
  KERNEL_ENTRY_PHYSICAL_ADDRESS = 0x80200000
  CACHE_DIR = "build/.cache"
  LINKER = "src/linker.ld"
  KERNEL = "build/nimkernel"
  KERNEL_BIN = "build/nimkernel.bin"
  ENTRY = "src/entry.S"
  ENTRY_O = "build/entry.o"
  BOOTLOADER = "bootloader/rustsbi-qemu.bin"

  SRC = "src/"

  TOOLPREFIX = "riscv64-unknown-elf-"

  CC = TOOLPREFIX & "gcc"
  AS = TOOLPREFIX & "as"
  LD = TOOLPREFIX & "ld"

# For beautiful output, I just ignore all of these:
#   -Wall \
#   -Werror \
#   -Wextra \
# You can add them as you wish :)
#
# Notice that cross-compiling needs -std=gnu99 or -std=c99
const CFLAGS = fmt"""
-fno-omit-frame-pointer \
-ggdb \
-gdwarf-2 \
-MD \
-mcmodel=medany \
-ffreestanding \
-fno-common \
-nostdlib \
-std=gnu99 \
"""

const
  OBJCOPY = TOOLPREFIX & "objcopy"
  OBJDUMP = TOOLPREFIX & "objdump"

  OUTPUT_DIR = "build"

  HINTS = "off"
  WARNINGS = "off"

  NIM_C = "nim c"
  NIM_C_FLAGS = fmt"""
--out: {KERNEL} \
--hints:{HINTS} \
--warnings: {WARNINGS} \
-d:release \
--opt:speed \
--gc:none \
--os:standalone \
--boundChecks:on \
--cpu:riscv64 \
--nimcache:{CACHE_DIR} \
--noMain \
--passc:"{CFLAGS}" \
--gcc.exe: {CC} \
--gcc.linkerexe: {LD} \
--passl: "-T{LINKER} {ENTRY_O}" \
"""

  NIM_MAIN = "src/main.nim"

  QEMU = "qemu-system-riscv64"

task "clean", "clean previous build":
  if dirExists(OUTPUT_DIR):
    removeDir(OUTPUT_DIR)
    echo "cleaned all previous build."

template pretty(): untyped =
  echo "\n"
  echo "======>nimkernel<======"
  echo "\n"

task "build", "build kernel":
  if not dirExists(OUTPUT_DIR):
    createDir(OUTPUT_DIR)

  # Complie the entry.
  direShell AS, fmt"{ENTRY} -o {ENTRY_O}"
  # Compile all nim files.
  direShell fmt"nim c {NIM_C_FLAGS} {NIM_MAIN}"
  # Strip kernel
  direShell fmt"{OBJCOPY} -S -O binary {KERNEL} {KERNEL_BIN}"

  when defined(checkKernelBin):
    echo "KERNEL: objdump can recognize it."
    direShell fmt"{OBJDUMP} -h {KERNEL}"

    echo "KERNEL_BIN: should without meta info."
    shell fmt"{OBJDUMP} -h {KERNEL_BIN}"

    pretty()

const runKernel_OpenSBI = fmt"""
{QEMU} \
-machine virt \
-nographic \
-kernel {KERNEL_BIN} \
-device loader,file={KERNEL_BIN},addr={KERNEL_ENTRY_PHYSICAL_ADDRESS}
"""

# 1. You can use the new RustSBI, the RustSBI source code can be downloaded from:
# <https://github.com/rustsbi/rustsbi/releases>
#
# 2. Place you rustsbi-qemu.bin in `bootloader/`, whose default value is "bootloader/rustsbi-qemu.bin"
const runKernel_RustSBI = fmt"""
{QEMU} \
-machine virt \
-nographic \
-bios {BOOTLOADER} \
-device loader,file={KERNEL_BIN},addr={KERNEL_ENTRY_PHYSICAL_ADDRESS}
"""

task "run", "run the kernel on qemu":
  runTask("clean")
  runTask("build")
  direShell runKernel_OpenSBI

task defaultTask, "build after clean and start running":
  runTask("run")
