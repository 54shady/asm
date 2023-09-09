all:hello hello2 hello3 hello4

# 默认情况下gcc会生成pie(Position Independent Executable)代码
# 目的是为了防止黑客调查程序使用内存并干扰程序运行
# 在下面的例子不需要用到这个pie代码
# 这里用gcc进行链接(不用gnu的连接器ld)是为了更容易在汇编中访问c标准库函数
hello: hello.o
	gcc -o hello hello.o -no-pie

hello2: hello2.o
	gcc -o hello2 hello2.o -no-pie

hello3: hello3.o
	gcc -o hello3 hello3.o -no-pie

hello4: hello4.o
	gcc -o hello4 hello4.o -no-pie

# 使用nasm汇编器
# -f elf64 : 输出64位可执行可链接格式executable link format
# -g -F dwarf : 希望以-F 后制定的dwarf(Debug With Arbitrary Record Format)输出调试格式
# -l : 生成lst文件
hello.o: hello.asm
	nasm -f elf64 -g -F dwarf hello.asm -l hello.lst

hello2.o: hello2.asm
	nasm -f elf64 -g -F dwarf hello2.asm -l hello2.lst

hello3.o: hello3.asm
	nasm -f elf64 -g -F dwarf hello3.asm -l hello3.lst

hello4.o: hello4.asm
	nasm -f elf64 -g -F dwarf hello4.asm -l hello4.lst

clean:
	rm -rf *.o *.lst hello hello2 hello3 hello4
