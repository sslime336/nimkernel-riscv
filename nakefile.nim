import nake
import std/strformat
import std/os
import std/strutils

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
const CFLAGS = """
-O \
-fno-omit-frame-pointer \
-ggdb \
-gdwarf-2 \
-MD \
-mcmodel=medany \
-ffreestanding \
-fno-common \
-nostdlib \
-w -I$lib \
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
--hints:{HINTS} \
--warnings: {WARNINGS} \
-d:release \
--gc:none \
--os:standalone \
--boundChecks:on \
--cpu:riscv64 \
--nimcache:{CACHE_DIR} \
--noMain \
--noLinking \
--parallelBuild:"1" \
--gcc.exe:{CC} \
--passc:"{CFLAGS}" \
"""
  NIM_MAIN = "src/main.nim"

  QEMU = "qemu-system-riscv64"

task "clean", "clean previous build":
  if dirExists(OUTPUT_DIR):
    removeDir(OUTPUT_DIR)
  echo "Done."


const BUILD_CACHE = fmt"""
{CACHE_DIR}/@mmain.nim.c.o \
{CACHE_DIR}/@msbi.nim.c.o \
"""

proc formatObjFile(name: string): string =
  result = fmt"{CACHE_DIR}/@m{name}.nim.c.o \" & '\n'

task "load", "overwrite debug cache":
  # TODO: auto load files
  discard

template pretty(): untyped =
  echo "\n"
  echo "======>nimkernel<======"
  echo "\n"

task "build", "build kernel":
  if not dirExists(OUTPUT_DIR):
    createDir(OUTPUT_DIR)

  # Search and build all the nim files, adding them all
  # into the `BUILD_CACHE`.
  # runTask("load")

  # Compile all nim files.
  direShell fmt"{NIM_C} {NIM_C_FLAGS} {NIM_MAIN}"
  # Complie the entry.
  direShell AS, fmt"{ENTRY} -o {ENTRY_O}"

task "link", "link build cache together":
  # Link them all :)
  direShell LD, fmt"-T {LINKER} -o {KERNEL} {ENTRY_O} {BUILD_CACHE}"

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
  runTask("link")
  direShell runKernel_RustSBI

task defaultTask, "build after clean and start running":
  runTask("run")
