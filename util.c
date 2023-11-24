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

void u1024_factorial(const ax_u1024* n, ax_u1024* res)
{
	if (ax_u1024_is_zero(n)) {
		ax_u1024_from_int(res, 1);
		return;
	}
        ax_u1024 i = *n, tmp = *n;
        ax_u1024_dec(&i);
        while (!ax_u1024_is_zero(&i)) {
                ax_u1024_mul(&tmp, &i, res);
                ax_u1024_dec(&i);
		tmp = *res;
        }
}

void u1024_log2(const ax_u1024 *a, ax_u1024 *b, bool floor)
{
        int idx = -1;
        for (int i = AX_U1024_ARR_LEN; i >= 0; i--) {
                if(a->array[i]) {
                        idx = i;
                        break;
                }
        }
        if (idx == -1) {
                ax_u1024_from_int(b, 0);
        }
        else {
                bool have_one = false;

                uint32_t word = a->array[idx];
                int bit = 0;
                for (int i = 0; i < 32; i++) {
                        if ((word >> i) & 1)
                                bit = i;
                }
                if (floor) {
                        for (int i = 0; i < idx; i++) {
                                if(a->array[i] != 0) {
                                        have_one = true;
                                        break;
                                }
                        }
                        if (word != (1 << bit))
                                have_one = true;
                }
                ax_u1024_from_int(b, idx * 32 + bit + have_one);
        }
}
