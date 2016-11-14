---
layout:     post
title:      "Android adb调试命令集合"
subtitle:   "Android adb command debug usages"
date:       2016-10-09
author:     "Vivi CAO"
header-img: "img/post-bg-jekyll-github.jpg"
header-mask: 0.3
catalog:    true
tags:
    - Android
    - adb
    - debug
---

## 一些实用的命令
---

#### 发送广播关闭USB

```shell
$ adb shell am broadcast -a android.hardware.usb.action.USB_STATE --ez connected "false"
```

#### 关闭gyroscope(陀螺仪)

> 硬件相关，可能有变动

```shell
$ adb shell echo 0 > /sys/class/sensors/bmg160/enable
```

#### 无线adb连接手机

> How to connect devices via Wireless ADB

Connect the device to the computer with a USB cable → The computer recognize the device

```shell
$ adb devices
```

Make sure device's Wifi is ON, and set device's tcpip port → To change the adb port

```shell
$ adb tcpip 12443
```

Write down the device IP (Connect to wifi):<br>
&nbsp;&nbsp;&nbsp;Go to settings → about phone → Status → IP address<br>
Example: 192.168.8.81

```shell
$ adb connect 192.168.8.81:12443
```

Disconnect the cable

```shell
$ adb disconnect 192.168.8.81:12443
```


#### 查看系统时间

```shell
$ adb shell date
```

#### 开机跳过setupWizard正常使用

**a. disable SetupWizard:**

```shell
$ adb shell pm list packages | grep setup
$ adb shell pm disable
```
→ Example: com.google.android.setupwizard<br>
**b. build Provision and push into handset:**

```shell
~$ mmm packages/apps/Provision/
~$ adb push out/target/product/flash3/system/app/Provision/Provision.apk /system/app/Provision/
```

**c. reboot**

```shell
$ adb reboot
```

> Provision就是无界面版的SetupWizard，快速设置并初始化手机，是SetupWizard的替代版。

可断开USB还执行adb命令

* 例如通过如下命令记录event log到sdcard

```shell
$ adb shell "getevent -ltr > sdcard/getevent.log&"  (linux common function)
```

> 在执行此命令之后可拔掉USB进行测试

#### 查看Notification：“找出状态栏广告的主人”

```shell
adb shell dumpsys statusbar
```

## debug相关的命令
---


#### 过滤log篇

* **只查看某个TAG的某个priority的log：**

```shell
$ adb logcat ActivityManager:I MyApp:D *:S
```

  **_`*:S`_**: sets the priority level for all tags to "silent", thus ensuring only log messages with "ActivityManager" and "MyApp" are displayed.

* **只显示Error级别的log：**

```shell
$ adb logcat *:E
```

* **直接看Exception的命令：**

```shell
$ adb logcat -s */E
```

* **logcat时可以查看某个tag的所有log:**

```shell
$ adb logcat -v threadtime -s [TAG]
```

* **打开某个class的log：**

```shell
$ adb shell setprop log.tag.MyAppTag VERBOSE
```

```
or:
  Creating a local.prop file as described in the original question:
  log.tag.MY_TAG=VERBOSE

  And then pushing it onto the device as follows seems to do the trick:
  adb push local.prop /data/local.prop
  adb shell chmod 644 /data/local.prop
  adb shell chown root.root /data/local.prop
  adb reboot

You can double check to make sure that the values in local.prop were read by executing:
adb shell getprop | grep log.tag
```


* **抓取kernel log：**

```shell
$ adb shell cat /proc/kmsg > kernel.log
```

#### 强制让进程gc

```shell
$ adb shell kill -10 PIDXXX
```

#### 强制生成trace

> /data/anr/traces.txt

```shell
$ adb shell kill -3 PIDxxx
```

#### 强制生成进程的内存镜像

> 分析OOM

```shell
$ adb shell am dumpheap PIDxxx /data/xxx.hprof
```

#### 打印调用顺序

> 在java代码中加入，可知道该函数被谁调用

```shell
Debug.getCallers(4)
```

#### top命令

> 每隔1秒执行top命令显示10行数据，能够实时查看后台哪些进程或者线程在执 行，消耗cpu

```shell
$ adb shell top -d 1 -m 10 -t
```

#### 软重新：

```shell
$ adb shell stop; adb shell start
```

#### monkey test的命令：

```shell
$ adb shell monkey -v -p [package name] [times]
$ adb shell monkey -v -p com.jrdcom.lockscreen 1000000
```

#### 查看cpu频率：

```shell
$ adb shell cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
$ adb shell cat /sys/devices/system/cpu/cpu1/cpufreq/scaling_cur_freq
$ adb shell cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_cur_freq
$ adb shell cat /sys/devices/system/cpu/cpu3/cpufreq/scaling_cur_freq
```

#### 打开CPU loading log：

> 分析ANR（MTK）

```shell
$ adb shell setprop events.cpu true
```

在events log中实时打印cpu信息。

```shell
$ adb logcat -b events | grep cpu
   I/cpu     (  743): [16,4,12,0,0,0]
   I/cpu     (  743): [15,2,13,0,0,0]
   I/cpu     (  743): [16,2,14,0,0,0]

   数字都是百分比，分别为：[total, user, system, iouat, irq, softlrq]``
```

#### 终端输入play pause事件模拟按键：

```shell
$ adb shell media
  usage: media [subcommand] [options]
  media dispatch KEY
  media remote-display

    media dispatch:    dispatch a media key to the current media client.
    KEY may be:        play, pause, play-pause, mute, headsethook, stop, next, previous, rewind, recordm fast-forword.
    media remote-display: 	 monitor remote display updates.
```


## 系列核心命令
---

#### 模拟输入事件：

```shell
$ adb shell input text <string>   input a string to device
$ adb shell input keyevent <event_code>   send a Key Event to device

如: adb shell input keyevent 26      (PowerKey)
```

#### 模拟启动activity:

```shell
$ adb shell am start  <INTENT> : start an Activity

如：am start -n com.android.calculator/com.android.calculator2.Calculator

$ adb shell am broadcast <INTENT>
```

#### 得到/设置settings数据库键值

> **usage:**  settings [--user NUM] get namespace key
>
> &nbsp;&nbsp;&nbsp;&nbsp;settings [--user NUM] put namespace key value
>
> &nbsp;&nbsp;&nbsp;&nbsp;settings [--user NUM] delete namespace key
>
> &nbsp;
>
>'namespace' is one of {system, secure, global}, case-insensitive
>
>If '--user NUM' is not given, the operations are performed on the owner user.

```
$ adb shell settings get/set Global airplane_mode_on
```

  * **修改数据库的键值：**

```shell
$ adb shell settings put system/global [key] [value]
$ adb shell settings put system navigation_bar_key_mode 1
```

* **得到数据库的键值：**

```shell
$ adb shell settings get system/global [key]
```

#### 查看Service信息

* **查看Service列表：**

```shell
$ adb shell service list
     Found 1 services:
0 phone: [com.android.internal.telephony.ITelephony]
```

* **检查Service是否存在：**

```shell
$ adb shell service check phone
Service phone: found
```

* **使用Service：**

```shell
$ adb shell service call phone 2 s16 "10086"
```

#### 手机屏幕相关设置-wm命令

> $ adb shell wm
>
> usage: wm [subcommand] [options]
>
> &nbsp;&nbsp;&nbsp;&nbsp;wm size [reset \| WxH]
>
> &nbsp;&nbsp;&nbsp;&nbsp;wm density [reset \| DENSITY]
>   
> &nbsp;&nbsp;&nbsp;&nbsp;wm overscan [reset \|  LEFT,TOP,RIGHT,BOTTOM]

* **wm overscan [reset\|LEFT,TOP,RIGHT,BOTTOM]**<br>
wm overscan: set overscan area for display.<br>
重新设置屏幕大小、尺寸:<br>
<br>
让界面显示在靠左200，靠上300，靠右400，靠下500的显示区域<br>
&nbsp;&nbsp;width = displaywidth - left - right<br>
&nbsp;&nbsp;height = displayheight - top - bottom

```shell
$ adb shell wm overscan 200,300,400,500
                     left,top,right,bottom
```

* **wm size: return or override display size.**<br>
查看屏幕分辨率

```shell
$ adb shell wm size
    Physical size: 720x1280
```

* **wm density: override display density.**<br>

```shell
$ adb shell wm density
    Physical density: 480
```

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;强制设置手机dpi为320

```shell
$ adb shell wm density 320

$ adb shell wm density reset
```

#### svc命令

**Turn on/off Wi-Fi**

```shell
$ svc wifi [enable|disable]
```

**Turn on/off mobile data**

```shell
$ svc data [enable|disable]
```

**手机重启**

```shell
$ svc power reboot [reason]
  Perform a runtime shutdown and reboot device with specified reason.
```

**手机关机**

```shell
$ svc power shutdown
  Perform a runtime shutdown and power off the device.
```

#### pm 命令大全

> pm命令用于分析手机中apk和包名

**查看当前安装的所有apk**

```shell
$ adb shell pm list packages
  package:com.android.defcontainer
  package:com.tencent.mm
```

**查看包名和文件名对应表**

```shell
$ adb shell pm list packages -f
  package:/system/priv-app/DefaultContainerService.apk=com.android.defcontainer
  package:/data/app/com.tencent.mm-1.apk=com.tencent.mm
  package:/system/app/JrdGallery.apk=com.jrdcom.gallery3d
```

**查看disable packagename**

```shell
$ adb shell pm list packages -d
```

**查看enable packagename**

```shell
$ adb shell pm list packages -e
```

**查看system app packagename**

```shell
$ adb shell pm list packages -s
```

**查看第三方app packagename**

```shell
$ adb shell pm list packages -3
```

**其他**

```shell
$ adb shell pm list features

# Enable/Disable package
$ adb shell pm enable [packagename]
$ adb shell pm disable [packagename]
```

#### am 命令大全

**强制dump某个进程的内存镜像**

```shell
# 1044是Launcher的pid
$ adb shell am dumpheap 1044 /data/aa.hprof
```

**Dalvik's sampling profiler 定时抓取java call stack**

```shell
$ adb shell am profile start [--user <USER_ID> current] [--sampling INTERVAL] <PROCESS> <FILE>
$ adb shell am profile stop [--user <USER_ID> current] [<PROCESS>]

  $ persist.sys.profiler_ms 		时间频率 默认0
  $ persist.sys.profiler_depth	 call stack depth 默认4

抓取的文件保存于/data/snapshots/<pid>-<time>.snapshot
```

**List all of the activity stacks and their sizes**

```shell
$ adb shell am stack list
```

**Display the information about activity stack <STACK_ID>**

```shell
$ adb shell am stack info <STACK_ID>
```


## dumpsys相关命令
---

* **查看activity的provider信息**

查看activity每个数据库的调用信息查询
打印所有provider信息 可以查看数据库某个时间点的增删改查的次数, 监测应用的IO操作:

```shell
$ adb shell dumpsys activity provider all

PROVIDER ContentProviderRecord{19861e6e u0 com.android.providers.media/.MediaProvider} pid=31295
    Client:
      internal.db: version 700, 68 rows, 0 inserts, 0 updates, 0 deletes, 120 queries,
      1970-02-07 10:49:01.893 : Database upgraded from version 63 to 700 in 0 seconds
												               插入62次，0次更新，0次删除，105次查询
      1970-02-07 10:49:03.852 : internal.db: version 700, 54 rows, 62 inserts, 0 updates, 0 deletes, 105 queries, scan started Feb 7, 10:49 AM (00:02)
      1970-02-07 10:54:06.555 : internal.db: version 700, 54 rows, 0 inserts, 0 updates, 0 deletes, 55 queries, scan started 2月7日 下午6:54 (00:00)
      2013-12-26 05:41:19.318 : internal.db: version 700, 54 rows, 0 inserts, 4 updates, 0 deletes, 58 queries, scan started Dec 26, 1:41 PM (00:00)
      2013-12-27 07:45:37.775 : internal.db: version 700, 59 rows, 0 inserts, 0 updates, 0 deletes, 55 queries, scan started Dec 27, 3:45 PM (00:00)
```

* **查看provider的Connections，谁在连接数据库**

```shell
$ dumpsys activity providers
```

* **查看手机disk状态**

```
$ adb shell dumpsys diskstats
    >> Latency: 5ms [512B Data Write]
    >> Data-Free: 362888K / 1161104K total = 31% free
    >> Cache-Free: 116756K / 120900K total = 96% free
    >> System-Free: 133036K / 806284K total = 16% free
```

* **Get the list of services available:**

```shell
$ adb shell service list
```

* **查看可用的SERVICE列表**

```shell
$ adb shell dumpsys | grep 'DUMP OF SERVICE' | awk '{print $4}' | tr -d ':'

ACTIVITY MANAGER PENDING INTENTS (adb shell dumpsys activity intents)
ACTIVITY MANAGER BROADCAST STATE (adb shell dumpsys activity broadcasts)
ACTIVITY MANAGER CONTENT PROVIDERS (adb shell dumpsys activity providers)
ACTIVITY MANAGER SERVICES (adb shell dumpsys activity services)
ACTIVITY MANAGER ACTIVITIES (adb shell dumpsys activity activities)
ACTIVITY MANAGER RUNNING PROCESSES (adb shell dumpsys activity processes)
INPUT MANAGER (adb shell dumpsys input)
WINDOW MANAGER LAST ANR (adb shell dumpsys window lastanr)
WINDOW MANAGER POLICY STATE (adb shell dumpsys window policy)
WINDOW MANAGER SESSIONS (adb shell dumpsys window sessions)
WINDOW MANAGER TOKENS (adb shell dumpsys window tokens)
WINDOW MANAGER WINDOWS (adb shell dumpsys window windows)
```

* **查看某个应用的内存使用信息**

> getting memory usage informations

```shell
$ adb shell dumpsys meminfo 'your apps package name'
$ adb shell dumpsys meminfo com.google.android.apps.maps
```

* **查看TaskStack**

```shell
$ adb shell dumpsys activity activities
```

* **查看Alarm列表**

```shell
$ adb shell dumpsys alarm
```

* **查看surface flinger:**

```shell
$ adb shell dumpsys SurfaceFlinger
```

* **dumpsys其他一些信息：**

```shell
adb shell dumpsys SurfaceFlinger | grep "Layer\|z="
adb shell dumpsys activity log a on
adb shell dumpsys window -d enable 26
adb shell dumpsys alarm log on
adb shell dumpsys alarm log off
adb shell dumpsys window policy
adb shell dumpsys activity log anr 2   可以打开anr的messagequeue
adb shell dumpsys activity a           查看activity详细信息，如显示大小，布局等等
adb shell dumpsys activity processes   进程信息 trimmemory
adb shell dumpsys activity recents
adb shell dumpsys activity broadcasts  可以查看前台和后台broadcast详细信息(发送时间，
                                       所有应用处理时间，监听广播的所有列表)
adb shell dumpsys activity intents
adb shell dumpsys activity oom
adb shell dumpsys input | grep Focus   查看焦点窗口
```
