;function2.asm
extern printf
section .data
	radius dq 10.0
section .bss
section .text

;area 函数
area:
section .data
	.pi dq 3.141592654	;area函数内的局部变量
section .text
push rbp
mov rbp, rsp

	movsd xmm0, [radius]
	mulsd xmm0, [radius]
	mulsd xmm0, [.pi]

leave
ret

;circum函数
circum:
section .data
	.pi dq 3.14		;circum函数内的局部变量
section .text
push rbp
mov rbp, rsp

	movsd xmm0, [radius]
	addsd xmm0, [radius]
	mulsd xmm0, [.pi]

leave
ret

;circle函数
circle:
section .data
	.fmt_area db "The area is %f", 10, 0
	.fmt_circum db "The circumference is %f", 10, 0
section .text
push rbp
mov rbp, rsp

	;调用area计算出面积后打印
	call area
	mov rax, 1	;使用到area返回值xmm0,并作为第二个参数
	mov rdi, .fmt_area
	;mov xmm0, ...
	call printf

	;调用circum计算出周长后打印
	call circum
	mov rax, 1	;使用到circum返回值xmm0,并作为第二个参数
	mov rdi, .fmt_circum
	;mov xmm0, ...
	call printf

leave
ret

global main
main:
push rbp
mov rbp, rsp

	call circle

leave
ret
