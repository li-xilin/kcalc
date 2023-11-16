# 1024-bits Integer Calculator

## Support

The calculator support many basic math opeations, include:
```
+, -, *, /, %, <<, >>, and, or, ~, pow(), sqrt(), Decimal output, Dexadecimal output
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
