all: alive alive2

alive: alive.o
	gcc -o alive alive.o -no-pie

alive2: alive2.o
	gcc -o alive2 alive2.o -no-pie

alive.o: alive.asm
	nasm -f elf64 -g -F dwarf alive.asm -l alive.lst

alive2.o: alive2.asm
	nasm -f elf64 -g -F dwarf alive2.asm -l alive2.lst

clean:
	rm -rf *.o *.lst alive alive2
