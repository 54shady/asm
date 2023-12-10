#include <stdio.h>
#include <time.h>

/*
 * gcc -m64 time-int-intel.c -o time-int-intel -masm=intel
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
	 * Legacy mode 系统调用使用int指令
	 *
	 * 这里使用Intel的汇编语法
	 *
	 * 在64位机器上运行32位模式的系统调用方式
	 * 寄存器还是需要使用64位的
	 */
	asm volatile(
			".intel_syntax noprefix;" /* 使用intel的语法 */
			"mov rbx, 0;" /* 32位中使用B寄存器存第一个参数 */
			"mov rax, 0xd;" /* 32位使用A寄存器存储系统调用号, 对应32位系统调用号 */
			"int 0x80;" /* 这里使用legacy的模式, int指令发出系统调用, 而不是syscall指令 */
			"mov %0, rax;" /* 系统调用的返回值在rax中, 将其存入输出参数 */
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
