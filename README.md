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
Output format:
    1. x: format the result in hexadecimal notation(default if omitted).
    2. d: format the result in signed decimal notation.
    3. u: format the result in unsigned decimal notation.
    4. b: format the result in binary notation.
Grammar:
    EVAL -> x EXP | d EXP | u EXP | b EXP | EXP
    EXP -> EXP or E | E
    E -> E xor F | F
    F -> F and G | G
    G -> G << H | G >> H | H
    H -> H + I | H - I | I
    I -> I * J | I / J | I % J | J
    J -> K ^ J | K
    K -> (EXP) | pow(EXP,EXP) | sqrt(EXP) | <literal value>
       | ~ K | + K | - K

Copyright (c) Li Xilin <lixilin@gmx.com>
```

## Example

```
$ ./kcalc
kc -> -1
(16) ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
kc -> d -1
(-10) -1
kc -> u -1
(10) 179769313486231590772930519078902473361797697894230657273430081157732675805500963132708477322407536021120113879871393357658789768814416622492847430639474124377767893424865485276302219601246094119453082952085005768838150682342462881473913110540827237163350510684586298239947245938479716304835356329624224137215
kc -> x -1
(16) ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
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
