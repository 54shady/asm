all: function function2

function: function.o
	gcc -o function function.o -no-pie

function2: function2.o
	gcc -o function2 function2.o -no-pie

function.o: function.asm
	nasm -f elf64 -g -F dwarf function.asm -l function.lst

function2.o: function2.asm
	nasm -f elf64 -g -F dwarf function2.asm -l function2.lst

clean:
	rm -rf *.o *.lst function function2
