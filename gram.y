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
#include "util.h"
#include <ax/u1024.h>
#include <ax/mem.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
void yyerror(const char *msg);
int yylex();
static void u1024_log2(const ax_u1024 *a, ax_u1024 *b, bool floor);
int result_base;
ax_u1024 result_value;

%} 

%token <number> NUMBER
%token <string> WORD
%token <bad_char> BADCHAR
%token <string> BADSYMBOL
%token <error> ERROR
%token PRINTHEX PRINTDEC PRINTUDEC PRINTBIN
%token PLUS MINUS ASTERISK SLASH CARET LB RB COMMA PERCENT
%token LSHIFT RSHIFT AND XOR OR TILDE
%token SQRT LOG2
%type <number> D E F G H I J K L FATAL
%type <result> ROOT PRINT
%left PLUS MINUS TILDE
%left UMINUS

%union {
	ax_u1024 number;
	char *string;
	char bad_char;
	const char *error;
	struct {
		ax_u1024 value;
		int base;
	} result;
}

%%
ROOT	: PRINT {
     		result_base = $1.base;
		result_value = $1.value;
     	}
     	;

PRINT	: PRINTHEX D {
      		$$.value = $2;
		$$.base = 16;
	}
	| PRINTDEC D {
      		$$.value = $2;
		$$.base = -10;
	}
	| PRINTUDEC D {
      		$$.value = $2;
		$$.base = 10;
	}
	| PRINTBIN D {
      		$$.value = $2;
		$$.base = 2;
	}
	| D {
      		$$.value = $1;
		$$.base = 16;
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
			yyerror("Too many bits for shift.");
			YYERROR;
		}
  		ax_u1024_lshift(&$1, &$$, nbits);
	}
  	| G RSHIFT H {
  		uint64_t nbits;
  		if (ax_u1024_to_int(&$3, &nbits)) {
			yyerror("Too many bits for shift.");
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
			yyerror("The divisor cannot be zero.");
			YYERROR;
		}
  		ax_u1024_div(&$1, &$3, &$$);
	}
	| I PERCENT J {
		if(ax_u1024_is_zero(&$3)) {
			yyerror("The modulus cannot be zero.");
			YYERROR;
		}
  		ax_u1024_mod(&$1, &$3, &$$);
	}
	| J { $$ = $1; }
	;

J	: K CARET J { ax_u1024_pow(&$1, &$3, &$$); }
	| K { $$ = $1; }
	;
K	: LB D RB { $$ = $2; }
	| NUMBER { $$ = $1; }
	| L { $$ = $1; }
	| FATAL { 
		YYERROR;
	}
	;

L	: TILDE K { ax_u1024_not(&$2, &$$); } %prec UMINUS
	| PLUS K { $$ = $2; } %prec UMINUS
	| MINUS K {
		if ($2.array[AX_U1024_ARR_LEN - 1] >> 31) {
			ax_u1024_not(&$2, &$$);
			ax_u1024_inc(&$$);
		}
		else {
			ax_u1024_dec(&$2);
			ax_u1024_not(&$2, &$$);
		}
	} %prec UMINUS
	| SQRT K { ax_u1024_isqrt(&$2, &$$); } %prec UMINUS
	| LOG2 K { u1024_log2(&$2, &$$, false); } %prec UMINUS
	;

FATAL	: BADCHAR {
		char err_buf[64];
		sprintf(err_buf, "Invalid charactor '%c'.", $1);
		yyerror(err_buf);
	}
	| BADSYMBOL {
		char err_buf[64];
		sprintf(err_buf, "Invalid symbol '%s'.", $1);
		yyerror(err_buf);
		free($1);
	}
	| ERROR {
		yyerror($1);
	}
	;
	
%%

int yywrap()
{
	return 1;
}

static void u1024_log2(const ax_u1024 *a, ax_u1024 *b, bool floor)
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

