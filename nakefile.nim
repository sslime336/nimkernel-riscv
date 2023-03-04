import nake
import std/strformat
import std/os

const
  KERNEL_ENTRY_PHYSICAL_ADDRESS = 0x80200000
  CACHE_DIR = "build/.cache"
  LINKER = "src/linker.ld"
  KERNEL = "build/nimkernel"
  KERNEL_BIN = "build/nimkernel.bin"
  ENTRY = "src/entry.S"
  ENTRY_O = "build/entry.o"
  BOOTLOADER = "bootloader/rustsbi-qemu.bin"


  TOOLPREFIX = "riscv64-unknown-elf-"

  CC = TOOLPREFIX & "gcc"
  AS = TOOLPREFIX & "as"

# For beautiful output, I just ignore all of these:
#   -Wall \
#   -Werror \
#   -Wextra \
# You can add them as you wish :)
const  CFLAGS = """
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

  NIM_C = "nim c"
  NIM_C_FLAGS = fmt"""
--hints:off \
-d:release \
--gc:none \
--os:standalone \
--boundChecks:on \
--cpu:riscv64 \
--nimcache:{CACHE_DIR} \
--noMain \
--noLinking \
--passc:"{CFLAGS}" \
--parallelBuild:"1" \
--gcc.exe:{CC} \
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

task "build", "build kernel":
  if not dirExists(OUTPUT_DIR):
    createDir(OUTPUT_DIR)

  direShell fmt"{NIM_C} {NIM_C_FLAGS} {NIM_MAIN}"
  direShell AS, fmt"{ENTRY} -o {ENTRY_O}"
  direShell CC, fmt"-T {LINKER} -o {KERNEL} -ffreestanding -O2 -nostdlib {ENTRY_O} {BUILD_CACHE} -lgcc"

  # strip kernel
  direShell fmt"{OBJCOPY} -S -O binary {KERNEL} {KERNEL_BIN}"

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
  direShell runKernel_RustSBI
