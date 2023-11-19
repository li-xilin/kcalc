#include "util.h"
#include <ax/mem.h>
#include <ax/string.h>
#include <assert.h>
#include <errno.h>

int print_u1024(ax_u1024 *u, FILE *fp, int base)
{
	char hexbuf[128 * 2 + 1];
	ax_u1024_to_string(u, hexbuf, sizeof hexbuf);
	char *p = hexbuf;

	if (base != 16) {
		char out_buf[1024 + 1];
		out_buf[sizeof out_buf - 1] = '\0';
		p = ax_strbaseconv(hexbuf, out_buf, sizeof out_buf - 1, 16, base);
		assert(p);
	}

	if (p[0])
		fprintf(fp, "%s\n", p);
	else
		fputs("0\n", fp);
	return 0;
}
