---
layout:     post
title:      "How to analysis Alarm dumpsys & log"
subtitle:   "Android AlarmManager Actual Analysis"
date:       2016-07-22
author:     "Vivi CAO"
header-img: "img/post-bg-alarm-usage.jpg"
tags:
    - Android
    - Alarm
---

# 序言

这一篇基于前一篇["Android AlarmManager Workflow"](https://cwgoover.github.io/2016/07/12/android-alarmManager-analyse/)的基础上继续深入解释如何分析AlarmManagerService的问题，主要从android log，dumpsys info和一些知识点的记录着手，力求全面分析该类的知识点。

# android log

AlarmManager有一个DEBUG级别的log如下：[TODO]

> xxxx

通过它的分析可以知道这段时间有多少个alarm被唤醒。

# dumpsys info

这样，我来从上到下慢慢介绍dumpsys出来的info都是什么意思，这样到老了以后也好有个交代。

```
Current Alarm Manager state:
  # These come from "Settings.Global.ALARM_MANAGER_CONSTANTS"
  Settings:
    min_futurity=+5s0ms
    min_interval=+60s0ms
    allow_while_idle_short_time=+5s0ms
    allow_while_idle_long_time=+9m0s0ms
    allow_while_idle_whitelist_duration=+10s0ms

  nowRTC=1469155447484=2016-07-22 04:44:07 nowELAPSED=+48d0h56m33s625ms
# Last time of the changed alarm clock
  mLastTimeChangeClockTime=1467771006014=2016-07-06 04:10:06
# It's real time of alarm clock from boot time
  mLastTimeChangeRealtime=+32d0h22m32s298ms

# ------ only show in the screen off time --------
# screen off time
  Time since non-interactive: +18s334ms
# "code: currentNonWakeupFuzzLocked(nowELAPSED)": non-wakeyp alarm delay time, 2m/5m/half hour
  Max wakeup delay: +2m0s0ms
  Time since last dispatch: +21s495ms
# "code: nowELAPSED - mNextNonWakeupDeliveryTime"
  Next non-wakeup delivery time: -2m52s515ms
# ------------------------------------------------

  Next non-wakeup alarm: +2m52s515ms = 2016-07-22 04:46:59
  Next wakeup: +11s641ms = 2016-07-22 04:44:19
# "code: mNumTimeChanged": The number of the TIME_CHAGNED event
  Num time change events: 3

# If no alarmclock, there is nothing here
  Next alarm clock information:
    user:0 pendingSend:false time:1396740000 = 1970-01-17 11:59:00 = +1m10s299ms

  Pending alarm batches: 33

#### code: Batch.toString() ####
# flgs=Flags for alarms, such as FLAG_STANDALONE, if any.
Batch{f84af5c num=1 start=4150605266 end=4150605266 flgs=0x5}:
## [code: dumpAlarmList(Batch.alarms)] {revert order: Time decreasing} ##
    ELAPSED_WAKEUP #0: Alarm{614e265 type 2 when 4150605266 com.google.android.gms}
      tag=*walarm*:com.google.android.intent.action.SEND_IDLE
      type=2 whenElapsed=+11s641ms when=+11s641ms
      window=0 repeatInterval=0 count=0 flags=0x5
      operation=PendingIntent{2fd5b3a: PendingIntentRecord{eda5dcf com.google.android.gms broadcastIntent}}

# There are nine alarms in one batch.
Batch{9501792 num=9 start=4151598626 end=4152119061 flgs=0x8}:
#            Alarm{ type 2/4(wakeup alarm) when(RTC mode)  operation.getTargetPackage() }
    RTC_WAKEUP #8: Alarm{a90bd90 type 0 when 1469156452485 com.google.android.gms}
      tag=*walarm*:com.google.android.gms/.checkin.EventLogService$Receiver
      type=0 whenElapsed=+16m45s1ms when=2016-07-22 05:00:52
#     window = windowLength, MTK platform: if batching, -1 or "user set?", otherwise 0
      window=+22m30s0ms repeatInterval=1800000 count=0 flags=0x0
      operation=PendingIntent{a2f1ace: PendingIntentRecord{59d08d4 com.google.android.gms broadcastIntent}}
    RTC_WAKEUP #7: Alarm{6c2c689 type 0 when 1469156449396 com.google.android.gms}
      tag=*walarm*:com.google.android.gms/.checkin.EventLogServiceReceiver
      type=0 whenElapsed=+16m41s912ms when=2016-07-22 05:00:49
      window=+22m30s0ms repeatInterval=1800000 count=0 flags=0x0
      operation=PendingIntent{62768e: PendingIntentRecord{3cfdb00 com.google.android.gms broadcastIntent}}
    ... ...


      # [code: mPendingNonWakeupAlarms]
        Past-due non-wakeup alarms: 1
          ELAPSED #0: Alarm{432f5bb type 3 when 4150586140 android}
            tag=*alarm*:android.intent.action.TIME_TICK
            type=3 whenElapsed=-7s485ms when=-7s485ms
            window=0 repeatInterval=0 count=1 flags=0x1
            operation=PendingIntent{3b0e7c3: PendingIntentRecord{d89b25b android broadcastIntent}}
      # All the delayed alarms
          Number of delayed alarms: 6200, total delay time: +3d7h57m5s214ms
      # max non-interactive time: [code: (screen off time) nowELAPSED - mNonInteractiveStartTime]
          Max delay time: +20m49s8ms, max non-interactive time: +6d19h23m36s425ms  

      # The current sending Broadcast count, if there are sending operation, it may not equal as 0
        Broadcast ref count: 0

        mAllowWhileIdleMinTime=+5s0ms
        Last allow while idle dispatch times:
        UID u0a86: -11m0s632ms

# [IMPROTANT] Every package has operated alarms so far, the order is from large to small
        Top Alarms:
        +2h17m22s51ms running, 2351 wakeups, 2351 alarms: 1000:android
          *walarm*:android.appwidget.action.APPWIDGET_UPDATE
        +2h14m34s553ms running, 0 wakeups, 2306 alarms: 1000:android
          *alarm*:com.android.server.action.NETWORK_STATS_POLL
        +2h12m37s265ms running, 0 wakeups, 752 alarms: u0a119:com.google.android.deskclock
          *alarm*:com.android.deskclock.ON_QUARTER_HOUR
        +2h4m45s876ms running, 0 wakeups, 77 alarms: u0a221:com.yingyonghui.market

# [IMPROTANT] Every alarm's state based on every pendingIntent of the package, such as
#   running time, wakeup frequency, pendingIntent
      Alarm Stats:
      1000:android +4h34m18s190ms running, 3170 wakeups:
        +3h24m26s128ms 0 wakes 2387 alarms, last -26s675ms:
          *alarm*:android.intent.action.TIME_TICK
        +2h17m22s51ms 2351 wakes 2351 alarms, last -22m30s863ms:
          *walarm*:android.appwidget.action.APPWIDGET_UPDATE
        +2h14m34s553ms 0 wakes 2306 alarms, last -22m30s863ms:
          *alarm*:com.android.server.action.NETWORK_STATS_POLL
        +1h23m43s116ms 490 wakes 490 alarms, last -1h52m19s742ms:
          *walarm*:com.android.server.device_idle.STEP_IDLE_STATE
        +38m19s960ms 0 wakes 134 alarms, last -1h44m4s579ms:
          *alarm*:android.content.jobscheduler.JOB_DELAY_EXPIRED
        +13m37s757ms 0 wakes 58 alarms, last -1h44  m4s579ms:
          *alarm*:android.content.jobscheduler.JOB_DEADLINE_EXPIRED
```

<br>

# 一个Batch中的alarm到底是如何被触发的

答案就是：

*当当当..当当当..*


**一个Batch中的alarms触发的是最后一个alarm的时间。**

因为Batch.start就是一个Batch触发的时间。如果有alarm加进来并且它的触发时间大于Batch.start，就会将其值赋给它。
所以Batch.start的时间会越来越靠后，也就是Batch中最后一个alarm的触发时间。

> Batch.start是触发时间的证据

```java
    void rescheduleKernelAlarmsLocked() {
      if (mAlarmBatches.size() > 0) {
            final Batch firstWakeup = findFirstWakeupBatchLocked();
            final Batch firstBatch = mAlarmBatches.get(0);
            // always update the kernel alarms, as a backstop against missed wakeups
            if (firstWakeup != null && mNextWakeup != firstWakeup.start) {
                mNextWakeup = firstWakeup.start;
                // 因为一个batch中的所有alarm都是一起被唤醒的，所以这里只给kernel设置Batch.start的时间就可以了
                setLocked(ELAPSED_REALTIME_WAKEUP, firstWakeup.start);
            }
            if (firstBatch != firstWakeup) {
                nextNonWakeup = firstBatch.start;
            }
      }
    }
```

> Batch.start是最后一个alarm的触发时间

```java
  if (alarm.whenElapsed > start) {
      start = alarm.whenElapsed;
      newStart = true;
  }
```

> 注意：dumpsys中打印Batch中的alarms就是倒序打印的：

```java
private static final void dumpAlarmList(PrintWriter pw, ArrayList<Alarm> list,
        String prefix, long nowELAPSED, long nowRTC, SimpleDateFormat sdf) {
    for (int i=list.size()-1; i>=0; i--) {
        Alarm a = list.get(i);
        final String label = labelForType(a.type);
        pw.print(prefix); pw.print(label); pw.print(" #"); pw.print(i);
                pw.print(": "); pw.println(a);
        a.dump(pw, prefix + "  ", nowRTC, nowELAPSED, sdf);
    }
}
```
