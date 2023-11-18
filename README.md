# KCALC - Calculator for 1024-bit large integer 

## Usage

```
Tokens: 
    PRINT EXP E F G H I J K
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
    K -> (EXP) | pow(EXP,EXP) | sqrt(EXP) | <literal value> | ~ K

Copyright (c) Li Xilin <lixilin@gmx.com>
```

## Example

```
$ ./kcalc
kc -> 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF + 1
(16) 10000000000000000000000000000000000000000000000
kc -> d 0xF
(10) 15
kc -> 42 / 0
[ERROR] The divisor cannot be zero.
kc -> (0xFF + 1) ^ 42
(16) 1000000000000000000000000000000000000000000000000000000000000000000000000000000000000
kc -> x sqrt(0x1000000000000000000000)
(16) 40000000000
kc -> 0 - 1
(16) ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
kc -> 2 + (3 * 4) ^ 2
(16) 92
kc -> 0x10 << 1
(16) 20
kc -> 0x1010 xor 0x0101
(16) 1111
kc -> q
```
