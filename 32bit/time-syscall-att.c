#include <stdio.h>
#include <time.h>

/*
 * gcc time-syscall-att.c -o time-syscall-att -masm=att
 */
int main(int argc, char *argv[])
{
	time_t tt;
	struct tm *t;

#ifdef PUREC
	tt = time(NULL);
#else
	/* using asm instead of c api */
	asm volatile(
			"mov $201, %%rax\n\t" /* 64位中使用A寄存器存储系统调用号, time系统号201 */
			"mov $0, %%rdi\n\r" /* 64位中使用DI寄存器存第一个参数 */
			"syscall\n\t" /* 64位的syscall指令 */
			"mov %%rax, %0\n\t" /* 系统调用的返回值在eax中, 将其存入输出参数 */
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
