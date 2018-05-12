#include <stdio.h>

int a(char *arg) {
	if (arg == NULL)
		return -1;
	else
		return (int)*arg;
}

int b(char *arg) {
	if (__builtin_expect(arg == NULL, 0))
		return -1;
	else
		return (int)*arg;
}

int c(char *arg) {
	if (__builtin_expect(arg == NULL, 1))
		return -1;
	else
		return (int)*arg;
}

int d(char *arg) {
	if (arg == NULL)
		return -1;
	else if ((unsigned long)arg > 0x20000000)
		return (int)*(arg - 2);
	else
		return (int)*(arg);
}

int e(char *arg) {
	if (__builtin_expect(arg == NULL, 0))
		return -1;
	else if (__builtin_expect((unsigned long)arg > 0x20000000, 1))
		return (int)*(arg - 2);
	else
		return (int)*(arg);
}
