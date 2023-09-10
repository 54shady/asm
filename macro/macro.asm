;macro.asm
extern printf

%define double_it(r)	sal r, 1	;单行宏,将参数r左移1位

%macro	prntf 2	;带有2个参数的多行宏
section .data
	;宏中定义变量使用%%
	%%val	db %1, 0	;宏的第一个参数用%1表示
	%%fmtint db "%s %ld", 10, 0	;格式化字符串
section .text
	mov rdi, %%fmtint	;printf的第一个参数
	mov rsi, %%val		;printf的第二个参数
	mov rdx, [%2]	;宏的第二个参数用%2表示, printf的第三个参数
	mov rax, 0		;没有浮点数要打印
	call printf
%endmacro

section .data
	number dq	15
section .bss
section .text
	global main
main:
push rbp
mov rbp, rsp

	prntf "The number is", number
	mov rax, [number]
	double_it(rax)

	mov [number], rax
	prntf "The number times 2 is", number

leave
ret
