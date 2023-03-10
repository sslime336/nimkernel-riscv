import nake
import std/strformat
import std/os

{.hint[XDeclaredButNotUsed]: off.}

const
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
  DEBUG = "riscv64-unknown-elf-gdb"

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

const
  MACHINE = "virt"
  CPU = "rv64"
  MEM = "128M"
  NHART = "5"
  
  RUST_SBI = "bootloader/rustsbi-qemu.bin"

template kernelRun(): string =
  fmt"""
  {QEMU} -M {MACHINE} \
	       -nographic \
	       -cpu {CPU} \
         -bios {RUST_SBI} \
	       -m {MEM} \
	       -kernel {KERNEL_BIN} \
	       -smp {NHART}
  """

template kernelDebugServer(): string =
  fmt"""
	{QEMU} -M {MACHINE} \
	       -nographic \
	       -cpu {CPU} \
         -bios {RUST_SBI} \
	       -m {MEM} \
	       -kernel {KERNEL_BIN} \
	       -smp {NHART} \
	       -s -S 
  """

template kernelDebug(): string =
  fmt"""
	{DEBUG} -ex 'file {KERNEL}' \
	        -ex 'set arch riscv:rv64' \
	        -ex 'target remote localhost:1234'
  """

task "run", "run the kernel on qemu":
  runTask("clean")
  runTask("build")
  direShell(kernelRun())

task defaultTask, "build after clean and start running":
  runTask("run")

task "debug-server", "start gdb debug-server":
  direShell(kernelDebugServer())

task "debug", "start gdb debugging":
  direShell(kernelDebug())
