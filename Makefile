all: enigma.asm
	nasm -felf enigma.asm
	ld -m elf_i386 enigma.o -o enigma

clean:
	rm -f enigma.o 
	rm -f enigma
