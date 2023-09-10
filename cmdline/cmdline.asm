;cmdline.asm
extern printf
section .data
	msg db "The command and arguments: ", 10, 0
	fmt db "%s", 10, 0
section .bss
section .text
	global main

;int main(int argc, char *argv[])
;使用gdb启动程序
;gdb --args ./cmdline arg1 arg2 arg3
;
;查看rsi寄存器地址(0x7fffffffdd98 + 8就是下一个参数)
;(gdb) info registers rsi
;rsi            0x7fffffffdd98      140737488346520
;
;查看rsi保存的内容:保存的是地址
;(gdb) x /1xg 0x7fffffffdd98
;0x7fffffffdd98: 0x00007fffffffe142
;
;查看地址所保存的内容(删除一部分)
;(gdb) x /s 0x00007fffffffe142
;0x7fffffffe142: "/path/to/cmdline"

main:
push rbp
mov rbp, rsp

	mov r12, rdi	;rdi就是argc,这里将其保存在r12
	mov r13, rsi	;rsi就是argv,这里将其保存在r13

	;因为这里调用printf,所以上面先保存argc和argv
	;打印标题
	mov rdi, msg
	call printf

	;打印命令和参数
	mov r14, 0	;用做指针
.ploop:
	mov rdi, fmt
	mov rsi, qword [r13+r14*8]
	call printf
	inc r14
	cmp r14, r12	;是否打印完所有参数
	jl .ploop

leave
ret
