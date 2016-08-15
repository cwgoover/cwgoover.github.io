---
layout:     post
title:      "Java零星知识点汇集"
subtitle:   "Java Brief Sum-up"
date:       2016-08-15
author:     "Vivi Cao"
header-img: "img/post-bg-android-sum-up.jpg"

tags:
    - Java
    - Grammar
---

## 1. 基本类型(Primitive type)中float和double的区别

> 原文摘自 stackoverflow: http://stackoverflow.com/a/2386882/4710864，内容如下:

**Huge difference.**

As the name implies, `a double has 2x the precision of float[1]`. **In general a double has 15 to 16 decimal digits of precision, while float only has 7.**

This precision loss could lead to truncation errors much easier to float up, e.g.

```java
    float a = 1.f / 81;
    float b = 0;
    for (int i = 0; i < 729; ++ i)
            b += a;
    printf("%.7g\n", b);   // prints 9.000023

// while

    double a = 1.0 / 81;
    double b = 0;
    for (int i = 0; i < 729; ++ i)
            b += a;
    printf("%.15g\n", b);   // prints 8.99999999999996
```

Also, the maximum value of float is only about 3e38, but double is about 1.7e308, _so using float can hit Infinity much easier than double for something simple e.g. computing 60!_.

Maybe the their test case contains these huge numbers which causes your program to fail.

Of course sometimes even double isn't accurate enough, hence we have long double`[1]` (the above example gives 9.000000000000000066 on Mac), but all these floating point types suffer from round-off errors, so if precision is very important (e.g. money processing) you should use int or a fraction class.

**BTW, don't use += to sum lots of floating point numbers as the errors accumulate quickly. If you're using Python, use "fsum". Otherwise, try to implement the [Kahan summation algorithm](http://en.wikipedia.org/wiki/Kahan_summation_algorithm).**

`[1]: The C and C++ standards do not specify the representation of float, double and long double. It is possible that all three implemented as IEEE double-precision. Nevertheless, for most architectures (gcc, MSVC; x86, x64, ARM) float is indeed a IEEE single-precision floating point number (binary32), and double is a IEEE double-precision floating point number (binary64).`

**还句话说，也就是double和float都是用来表示浮点类型的，但是double的精度远远高于float类型（2倍）。如果是叠加类型的运算，float很容易出错（round-off erros）**

注意上文黑体字部分，不要使用“+=”进行叠加运算，如果是Python使用`“fsum”`；如果是其他语言，按照`Kahan summation algorithm`实现算法。
