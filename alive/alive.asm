;alive.asm
section .data
	msg1 db "Hello, World", 10, 0
	msg1Len	equ $-msg1-1	;计算msg1的长度: $表示当前内存地址,减去msg1内存地址,再减去1(\0)
	msg2 db "Alive and Kicking!", 10, 0
	msg2Len equ $-msg2-1
	radius dq 357
	pi dq 3.14
section .bss
section .text
	global main
main:
	push rbp
	mov rbp,rsp

	;调用write输出msg1
	mov rax, 1
	mov rdi, 1
	mov rsi, msg1
	mov rdx, msg1Len
	syscall

	;调用write输出msg2
	mov rax, 1
	mov rdi, 1
	mov rsi, msg2
	mov rdx, msg2Len
	syscall

	mov rsp, rbp
	pop rbp

	;调用exit
	mov rax, 60
	mov rdi, 0
	syscall


