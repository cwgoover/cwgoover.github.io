---
layout:     post
title:      "Simulate Android Input for auto test"
subtitle:   "Android Keyevent issues"
date:       2016-07-30
author:     "Vivi Cao"
header-img: "img/post-bg-simu-input.jpg"

tags:
    - Android
    - Keyevent
    - Input
---

come from "http://www.51testing.com/html/65/n-215865-2.html"

命令格式2：adb shell sendevent [device] [type] [code] [value]

　　如： adb shell sendevent /dev/input/event0 1 229 1 代表按下按下menu键

　　adb shell sendevent /dev/input/event0 1 229 0 代表按下松开menu键

　　说明：上述的命令需组合使用

　　另外所知道的命令如下：

　　Key Name                        CODE

　　MENU                                 229

　　HOME                                 102

　　BACK (back button)            158

　　CALL (call button)               231

　　END (end call button)         107

　　2. 发送鼠标事件(Touch)：

　　命令格式：adb shell sendevent [device] [type] [code] [value]

　　情况1：在某坐标点上touch

　　如在屏幕的x坐标为40，y坐标为210的点上touch一下，命令如下

　　adb shell sendevent /dev/input/event0 3 0 40
　　adb shell sendevent /dev/input/event0 3 1 210
　　
　　adb shell sendevent /dev/input/event0 1 330 1 //touch
　　adb shell sendevent /dev/input/event0 0 0 0       //it must have
　　
　　adb shell sendevent /dev/input/event0 1 330 0 //untouch
　　adb shell sendevent /dev/input/event0 0 0 0 //it must have

　　注：以上六组命令必须配合使用，缺一不可

　　情况2：模拟滑动轨迹（可下载并采用aPaint软件进行试验）

　　如下例是在aPaint软件上画出一条开始于（100,200），止于（108,200）的水平直线

　　adb shell sendevent /dev/input/event0 3 0 100 //start from point (100,200)
　　adb shell sendevent /dev/input/event0 3 1 200
　　
　　adb shell sendevent /dev/input/event0 1 330 1 //touch
　　adb shell sendevent /dev/input/event0 0 0 0
　　
　　adb shell sendevent /dev/input/event0 3 0 101 //step to point (101,200)
　　adb shell sendevent /dev/input/event0 0 0 0
　　……………………                                                  //must list each step, here just skip
　　adb shell sendevent /dev/input/event0 3 0 108 //end point(108,200)
　　adb shell sendevent /dev/input/event0 0 0 0
　　
　　adb shell sendevent /dev/input/event0 1 330 0 //untouch
　　adb shell sendevent /dev/input/event0 0 0 0


[Android自动化测试初探（四）: 模拟键盘鼠标事件（Socket+Instrumentation实现）](http://www.51testing.com/html/14/n-215814.html)

通过Socket + Instrumentation实现模拟键盘鼠标事件主要通过以下三个部分组成：

　　*   Socket编程：实现PC和Emulator通讯，并进行循环监听

　　*   Service服务：将Socket的监听程序放在Service中，从而达到后台运行的目的。这里要说明的是启动服务有两种方式，bindService和startService，两者的区别是，前者会使启动的Service随着启动Service的Activity的消亡而消亡，而startService则不会这样，除非显式调用stopService，否则一直会在后台运行因为Service需要通过一个Activity来进行启动，所以采用startService更适合当前的情形

　　*   Instrumentation发送键盘鼠标事件：Instrumentation提供了丰富的以send开头的函数接口来实现模拟键盘鼠标，如下所述：

　　sendCharacterSync(int keyCode)            //用于发送指定KeyCode的按键

　　sendKeyDownUpSync(int key)                //用于发送指定KeyCode的按键

　　sendPointerSync(MotionEvent event)     //用于模拟Touch

　　sendStringSync(String text)                   //用于发送字符串

　　注意：以上函数必须通过Message的形式抛到Message队列中。如果直接进行调用加会导致程序崩溃。

　　对于Socket编程和Service网上有很多成功的范例，此文不再累述，下面着重介绍一下发送键盘鼠标模拟事件的代码：

　　1.  发送键盘KeyCode：

　　步骤1. 声明类handler变量

private static Handler handler;

　　步骤2. 循环处理Message

//在Activity的onCreate方法中对下列函数进行调用
private void createMessageHandleThread(){
    //need start a thread to raise looper, otherwise it will be blocked
        Thread t = new Thread() {
            public void run() {
                Log.i( TAG,"Creating handler ..." );
                Looper.prepare();
                handler = new Handler(){
                    public void handleMessage(Message msg) {
                           //process incoming messages here
                    }
                };
                Looper.loop();
                Log.i( TAG, "Looper thread ends" );
            }
        };
        t.start();
}

　　步骤3. 在接收到Socket中的传递信息后抛出Message

handler.post( new Runnable() {
            public void run() {
Instrumentation inst=new Instrumentation();
inst.sendKeyDownUpSync(keyCode);
}
} );

　　2. Touch指定坐标，如下例子即touch point（240,400）

Instrumentation inst=new Instrumentation();
inst.sendPointerSync(MotionEvent.obtain(SystemClock.uptimeMillis(),SystemClock.uptimeMillis(), MotionEvent.ACTION_DOWN, 240, 400, 0));
inst.sendPointerSync(MotionEvent.obtain(SystemClock.uptimeMillis(),SystemClock.uptimeMillis(), MotionEvent.ACTION_UP, 240, 400, 0));

　　3. 模拟滑动轨迹

　　将上述方法中间添加 MotionEvent.ACTION_MOVE



[android toolbox命令之—getevent sendevent详解](http://mengren425.lofter.com/post/1cc9ec41_51eb071)

[Emulating touchscreen interaction with sendevent in Android ](http://ktnr74.blogspot.hk/2013/06/emulating-touchscreen-interaction-with.html)

[Documentation for adb shell getevent / sendevent](http://android.stackexchange.com/questions/26261/documentation-for-adb-shell-getevent-sendevent)

[Android Getevent](http://source.android.com/devices/input/getevent.html)

[Touch Android Without Touching ](http://www.slideshare.net/SeongJaePark1/touch-android-without-touching-presentation)


#### Input Architecture

[Android overlay to grab ALL touch, and pass them on?](http://stackoverflow.com/questions/9085022/android-overlay-to-grab-all-touch-and-pass-them-on)

[why does return value of onTouchEvent either crashes application or freezes mapView?](http://stackoverflow.com/questions/7713458/why-does-return-value-of-ontouchevent-either-crashes-application-or-freezes-mapv)

[onTouchEvent 、onInterceptTouchEvent的顺序~ ](http://yxwww.iteye.com/blog/1409461)

[Android ViewGroup中事件触发和传递机制 ](http://blog.csdn.net/starfeng11/article/details/7009338)

[Android的用户输入处理](http://www.cnblogs.com/samchen2009/p/3368158.html)

[Chapter XII - The Android Input Architecture](http://newandroidbook.com/Book/Input.html?r)

[Android 的窗口管理系统 (View, Canvas, WindowManager)](http://www.cnblogs.com/samchen2009/p/3367496.html)

[Android Developers: Dumpsys Input Diagnostics](https://source.android.com/devices/input/diagnostics.html)

[Android Developers: Input Events](https://developer.android.com/guide/topics/ui/ui-events.html)

[Android 5.0(Lollipop)事件输入系统(Input System) ](http://blog.csdn.net/jinzhuojun/article/details/41909159)

[viewcontent](http://digitalcommons.calpoly.edu/cgi/viewcontent.cgi?article=1568&context=theses)

[Multitouch on Android](http://lii-enac.fr/en/architecture/linux-input/multitouch-android-howto.html)

[EventHub.cpp](http://berebereport.tistory.com/65)

[Android 的 KeyEvent : 從 EventHub 到 PhoneWindowManager ](http://mf99coding.logdown.com/posts/162658-android-keyevent-processes)

[Android Mutlitouch Input Architecture](https://virdust.wordpress.com/2009/06/16/android-mutlitouch-input-architecture/)

[Android 4.0 事件輸入(Event Input)系统](http://linux-vincent.blogspot.hk/2014/08/android-40-event-input.html)

[Input Event Detect and Dispatch](https://cphacker0901.wordpress.com/1900/12/03/android-input-event-dispatching/)

[Android Key Handling (Framework)](http://stackoverflow.com/questions/11947653/android-key-handling-framework)

[Internal input event handling in the Linux kernel and the Android userspace ](https://seasonofcode.com/posts/internal-input-event-handling-in-the-linux-kernel-and-the-android-userspace.html)

[Android输入输出机制之来龙去脉之前生后世](http://daojin.iteye.com/blog/1267890)

[Android输入事件处理过程分析 & 锁屏方法](http://blog.sina.com.cn/s/blog_3e3fcadd0100hrzf.html)

[Android Input流程](http://www.jianshu.com/p/38f2da61973d)

[About Dispatch Queues](https://developer.apple.com/library/ios/documentation/General/Conceptual/ConcurrencyProgrammingGuide/OperationQueues/OperationQueues.html)

[Where in Android source does the KeyEvent dispatcher send to onKeyDown?](http://stackoverflow.com/questions/7682590/where-in-android-source-does-the-keyevent-dispatcher-send-to-onkeydown)

[Android - Key Dispatching Timed Out](http://stackoverflow.com/questions/3467205/android-key-dispatching-timed-out)
