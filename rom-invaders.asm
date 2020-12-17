	; Processor directive required by dasm
	PROCESSOR 6502

; Copy routine for ROM-resident version of Space
; Invaders for the Commodore PET
;
; This code is meant to be stuck at the front of
; an EPROM image and combined with a binary copy
; of Space Invaders that is normally loaded into
; BASIC RAM starting at $0401.  Because Expansion
; ROM slots at $9000 and $A000 are open in all
; versions oF PETs, this ROM-resident version of
; Space Invaders is meant to be burned into two
; 4Kbyte ROMs (2532s or 2732s in socket adapters)
; and installed at $9000 and $A000, then invoked
; with SYS 36864.  It will copy everything between
; $9400 to $AFFF down to $0400 to $1FFF and jump
; to $040F, the original entry point when loaded
; into RAM.
;
; This program goes at the front of the 8Kbyte
; block, Space Invaders goes at the end of the
; 8Kbyte block, and any byte can be used for fill
; in-between

; This program can be assembled with 'dasm'
; https://github.com/dasm-assembler/dasm

FROM	EQU 	$9400		; Source address for copy
TO	EQU	$0400		; Destination address for copy

START	EQU	TO+$000F	; Program start address to jump to

	ORG	$9000		; ROM address for start of 8KB block

	MAC	XCOPY
	LDA	FROM+{1},X
	STA	TO+{1},X
	ENDM


; Break up copy into two swaths because doing all 28 pages
; at once makes the loop body exceed 128 bytes
;
	LDX	#0		; Clear index
LOOP1
PAGE	SET	0
	REPEAT	16
	XCOPY	PAGE
PAGE	SET	PAGE + $100
	REPEND

	INX
	BNE	LOOP1		; Repeat until all bytes copied

LOOP2
PAGE	SET	$1000
	REPEAT	12
	XCOPY	PAGE
PAGE	SET	PAGE + $100
	REPEND

	INX
	BNE	LOOP2		; Repeat until all bytes copied

	JMP	START		; Start Space Invaders in RAM

