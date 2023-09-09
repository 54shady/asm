;alive2.asm
section .data
	msg1 db "Hello, World", 0
	msg2 db "Alive and Kicking!", 0
	radius dd 357
	pi dq 3.14
	fmtstr db "%s", 10, 0 	;用于打印字符串格式
	fmtflt db "%lf", 10, 0 	;用于打印浮点数格式
	fmtint db "%d", 10, 0 	;用于打印整数格式
section .bss
section .text
extern printf
	global main
main:
	push rbp
	mov rbp,rsp

	;printf(fmtstr, msg1)
	mov rax, 0 		;清除rax,表示在xmm寄存器中没有要打印的浮点数
	mov rdi, fmtstr ;printf的第一个参数
	mov rsi, msg1 	;printf的第二个参数
	call printf

	;printf(fmtstr, msg2)
	mov rax, 0 		;清除rax,表示在xmm寄存器中没有要打印的浮点数
	mov rdi, fmtstr ;printf的第一个参数
	mov rsi, msg2 	;printf的第二个参数
	call printf

	;printf(fmtint, radius)
	mov rax, 0 		;清除rax,表示在xmm寄存器中没有要打印的浮点数
	mov rdi, fmtint ;printf的第一个参数
	mov rsi, [radius] 	;printf的第二个参数
	call printf

	;printf(fmtflt, pi)
	mov rax, 1		;使用一个xmm寄存器
	mov rdi, fmtflt ;printf的第一个参数
	movq xmm0, [pi]	;printf的第二个参数
	call printf

	mov rsp, rbp
	pop rbp

	ret	;等效系统调用exit
