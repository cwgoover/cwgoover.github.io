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

  ↓↓↓↓

  ↑↑↑↑



Hux 的 Blog 就这么开通了。

[跳过废话，直接看技术实现 ](#build)


* **Android **
	* 思考 —— 从
	* 载体 —— 纸
	* 世界 —— 界

* **iOS **
	- 思考 —— 朋克
	- 载体 —— 远
	- 世界 —— 宙


<p id = "build"></p>
---


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




<iframe src="http://huangxuan.me/forcify/" style="
    width:100%;
    height:500px;
    border: 0;
"></iframe>


{% raw %}

```hbs
{{myVar}}        //单向数据绑定
ngModel="myVar"  //双向数据绑定
```

{% endraw %}


XNU, the acronym(首字母缩写) for ***X is Not Unix***, which is the **Computer OS Kernel** developed at Apple Inc since Dec 1996 for use in the Mac OS X and released as free open source software as part of Darwin.


### [Watch Slides → ](http://yanshuo.io/assets/player/?deck=5753088f79bc440063aa84f0#/)

## 如何定义插入图片的大小：
<img src="http://huangxuan.me/pwa-in-my-pov/attach/qrcode.png" width="350" />

<img src="http://www.mobilexweb.com/wp-content/uploads/2015/09/back.png" alt="backbutton" width="320" />

<img src="http://www.mobilexweb.com/wp-content/uploads/2015/09/IMG_2017.png" alt="input file" width="320" />

<img src="http://huangxuan.me/js-module-7day/attach/qrcode.png" width="350" height="350"/>

<small class="img-hint">你也可以通过扫描二维码在手机上观看</small>

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


### References

1.<a id="ref1">[End-to-end - Wikipedia, the free encyclopedia](http://en.wikipedia.org/wiki/End-to-end)</a>

2.<a id="ref2">[end-to-end - definition of end-to-end by The Free Dictionary](http://www.thefreedictionary.com/end-to-end)</a>


### 著作权声明

本文译自 [iOS 9, Safari and the Web: 3D Touch, new Responsive Web Design, Native integration and HTML5 APIs --- Breaking the Mobile Web](http://www.mobilexweb.com/blog/ios9-safari-for-web-developers)   
译者 [黄玄](http://weibo.com/huxpro)，首次发布于 [Hux Blog](http://huangxuan.me)，转载请保留以上链接



---

*本篇完。*

> 本文作者系前「阿里旅行 · 去啊」前端实习生，本文系业余时间学习之作。
> 如有任何知识产权、版权问题或理论错误，还请指正。
> 转载请注明原作者及以上信息。
