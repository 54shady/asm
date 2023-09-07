;hello.asm
section .data
	msg db "hello, world", 10, 0 ;10是new line的ASCII编码的十进制
section .bss
section .text
	global main
main:
	;64bit系统调用号: arch/x86/entry/syscalls/syscall_64.tbl
	;32bit系统调用号: arch/x86/entry/syscalls/syscall_32.tbl

	mov rax, 1	;系统调用write的调用号
	mov rdi, 1	;第一个参数, 标准输出
	mov rsi, msg	;第二个参数
	mov rdx, 13		;第三个参数:字符串长度,要包含\n
	syscall	;调用write

	mov rax, 60 ;系统调用exit的调用号
	mov rdi, 0	;返回值:0
	syscall	;调用exit
