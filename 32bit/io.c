#include <stdio.h>

/* gcc -m32 io.c -oio */
int main(int argc, char *argv[])
{
	int input, output, temp;

	input = 1;

	asm volatile(
			"movl $0, %%eax\n\t" /* eax = 0 */
			"movl %%eax, %1\n\t" /* temp = eax */
			"movl %2, %%eax\n\t" /* eax = input */
			"movl %%eax, %0\n\t" /* output = eax */
			: "=m" (output), "=m" (temp)
			: "r" (input) /* 将变量input放入到通用寄存器eax, ebx, ecx, edx, esi,
							edi 中的任意一个 */
			: "eax" /* eax寄存器会变动 */
			);

	printf("output = %d, temp = %d\n", output, temp);

	return 0;
}
