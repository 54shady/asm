#include <stdio.h>

int x = 11, y = 12, sum, prod;

int subtract(void);
void multiply(void);

/* 基本内联汇编 */
int main(int argc, char *argv[])
{
	printf("The number are %d and %d\n", x, y);

	/*
	 * 每一条指令用一对引号括起来
	 * 和汇编里不同,内嵌汇编引用变量不需要方括号
	 */
	__asm__(
			".intel_syntax noprefix;"
			"mov rax, x;"
			"add rax, y;"
			"mov sum, rax"
			);

	printf("The sum is %d\n", sum);

	printf("The difference is %d\n", subtract());

	multiply();

	return 0;
}

int subtract(void)
{
	/* 汇编返回值在rax中 */
	__asm__(
			".intel_syntax noprefix;"
			"mov rax, x;"
			"sub rax, y"
			);
}

void multiply(void)
{
	/* 将结果存在prod变量中 */
	__asm__(
			".intel_syntax noprefix;"
			"mov rax, x;"
			"imul rax, y;"
			"mov prod, rax"
			);
}
