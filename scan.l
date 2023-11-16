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

%{
#include "scan.h"
#include <ax/u1024.h>
#include "gram.h"
#include <stdio.h>
#include <limits.h>
#include "gram.h"
%}

space  [ \t\n\r]
decint [0-9]+
hexint 0x[0-9a-fA-F]+
symbol [_A-Za-z][a-zA-Z0-9]*
other  .

%%

","    return COMMA;
"+"    return PLUS;
"-"    return MINUS;
"*"    return ASTERISK;
"/"    return SLASH;
"^"    return CARET;
"%"    return PERCENT;
"("    return LB;
")"    return RB;
"<<"   return LSHIFT;
">>"   return RSHIFT;
"~"    return TILDE;

{space} {
}
{symbol} {
	if (strcmp(yytext, "and") == 0)
		return AND;
	if (strcmp(yytext, "or") == 0)
		return OR;
	if (strcmp(yytext, "xor") == 0)
		return XOR;
	if (strcmp(yytext, "pow") == 0)
		return POW;
	if (strcmp(yytext, "sqrt") == 0)
		return SQRT;
	if (strcmp(yytext, "x") == 0)
		return HEX;
	if (strcmp(yytext, "d") == 0)
		return DEC;
	yylval.err = "Unknown keyword";
	return ERROR;
}

{decint} {
	char *end;
	uint64_t u64 = strtoll(yytext, &end, 10);
	if (u64 == LLONG_MAX) {
		yylval.err = "Dec number too long.";
		return ERROR;
	}
	ax_u1024_from_int(&yylval.number, u64);
	return NUMBER;
}

{hexint} {
	char *end;
	ax_u1024_from_string(&yylval.number, yytext + 2, strlen(yytext) - 2);
	return NUMBER;
}

{other} {
	yylval.err = "Unexpected charactor.";
	return ERROR;
}

%%

