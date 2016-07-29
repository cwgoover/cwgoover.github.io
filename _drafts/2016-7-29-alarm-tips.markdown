---
layout:     post
title:      "Android Alarm Tips"
subtitle:   "PendingIntent & Alarm tips"
date:       2016-07-29
author:     "Vivi Cao"
header-img: "img/post-bg-alarm-tips.jpg"

tags:
    - Android
    - Alarm
---



第三个参数PendingIntent operation表示闹钟响应动作：
PendingIntent operation：是闹钟的执行动作，比如发送一个广播、给出提示等等。PendingIntent是Intent的封装类。需要注意的是：

* **启动服务:** 如果是通过启动服务来实现闹钟提示的话，PendingIntent对象的获取就应该采用`Pending.getService(Context c,int i,Intent intent,int j)`方法；
* **启动广播:** 如果是通过广播来实现闹钟提示的话，PendingIntent对象的获取就应该采用`PendingIntent.getBroadcast(Context c,inti,Intent intent,int j)`方法；
* **启动activity:** 如果是采用Activity的方式来实现闹钟提示的话，PendingIntent对象的获取就应该采用`PendingIntent.getActivity(Context c,inti,Intent intent,int j)`方法。
如果这三种方法错用了的话，虽然不会报错，但是看不到闹钟提示效果。

注意：AndroidL开始，设置的alarm的触发时间必须大于当前时间 5秒
AlarmManagerService中是通过PendingItent来标示一个Alarm的
AndroidL开始系统有了非唤醒Alarm在黑屏状况下会推迟触发，推迟的时间通过当前黑屏时间计算出来，但一但有唤醒Alarm，则随着触发


<br>
<br>
<br>
<br>
在PendingIntent.Java文件中，我们可以看到有如下几个比较常见的静态函数：

```Java
public static PendingIntent getActivity(Context context, int requestCode, Intent intent, int flags)
public static PendingIntent getBroadcast(Context context, int requestCode, Intent intent, int flags)
public static PendingIntent getService(Context context, int requestCode, Intent intent, int flags)
public static PendingIntent getActivities(Context context, int requestCode, Intent[] intents, int flags)
public static PendingIntent getActivities(Context context, int requestCode, Intent[] intents, int flags, Bundle options)
```


上面的getActivity()的意思其实是，获取一个PendingIntent对象，而且该对象日后激发时所做的事情是启动一个新activity。也就是说，当它异步激发时，会执行类似Context.startActivity()那样的动作。相应地，getBroadcast()和getService()所获取的PendingIntent对象在激发时，会分别执行类似Context..sendBroadcast()和Context.startService()这样的动作。至于最后两个getActivities()，用得比较少，激发时可以启动几个activity。

1. intent就是需要启动的Activity、Service、BroadCastReceiver的intent。
2. Flags的类型：
  * FLAG_ONE_SHOT：得到的pi只能使用一次，第二次使用该pi时报错
  * FLAG_NO_CREATE： 当pi不存在时，不创建，返回null
  * FLAG_CANCEL_CURRENT： 每次都创建一个新的pi
  * FLAG_UPDATE_CURRENT： 不存在时就创建，创建好了以后就一直用它，每次使用时都会更新pi的数据(使用较多)

在AlarmManager中的使用

```java
Intent intent = new Intent("action", null, context, serviceClass);  
PendingIntent pi = PendingIntent.getService(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT);  
AlarmManager manager = (AlarmManager)probe.getSystemService(Context.ALARM_SERVICE);  
manager.set(AlarmManager.RTC_WAKEUP, milis, pi);
```


在NotificationManager中的使用

```java
Intent intent = new Intent();  
intent.setAction("myaction");  
PendingIntent pi = PendingIntent.getBroadcast(this, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT);  

NotificationManager nm = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);  
Notification n = new Notification();  
n.icon = R.drawable.ic_launcher;  
n.when = System.currentTimeMillis();  
n.setLatestEventInfo(this,"this is title", "this is a message", pi);  
nm.notify(0, n);
```


两个重要方法：
send()方法是用，调用PendingIntent.send()会启动包装的Intent(如启动service，activity)

cancel()方法是为了解除PendingIntent和被包装的Intent之间的关联，此时如果再调用send()方法，则会抛出CanceledException异常

PendingIntent和Intent的区别：
PendingIntent就是一个Intent的描述，我们可以把这个描述交给别的程序，别的程序根据这个描述在后面的别的时间做你安排做的事情
换种说法Intent 字面意思是意图，即我们的目的，我们想要做的事情，在activity中，我们可以立即执行它
PendingIntent 相当于对intent执行了包装，我们不一定一定要马上执行它，我们将其包装后，传递给其他activity或application
这时，获取到PendingIntent 的application 能够根据里面的intent 来得知发出者的意图，选择拦击或者继续传递或者执行。
