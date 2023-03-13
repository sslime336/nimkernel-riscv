OUTPUT_ARCH( "riscv" )
ENTRY( _entry )

SECTIONS
{
	. = 0x80200000;

	. = ALIGN(0x1000);
	.text : {
		*(.text.entry)
		*(.text .text.*)
	}

	. = ALIGN(0x1000);
	.rodata : {
		*(.rodata .rodata.*)
	}

	. = ALIGN(0x1000);
	.data : {
		*(.data .data.*)
	}

	. = ALIGN(0x1000);
	.bss : {
		*(.bss.stack)
		*(.bss .bss.*)
	}

	PROVIDE(ekernel = .); 
}
