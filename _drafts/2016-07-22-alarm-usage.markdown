---
layout:     post
title:      "How to analysis Alarm dumpsys & log"
subtitle:   "Android AlarmManager Actual Analysis"
date:       2016-07-22
author:     "Vivi CAO"
header-img: "img/post-bg-notepad.jpg"
tags:
    - Android
    - Alarm
---

一个Batch中的alarms触发的是最后一个alarm的时间。
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
                // tcao: 因为一个batch中的所有alarm都是一起被唤醒的，所以这里只给kernel设置Batch.start的时间就可以了
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

> dumpsys中打印Batch中的alarms就是倒序打印的：

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
