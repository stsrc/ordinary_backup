#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
	if (argc != 4) {
		printf("move_print d/h <value in specified format> <decimal by how many>\n");
		return 1;
	}
	bool decimal;
	if (*argv[1] == 'd') {
		decimal = true;
	} else if (*argv[1] == 'h') {
		decimal = false;
	} else {
		printf("move_print d/h <value in specified format> <decimal by how many>\n");
		return 1;
	}
	int base = decimal ? 10 : 16;
	unsigned long val = strtoul(argv[2], NULL, base);
	unsigned long rot = strtoul(argv[3], NULL, 10);
	unsigned long result = val << rot;
	printf("dec: %lu\n", result);
	printf("hex: %08x\n", (unsigned) result);
	printf("bin: 0b");
	for (int i = 0; i < 8; i++) {
		if (result & (1 << 7 - i)) {
			printf("1");
		} else {
			printf("0");
		}
	}
	printf("\n");
	return 0;
}
