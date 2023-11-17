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

ax_iobuf sg_expbuf;
extern int result_base;
extern ax_u1024 result_value;

int yyparse();
int yywrap();
int yyrestart(FILE *f);
extern int yychar;
extern YYSTYPE yylval;
extern int yynerrs;

int lex_input(char *buf, size_t size)
{
	return ax_iobuf_read(&sg_expbuf, buf, size);
}

void yyerror(const char *err)
{
	ax_perror(err);
}

bool is_empty(const char *text)
{
	for (int i = 0; text[i]; i++)
		if (text[i] != '\t' && text[i] != ' ' && text[i] != '\n')
			return false;
	return true;
}

int main()
{
	ax_log_set_mode(AX_LM_NOLOC|AX_LM_NOTIME);
	for (int i = 0; ; i++) {
		char *line = ax_edit_readline("kc -> ");
		if (!line)
			break;

		size_t len = strlen(line);

		if (is_empty(line))
			goto cont;
		if (strcmp(line, "q") == 0)
			break;
		ax_edit_history_add(line);

		ax_iobuf_init(&sg_expbuf, line, len + 1);
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

