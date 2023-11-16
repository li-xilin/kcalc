/* A Bison parser, made by GNU Bison 3.7.5.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_GRAM_H_INCLUDED
# define YY_YY_GRAM_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    NUMBER = 258,                  /* NUMBER  */
    WORD = 259,                    /* WORD  */
    ERROR = 260,                   /* ERROR  */
    HEX = 261,                     /* HEX  */
    DEC = 262,                     /* DEC  */
    PLUS = 263,                    /* PLUS  */
    MINUS = 264,                   /* MINUS  */
    ASTERISK = 265,                /* ASTERISK  */
    SLASH = 266,                   /* SLASH  */
    CARET = 267,                   /* CARET  */
    LB = 268,                      /* LB  */
    RB = 269,                      /* RB  */
    COMMA = 270,                   /* COMMA  */
    PERCENT = 271,                 /* PERCENT  */
    LSHIFT = 272,                  /* LSHIFT  */
    RSHIFT = 273,                  /* RSHIFT  */
    AND = 274,                     /* AND  */
    XOR = 275,                     /* XOR  */
    OR = 276,                      /* OR  */
    TILDE = 277,                   /* TILDE  */
    POW = 278,                     /* POW  */
    SQRT = 279,                    /* SQRT  */
    ADD = 280,                     /* ADD  */
    SUB = 281,                     /* SUB  */
    UMINUS = 282                   /* UMINUS  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif
/* Token kinds.  */
#define YYEMPTY -2
#define YYEOF 0
#define YYerror 256
#define YYUNDEF 257
#define NUMBER 258
#define WORD 259
#define ERROR 260
#define HEX 261
#define DEC 262
#define PLUS 263
#define MINUS 264
#define ASTERISK 265
#define SLASH 266
#define CARET 267
#define LB 268
#define RB 269
#define COMMA 270
#define PERCENT 271
#define LSHIFT 272
#define RSHIFT 273
#define AND 274
#define XOR 275
#define OR 276
#define TILDE 277
#define POW 278
#define SQRT 279
#define ADD 280
#define SUB 281
#define UMINUS 282

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 44 "gram.y"

	ax_u1024 number;
	char *string;
	char *err;

#line 127 "gram.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_GRAM_H_INCLUDED  */
