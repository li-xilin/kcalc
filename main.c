/*
 * Copyright (c) 2023 Li Xilin <lixilin@gmx.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#include "util.h"
#include <ax/u1024.h>
#include "gram.h"
#include <ax/edit.h>
#include <ax/iobuf.h>
#include <ax/flow.h>
#include <ax/mem.h>
#include <ax/log.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yyparse();
int yywrap();
int yyrestart(FILE *f);

static const char usage[] =
	"KCALC - Calculator for 1024-bit large integer "
	"\n"
	"\nTokens: "
	"\n    PRINT D E F G H I J K"
	"\nOperators:"
	"\n    ~, ^, *, /, %, +, -, <<, >>, and, xor, or"
	"\nLiteral value:"
	"\n    1. Hexadecimal integer prefix with 0x. (eg. 0x2Aef)"
	"\n    2. Decimal integer. (eg. 042)"
	"\nFunctions:"
	"\n    1. pow(x, p): x to the power of p."
	"\n    2. sqrt(x): square root of x."
	"\nPrint result:"
	"\n    1. 'x' for hexadecimal value output, default behavior."
	"\n    2. 'd'  for decimal value output."
	"\nGrammar:"
	"\n    EVAL -> x EXP | d EXP | EXP"
	"\n    EXP -> EXP or E | E"
	"\n    E -> E xor F | F"
	"\n    F -> F and G | G"
	"\n    G -> G << H | G >> H | H"
	"\n    H -> H + I | H - I | I"
	"\n    I -> I * J | I / J | I % J | J"
	"\n    J -> K ^ J | K"
	"\n    K -> (D) | pow(D,D) | sqrt(D) | <literal value> | ~ K"
	"\n"
	"\nCopyright (c) Li Xilin <lixilin@gmx.com>"
	"\n";

ax_iobuf sg_expbuf;
extern int result_base;
extern ax_u1024 result_value;

int lex_input(char *buf, size_t size)
{
	return ax_iobuf_read(&sg_expbuf, buf, size);
}

void yyerror(const char *err)
{
	ax_perror(err);
}

int main()
{
	ax_log_set_mode(AX_LM_NOLOC|AX_LM_NOTIME);
	for (int i = 0; ; i++) {
		char *line = ax_edit_readline("kc -> ");
		if (!line)
			break;

		size_t len;
		char *exp = ax_strtrim(line, &len);
		if (exp[0] == '\0')
			goto cont;
		if (strcmp(exp, "q") == 0)
			break;

		if (strcmp(exp, "quit") == 0)
			break;

		ax_edit_history_add(exp);

		if (strcmp(exp, "help") == 0) {
			fputs(usage, stdout);
			goto cont;
		}

		ax_iobuf_init(&sg_expbuf, exp, len + 1);
		sg_expbuf.rear = len;
		if (yyparse())
			goto cont;
		fprintf(stdout, "(%d) ", result_base);
		print_u1024(&result_value, stdout, result_base);
cont:
		free(line);
		yyrestart(stdin);
	}
	return 0;
}

