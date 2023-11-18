# KCALC - Calculator for 1024-bit large integer 

## Usage

```
Tokens: 
    PRINT D E F G H I J K
Operators:
    ~, ^, *, /, %, +, -, <<, >>, and, xor, or
Literal value:
    1. Hexadecimal integer prefix with 0x. (eg. 0x2Aef)
    2. Decimal integer. (eg. 042)
Functions:
    1. pow(x, p): x to the power of p.
    2. sqrt(x): square root of x.
Print result:
    1. 'x' for hexadecimal value output, default behavior.
    2. 'd'  for decimal value output.
Grammar:
    EVAL -> x EXP | d EXP | EXP
    EXP -> EXP or E | E
    E -> E xor F | F
    F -> F and G | G
    G -> G << H | G >> H | H
    H -> H + I | H - I | I
    I -> I * J | I / J | I % J | J
    J -> K ^ J | K
    K -> (D) | pow(D,D) | sqrt(D) | <literal value> | ~ K

Copyright (c) Li Xilin <lixilin@gmx.com>
```

## Example

```
$ ./kcalc
kc -> d 0xffee
65518
kc -> x 0xffee
0xffee
kc -> d 52^8
53459728531456
kc -> d 52^62
[ERROR] Result value too big
kc -> d pow(100,2)
10000
kc -> pow(0x100, 2)
0x10000
kc -> d sqrt(81)
9
kc -> 0x0101 and 0x1010
0x0
kc -> 0x0101 or 0x1010
0x1111
kc -> 0xff << 3
0x7f8
kc -> q
```
