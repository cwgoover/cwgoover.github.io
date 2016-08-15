---
layout:     post
title:      "How to analysis Android Performance"
subtitle:   "Android Performance Topic"
date:       2016-06-23
author:     "Vivi CAO"
header-img: "img/post-bg-analysis-perf.jpg"
tags:
    - Android Performance
---

> 本文系本作者原创，如有任何知识产权、版权问题或理论错误，还请指正。
> 转载请注明原作者及出处，谢谢配合。
<br>


## 如何分析Android performance问题?

<br>

#### 检查CPU问题 --- “手机是否发热”

* 看是否因为高温而降频
  CPU信息：

  一般情况“2-7” 6核， CPU0, CPU1一般不开, CPU2-CPU3（大核），CPU4，CPU5，CPU6，CPU7。

  查看CPU频率的方法如下：
```
  cat /sys/devices/system/cpu/cpux/cpufreq/scaling_cur_freq
```

**注意：任何性能问题都要跟正常情况下对比**

<br>

#### Check TOP information

* 看TOP信息，查看当前后台是否是干净的。{idle/操作用户行为}是否是异常

  **"system 1%`(1)`, IOW 8%`(2)`"   (System包含user)**

  - `(1)` 如果该值高就看底下的进程，CPU占比。如果发现哪个进程占比比较高，再看这个进程的哪个线程占比高

```
    $ adb shell top -d 1 -m 10 -t

      * "-d 1": 每一秒刷一次
      * "-m 10": 输出前10个
      * "-t": 输出线程
```

  - 如果这中间想看某个进程的call stack，使用下面命令输出对应进程的call stack信息，然后查看traces.txt文件搜索"Tid=[线程号]"，查看该线程的具体调用

```
    $ adb shell touch /data/anr/traces.txt
    $ adb shell kill -3 [PID](进程号)
```

  - `(2)` 【难点】如果出现IOW高需要采用排除法，把有疑点的进程关掉后重新查看IOW的占比是否降低。如果排除这种可能后只能说明是系统问题。

<br>

#### Systrace

使用Systrace命令抓取现场状态，然后跟正常状态下的Systrace进行对比分析：

* 如果是应用启动慢，查看每个启动阶段使用情况，找出最费时间的地方
    - 起始点： Systrace中的关键字 `"delieverInputEvent"`, *keyword: input, Event, touch*
  - 终止点： Systrace中的关键字 `"winAnimationDone"`
  - 关键点： 应用进程的 `"activityResume"`
<br>

* 如果是滑动问题，先找到对应时间区域：
    - 起始点： `"delieverInputEvent"`
    - 结束点： 事件结束点
<br>

    - 查看这段时间内VSync的间隔是否均匀。如果有宽的，是否超过`16.7ms`
    - 查看“SurfaceFlinger”，如果均匀说明可能系统本身没有问题，也许是应用自身draw的时候太费时，然后对比参考机进行验证。如果发现是参考机无此问题，对手机进行升频操作，看是否是CPU的瓶颈。
    - 如果“SurfaceFlinger”时就出现问题，跟芯片厂商沟通。

<br>

#### logcat

抓取现场的log，结合Systrace查看这段时间是否有异常出现。有没有可疑的现象或者进程，具体问题具体分析。

<br>

#### bugreport

通过android提供的["battery-historian"](https://github.com/cwgoover/battery-historian) 工具分析现场找出可疑点。该工具可以将bugreport的数据导入到浏览器中生成可视化界面（如下），也可以提供用户行为。

**Timeline:**

<img src="/img/in-post/post-perfermance-timeline.png" width="1000"/>

**System stats:**

<img src="/img/in-post/post-perfermance-system.png" width="1000" />
