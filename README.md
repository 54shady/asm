# ASM Basic

参考书: Beginning x64 Assembly Programming(From Novice to AVX Professional)

## 寄存器

以寄存器A为例说明各位数关系

	RAX	64bit
	EAX 32bit
	AX	16bit
	AXH	8bit high
	AXL 8bit low

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

### Intel语法

mov指令格式如下(像是c语言)

	mov destination, source

- mov 寄存器, 即时值
- mov 寄存器, 内存
- mov 内存, 寄存器

使用gdb时可以通过如下来设置汇编风格intel或AT&T

(gdb) set disassembly-flavor intel

### AT&T语法

AT&T的语法正好相反,类似linux命令

	mov source, destination

寻址方式:

1. 寄存器寻址(Register mode):操作的是寄存器,不和内存打交道

	movl %eax, %edx ;把eax寄存器内容放到寄存器edx中
	相当于c语言里edx = eax

2. 立即寻址(immediate)用一个$符号开头跟一个数

	movl $0x123, %edx ;把0x123这个数放到寄存器edx中
	相当于c语言里edx = 0x123

3. 直接寻址(direct),开头不带$符号,表示地址值(用内存地址直接访问内存数据)

	movl 0x123, %edx ;把内存地址为0x123里存储的数据放到edx寄存器中
	相当于c语言里edx = *(int *)0x123

4. 间接寻址(indirect)

	movl (%ebx), %edx

	ebx寄存器中存储的是内存的地址
	加括号来获取这个内存地址所存储的数据
	相当于c语言里edx = *(int *)ebx

5. 变地寻址(displaced)

	movl 4(%ebx), %edx
	相当于c语言里edx = *(int *)(ebx+4)

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

## 调用约定(函数参数)

这里以System V ADM64 ABI调用约定(Linux平台标准, Windows的是x64调用约定)

[Intel mpx linux64 api](https://software.intel.com/sites/default/files/article/402129/mpx-linux64-api.pdf)

传递参数和结果的方法由调用约定决定

### 无浮点参数

非浮点参数(整数和地址)按以下方式传递

- 第一个参数放入rdi
- 第二个参数放入rsi
- 第三个参数放入rdx
- 第四个参数放入rcx
- 第五个参数放入r8
- 第六个参数放入r9

其它参数通过栈以相反的顺序传递(例如有10个参数)

- 压入第十个参数
- 压入第九个参数
- 压入第八个参数
- 压入第七个参数

返回地址紧跟在参数之后被压入栈

### 有浮点参数

浮点参数通过xmm寄存器传递

- 第一个参数放入xmm0
- 第二个参数放入xmm1
- 第三个参数放入xmm2
- 第四个参数放入xmm3
- 第五个参数放入xmm4
- 第六个参数放入xmm5
- 第七个参数放入xmm6
- 第八个参数放入xmm7

## 函数序言和尾声(栈对齐要求)

函数序言(在代码中有如下代码)

	push rbp
	mov rbp, rsp

函数尾声(在代码中有如下代码)

	mov rsp, rbp
	pop rbp

之所以需要序言和尾声是为了栈(16字节)对齐

原则上每次调用函数都需要构建栈帧(即序言)

	push rbp		;首先在16字节的边界上对齐栈
	mov rbp, rsp	;保存rsp到rbp中

退出函数时顺序相反(尾声)

	mov rsp, rbp	;还原rsp
	pop rbp			;弹出rbp

编译器的优化功能会将不需要栈帧的情况优化掉序言和尾声

- 可以将序言替换成enter 0, 0 ;enter性能差
- 可以将尾声替换成leave

## SIMD, MMX, SSE, AVX

- SIMD(Single Instruction Multiple Data)
- SIMD的一个实现是MMX(多媒体扩展, 多重数学扩展, 矩阵数学扩展)
- SSE(Streaming SIMD Extension)
- MMX被SSE取代, SSE又被AVX(Advanced Vector Extension)取代
- 支持SSE功能的处理器有16个额外的128位寄存器xmm0~xmm15和一个控制状态寄存器mxcsr
- AVX寄存器(ymm, 256位)大小是xmm的两倍,还有AVX-512(zmm 512位)
