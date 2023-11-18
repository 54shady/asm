#include <stdio.h>

/*
 * gcc -m32 sum.c -osum
 * -m32 编译成32位指令
 */
int main(int argc, char *argv[])
{
	unsigned int val1 = 1;
	unsigned int val2 = 2;
	unsigned int val3 = 0;

	printf("val1 = %d, val2 = %d, val3 = %d\n", val1, val2, val3);
	/* val3 = val1 + val2 */
	/*
	 * __asm__ __volatile__ (
	 *		汇编语句模板(一条指令一行):
	 *		输出部分:
	 *		输入部分:
	 *		破坏描述部分
	 * );
	 *
	 * 引用输出和输出和破坏描述参数用%0, %1,这样顺序引用
	 *
	 * __asm__和asm可以替换使用
	 * __volatile__和volatile可以替换使用
	 *
	 * 因为引用寄存器时有%符号,内嵌代码中使用转译符%所以就有两个%号
	 */
	asm volatile(
			"movl $0, %%eax\n\t" /* clear eax to 0 */
			"addl %1, %%eax\n\t" /* 把第1个参数加到eax, eax += val1 */
			"addl %2, %%eax\n\t" /* 把第2个参数加到eax, eax += val2 */
			"movl %%eax, %0\n\t" /* 把eax值放入到第0个参数,即val3 */
			: "=m" (val3) /* 输出参数val3, =表示操作数是只写的, m表示内存变量, 用%0引用 */
			: "c" (val1), "d" (val2) /* c表示将输入变量val1放入到ecx寄存器中, 用%1引用
									d表示将输入变量val1放入到ecx寄存器中, 用%2引用 */
			);
	printf("%d + %d = %d\n", val1, val2, val3);

	return 0;
}
