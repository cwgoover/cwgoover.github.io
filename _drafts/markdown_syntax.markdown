---
layout:     post
title:      "How to write Beautiful Markdown"
date:       2016-07-12
author:     "Vivi CAO"
header-img: "img/post-bg-miui6.jpg"
tags:
    - Markdown
    - Syntax
---

## 如何跳转

[跳过废话，直接看技术实现 ](#build)


> **如何将两个图片并列显示**

> **如何链接标号**

> **如何缩小列举行的下面间距**

> **设置字体样式，颜色？？**


作为一个程序员， Blog 这种轮子要是挂在大众博客程序上就太没意思了。一是觉得大部分 Blog 服务都太丑，二是觉得不能随便定制不好玩。之前因为太懒没有折腾，结果就一直连个写 Blog 的地儿都没有。

<br>
It will be jump here!
<p id = "build"></p>

`---可以用来分割页面`
---

## 分类

分类可以用“*”，也可以用“-”

## 空行

可以使用“<br>”作为空行操作

# Automatic and Manual Escaping
如果想在输出文中显示以下特殊字符需要转义该字符，使用backslash escapes，即‘\’符号。
  Following is a list of all the characters (character sequences) that can be escaped:

|\         |backslash
|.         |period
|*         |asterisk
|_         |underscore
|+         |plus
|-         |minus
|=         |equal sign
|`         |back tick
|()[]{}<>  |left and right parens/brackets/braces/angle brackets
|#         |hash
|!         |bang
|<<        |left guillemet
|>>        |right guillemet
|:         |colon
|\|         |pipe
|"         |double quote
|'         |single quote
|$         |dollar sign

# Blockquotes（引用）
>以空行分割段落（block-level elements）,如果段落开头使用>符号指定引用（Blockquotes），那么整个段落都会被引用。
The contents of a blockquote are block-level elements. This means that if you are just using text as content that it will be wrapped in a paragraph.

>>也可以引用嵌套，使用> > 表示
Since the contents of a blockquote are block-level elements, you can nest blockquotes and use other block-level elements (this is also the reason why blockquotes need to support line wrapping):

> 因为‘>’后面跟着的空格在缩进（indentation ）时不被计数，所以如果code blocks需要5个空格表示缩进或者1个空格加1个tab表示，像下面这样：
> A code block:
>
>     ruby -e 'puts :works'

# Code Blocks
**Code blocks can be used to represent verbatim text like markup, HTML or a program fragment because no syntax is parsed within a code block.**

    Here comes some code

    This text belongs to the same code block.




    Here comes some code
^
    This one is separate.


  ~~~~~~~~~~~~
  ~~~~~~~
  code with tildes
  ~~~~~~~~
  ~~~~~~~~~~~~~~~~~~




### [Watch Slides → ](http://yanshuo.io/assets/player/?deck=5753088f79bc440063aa84f0#/)

## 如何定义插入图片的大小：
<img src="http://huangxuan.me/pwa-in-my-pov/attach/qrcode.png" width="350" />

### Catalog

- WHAT is Progressive Web App?
- 1 - Installability
- 2 - App Shell
- 3 - Offline
    - SERVICE WORKER!
- 4 - Re-engageable
    - Push Notification
- CONS in my pov
- PROS in my pov
- Why Web?
