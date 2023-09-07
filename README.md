# ASM Basic

参考书: Beginning x64 Assembly Programming(From Novice to AVX Professional)

## .data段

格式如下

<变量名称> <类型> <值>

其中类型如下(d开头)

db	8bit	byte
dw 	16bit	word
dd 	32bit	double word
dq 	64bit	quad word

字符串一般用数字0结尾(不是ASCII 0)

如下定义一个字符串变量msg内容为"hello, world"并以0结尾

	msg db "hello, world", 0

定义常量格式如下

	<常量名称> equ <值>

比如定义常量pi等于3.14

	pi equ 3.14

## .bss段(block started by symbol, 为初始化的变量)

格式如下

	<变量名称> <类型> <数字>

其中类型如下(res开头)

resb	8bit	byte
resw	16bit	word
resd	32bit	double word
resq	64bit	quad word

定义一个包含20个双字的数组

	dArray resd	20

## 指令

mov指令格式如下

	mov destination, source

- mov 寄存器, 即时值
- mov 寄存器, 内存
- mov 内存, 寄存器

使用gdb时可以通过如下来设置汇编风格intel或AT&T

(gdb) set disassembly-flavor intel

## lst文件

下面是第一个程序输出的lst文件片段

- 第一列是行号
- 第二列是内存位置(按照段分,所以有多个0位置,bss不分配内存)
- 第三列中会将汇编指令转换为十六进制
	比如将mov rax转换为B8, mov rdi转换为BF
- 从代码段的0位置的第一条指令开始执行(11行, 占用5个字节)
	其中两个双零(00)用于填充和内存对齐
	内存对齐是汇编器和编译器用来优化代码的功能
- 内存地址为8个字节(64bit)
	由于当前还不知道msg的存储位置,所以被标记为[0000000000000000]

     1                                  ;hello.asm
     2                                  section .data
     3 00000000 68656C6C6F2C20776F-     	msg db "hello, world", 0
     3 00000009 726C6400
     4                                  section .bss
     5                                  section .text
     6                                  	global main
     7                                  main:
     8                                  	;64bit系统调用号: arch/x86/entry/syscalls/syscall_64.tbl
     9                                  	;32bit系统调用号: arch/x86/entry/syscalls/syscall_32.tbl
    10
    11 00000000 B801000000              	mov rax, 1	;系统调用write的调用号
    12 00000005 BF01000000              	mov rdi, 1	;第一个参数, 标准输出
    13 0000000A 48BE-                   	mov rsi, msg	;第二个参数
    13 0000000C [0000000000000000]

