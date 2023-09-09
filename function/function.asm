;function.asm
extern printf
section .data
	radius	dq	10.0
	pi		dq	3.14
	fmt		db	"The area of the circle is %.2f", 10, 0
section .bss
section .text
	global main
main:
push rsp
mov rbp, rsp

	call area	;调用函数

	mov rax, 1		;使用一个xmm寄存器(xmm0)
	mov rdi, fmt ;printf的第一个参数
	;mov xmm0, ...	;xmm0已经被作为area函数返回值赋值了,这里可以直接用
	;printf的第二个参数使用的是area的返回值
	call printf

	leave	;等价与下面两条指令
	;mov rsp, rbp
	;pop rbp

	ret

; function area
area:
push rbp
mov rbp, rsp

	movsd xmm0, [radius]	;将浮点数放入xmm0
	mulsd xmm0, [radius]	;浮点数radius乘xmm0,结果放入xmm0
	mulsd xmm0, [pi]		;浮点数pi乘xmm0,结果放入xmm0
	;函数的返回值
	;如果是浮点数返回值则存放在xmm0
	;如果是非浮点数返回值则存放在rax

	leave
	ret
