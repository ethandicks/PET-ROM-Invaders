
ASM=dasm
AFLAGS=-f3

.SUFFIXES: .bin .asm

PROGRAMS=rom-invaders.bin

all:	$(PROGRAMS)

%bin: %asm
	$(ASM) $< $(AFLAGS) -o$@ -l$*lis

clean:
	rm -f *.hex *.bin *.lis


