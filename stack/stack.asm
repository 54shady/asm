;stack.asm
extern printf
section .data
	strng db "ABCDE", 0
	strngLen equ $ - strng - 1
	fmt1 db "The original string %s", 10, 0
	fmt2 db "The reversed string %s", 10, 0
section .bss
section .text
	global main
main:
push rbp
mov rbp, rsp

	;打印原始字符串
	mov rdi, fmt1
	mov rsi, strng
	mov rax, 0	;没有浮点
	call printf

	;将字符串逐个压入栈
	xor rax, rax		;清rax, 等价mov rax, 0
	mov rbx, strng		;将字符串地址装入rbx
	mov rcx, strngLen 	;将字符串长度装入rcx
	mov r12, 0			;用r12作为指针
pushLoop:
	mov al, byte [rbx + r12]	;把字符放入rax
	push rax					;把rax压入栈
	inc r12						;指针加1
	loop pushLoop				;执行循环, 循环结束条件是什么?

	;将字符串从堆栈中逐个弹出(反转字符串)
	mov rbx, strng		;将字符串地址装入rbx
	mov rcx, strngLen 	;将字符串长度装入rcx
	mov r12, 0			;用r12作为指针
popLoop:
	pop rax				;从栈上弹出一个字符存入rax
	mov byte [rbx+r12], al ; 将rax存储到strng中
	inc r12				;指针增加1
	loop popLoop
	mov byte [rbx+r12], 0 ;使用0终止字符串


	;再次打印字符串
	mov rdi, fmt2
	mov rsi, strng
	mov rax, 0	;没有浮点
	call printf

mov rsp, rbp
pop rbp
ret
