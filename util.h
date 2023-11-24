#ifndef UTIL_H
#define UTIL_H

#include <ax/u1024.h>
#include <stdio.h>

int print_u1024(ax_u1024 *u, FILE *fp, int base);

void u1024_factorial(const ax_u1024* a, ax_u1024* res);

void u1024_log2(const ax_u1024 *a, ax_u1024 *b, bool floor);

#endif

