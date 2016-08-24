---
layout:     post
title:      "使用Jekyll建立自己的Github pages"
subtitle:   "建立第一个静态博客之艰辛之旅"
date:       2016-05-12
author:     "Vivi CAO"
header-img: "img/post-bg-jekyll-github.jpg"
tags:
    - Jekyll
    - github
---

### 集成第三方服务

#### 多说评论

```
注意：duoshuo_shortname 不是你的多说登录 id
```

使用多说前需要先在 多说 创建一个站点。具体步骤如下：

* 登录后在首页选择 “我要安装”。
* 创建站点，填写站点相关信息。 **多说域名** 这一栏填写的即是你的 `duoshuo_shortname`，如图：

<img src="/img/in-post/post-jekyll-github/duoshuo-create-site.png" width="650" />

* 创建站点完成后在 `_config.yml` 中新增 `duoshuo_username: duoshuo_shortname` 字段，值设置成上一步中的值。
