macro: macro.o
	gcc -o macro macro.o -no-pie
	objdump -M intel -d macro > macro.dis

macro.o: macro.asm
	nasm -f elf64 -g -F dwarf macro.asm -l macro.lst

clean:
	rm -rf *.o *.lst *.dis macro
