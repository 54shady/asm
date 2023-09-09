;hello4.asm
extern printf ;声明外部函数
section .data
	msg db "hello, world", 0
	fmtstr db "This is our string: %s", 10, 0 ;打印格式
section .bss
section .text
	global main
main:
	push rbp
	mov rbp, rsp

	mov rdi, fmtstr ;printf的第一个参数
	mov rsi, msg 	;printf的第二个参数
	mov rax, 0 		;清除rax,表示在xmm寄存器中没有要打印的浮点数
	call printf		;调用c库函数

	mov rsp, rbp
	pop rbp

	mov rax, 60 ;系统调用exit的调用号
	mov rdi, 0	;返回值:0
	syscall	;调用exit
