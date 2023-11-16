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
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <ax/u1024.h>
void yyerror(const char *msg);
int yylex();
%} 

%token <number> NUMBER
%token <string> WORD
%token <err> ERROR
%token HEX DEC
%token PLUS MINUS ASTERISK SLASH CARET LB RB COMMA PERCENT
%token LSHIFT RSHIFT AND XOR OR TILDE
%token POW SQRT
%type <number> ROOT D E F G H I J K
%left ADD SUB TILDE
%left UMINUS

%union {
	ax_u1024 number;
	char *string;
	char *err;
}

%%
ROOT	: HEX D {
		char buf[2048] = "0x";
		ax_u1024_to_string(&$2, buf+2, sizeof buf - 2);
		if (buf[2] == '\0')
			strcat(buf, "0");
		puts(buf);
	}
	| DEC D {
		uint64_t num;
		if (ax_u1024_to_int(&$2, &num)) {
			yyerror("Result value too big");
			YYERROR;
		}
		printf("%llu\n", num);
	}
	| D {
		char buf[2048] = "0x";
		ax_u1024_to_string(&$1, buf+2, sizeof buf - 2);
		if (buf[2] == '\0')
			strcat(buf, "0");
		puts(buf);
	}

	;

D	: D OR E { ax_u1024_or(&$1, &$3, &$$); }
	| E { $$ = $1; }
  	;

E	: E XOR F { ax_u1024_xor(&$1, &$3, &$$); }
	| F { $$ = $1; }
  	;

F	: F AND G { ax_u1024_and(&$1, &$3, &$$); }
	| G { $$ = $1; }
  	;

G	: G LSHIFT H {
  		uint64_t nbits;
  		if (ax_u1024_to_int(&$3, &nbits)) {
			yyerror("Too many bits for shift");
			YYERROR;
		}
  		ax_u1024_lshift(&$1, &$$, nbits);
	}
  	| G RSHIFT H {
  		uint64_t nbits;
  		if (ax_u1024_to_int(&$3, &nbits)) {
			yyerror("Too many bits for shift");
			YYERROR;
		}
  		ax_u1024_rshift(&$1, &$$, nbits);
	}
	| H { $$ = $1; }
  	;

H	: H PLUS I { ax_u1024_add(&$1, &$3, &$$); }
	| H MINUS I { ax_u1024_sub(&$1, &$3, &$$); }
	| I { $$ = $1; }
	;

I	: I ASTERISK J {
  		ax_u1024_mul(&$1, &$3, &$$);
	}
	| I SLASH J {
		if(ax_u1024_is_zero(&$3)) {
			yyerror("The divisor cannot be zero");
			YYERROR;
		}
  		ax_u1024_div(&$1, &$3, &$$);
	}
	| I PERCENT J {
		if(ax_u1024_is_zero(&$3)) {
			yyerror("The modulus cannot be zero");
			YYERROR;
		}
  		ax_u1024_mod(&$1, &$3, &$$);
	}
	| J { $$ = $1; }
	;

J	: K CARET J { ax_u1024_pow(&$1, &$3, &$$); }
	| K {$$ = $1;}
	;
K	: LB D RB { $$ = $2; }
	| POW LB D COMMA D RB { ax_u1024_pow(&$3, &$5, &$$); }
	| SQRT LB D RB { ax_u1024_isqrt(&$3, &$$); }
	| NUMBER {$$ = $1;}
	| TILDE K { ax_u1024_not(&$2, &$$); } %prec UMINUS
	| ERROR {
		yyerror($1);
		YYERROR;
	}
	;
	
%%

int yywrap()
{
	return 1;
}

