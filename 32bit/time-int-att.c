#include <stdio.h>
#include <time.h>

/*
 * gcc -m64 time-int-att.c -o time-int-att
 *
 * 显示指定使用AT&T的汇编
 * gcc -m64 time-int-att.c -o time-int-att -masm=att
 */
int main(int argc, char *argv[])
{
	time_t tt;
	struct tm *t;

#ifdef PUREC
	tt = time(NULL);
#else
	/*
	 * using asm instead of c api
	 * Legacy mode 系统调用使用int指令, int 0x80
	 * 调用约定是(对应syscall_32.tbl):
	 *	A寄存器作为系统调用号
	 *	B寄存器作为第一个参数
	 *
	 * 这里使用AT&T的汇编语法
	 */
	asm volatile(
			"mov $0, %%rbx\n\t" /* 使用B寄存器存第一个参数 */
			"mov $0xd, %%rax\n\t" /* 使用A寄存器存储系统调用号 */
			"int $0x80\n\t" /* 这里使用legacy的模式, int指令发出系统调用,
							   而不是64位的syscall指令 */
			"mov %%rax, %0\n\t" /* 系统调用的返回值在rax中, 将其存入输出参数 */
			: "=m" (tt)
			);
#endif
	t = localtime(&tt);
	printf("time:%d:%d:%d:%d:%d:%d\n",
			t->tm_year + 1900,
			t->tm_mon,
			t->tm_mday,
			t->tm_hour,
			t->tm_min,
			t->tm_sec);

	return 0;
}
