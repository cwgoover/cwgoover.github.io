---
layout:     post
title:      "Java: How to start/end a shell process"
subtitle:   "Stop Process & Close Streams"
date:       2016-08-08
author:     "Vivi Cao"
header-img: "img/post-bg-java-process.jpg"

tags:
    - Java
    - Process
    - InputStream
---

## Using ProcessBuilder to run shell scripts





## How to stop Process started by ProcessBuilder

`start()` method of `ProcessBuilder` returns a `Process` instance. You can call `destroy()` method on it.

See: https://docs.oracle.com/javase/7/docs/api/java/lang/Process.html


I had the same problem,i use a speechRecognizer,so i am running a separate Thread which is running another .jar which prints to console and read the output using BufferedReader(something like this..):

```java
//In seperate Thread from the Main App Thread
while (!stopped) {
                while ((line = bufferedReader.readLine()) != null && !line.isEmpty()) {
                    System.out.println(line);
                    checkSpeechResult(line);
                }
            }
```

The problem

Basically the bufferedRead.readLine() lags until it has something to read.

If nothing comes it will wait forever.

Answer:

From another Thread call this:

```java
process.destroy();
```

and it will stop the process so the `bufferedRead.readLine()` will exit.

If you start the process from with in your Java application (ex. by calling `Runtime.exec()` or `ProcessBuilder.start()`) then you have a valid `Proces`s reference to it, and you can invoke the `destroy()` method in `Process` class to kill that particular process.

But be aware that if the process that you invoke creates new sub-processes, those may not be terminated (see http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=4770092).

On the other hand, if you want to kill external processes (which you did not spawn from your Java app), then one thing you can do is to call O/S utilities which allow you to do that. For example, you can try a `Runtime.exec()` on `kill` command under Unix / Linux and check for return values to ensure that the application was killed or not (0 means success, -1 means error). But that of course will make your application platform dependent.


#### How can I cause a child process to exit when the parent does?

Shutdown hooks execute in all cases where the VM is not forcibly killed. So, if you were to issue a "standard" kill (SIGTERM from a kill command) then they will execute. Similarly, they will execute after calling System.exit(int).

However a hard kill (kill -9 or kill -SIGKILL) then they won't execute. Similarly (and obviously) they won't execute if you pull the power from the computer, drop it into a vat of boiling lava, or beat the CPU into pieces with a sledgehammer. You probably already knew that, though.

Finalizers really should run as well, but it's best not to rely on that for shutdown cleanup, but rather rely on your shutdown hooks to stop things cleanly. And, as always, be careful with deadlocks (I've seen far too many shutdown hooks hang the entire process)!



While you cannot protect against a hard abort (e.g. SIGKILL on Unix), you can protect against other signals that cause your parent process to shut down (e.g. SIGINT) and clean up your child process. You can accomplish this through use of shutdown hooks: see Runtime#addShutdownHook, as well as a related SO question here.

Your code might look something like this:

```java
String[] command;
final Process childProcess = new ProcessBuilder(command).start();

Thread closeChildThread = new Thread() {
    public void run() {
        childProcess.destroy();
    }
};

Runtime.getRuntime().addShutdownHook(closeChildThread);
```


#### Process.waitFor() never return

From [**stackoverflow**](http://stackoverflow.com/questions/5483830/process-waitfor-never-returns)

There are many reasons that waitFor() doesn't return. But it usually boils down to the fact that the executed command doesn't quit.

**One common reason is that the process produces some output and you don't read from the appropriate streams. This means that the process is blocked as soon as the buffer is full and waits for your process to continue reading.**

In other words, it appears you are not reading the output before waiting for it to finish. This is fine only if the output doesn't fill the buffer. If it does, it will wait until you read the output. So you need to continually read from the processes input stream to ensure that it doesn't block.

**NOTE that** If there are some errors which you are not reading. This also would case the application to stop and waitFor to wait forever. A simple way around this is to re-direct the errors to the regular output.

```java
ProcessBuilder pb = new ProcessBuilder("tasklist");

pb.redirectErrorStream(true);
// pb.redirectError(new File("/dev/null"));

Process process = pb.start();

BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));

String line;
while ((line = reader.readLine()) != null)
    System.out.println("tasklist: " + line);

process.waitFor();
```

There's a nice article that explains all the pitfalls of Runtime.exec() and shows ways around them called ["When Runtime.exec()](http://www.javaworld.com/javaworld/jw-12-2000/jw-1229-traps.html) won't" (yes, the article is from 2000, but the content still applies!)


##How to properly stop the Thread


Using Thread.interrupt() is a perfectly acceptable way of doing this. In fact, it's probably preferrable to a flag as suggested above. The reason being that if you're in an interruptable blocking call (like Thread.sleep or using java.nio Channel operations), you'll actually be able to break out of those right away.

If you use a flag, you have to wait for the blocking operation to finish and then you can check your flag. In some cases you have to do this anyway, such as using standard InputStream/OutputStream which are not interruptable.

In that case, when a thread is interrupted, it will not interrupt the IO, however, you can easily do this routinely in your code (and you should do this at strategic points where you can safely stop and cleanup)

```java
if (Thread.currentThread().isInterrupted()) {
  // cleanup and stop execution
  // for example a break in a loop
}
```

Like I said, the main advantage to Thread.interrupt() is that you can immediately break out of interruptable calls, which you can't do with the flag approach.

##[如何停止一个正在运行的java线程](http://ibruce.info/2013/12/19/how-to-stop-a-java-thread/)

thread.interrupt()

具体作用分以下几种情况：

* 如果该线程正阻塞于Object类的wait()、wait(long)、wait(long, int)方法，或者Thread类的join()、join(long)、join(long, int)、sleep(long)、sleep(long, int)方法，则该线程的中断状态将被清除，并收到一个java.lang.InterruptedException。
* 如果该线程正阻塞于interruptible channel上的I/O操作，则该通道将被关闭，同时该线程的中断状态被设置，并收到一个java.nio.channels.ClosedByInterruptException。
* 如果该线程正阻塞于一个java.nio.channels.Selector操作，则该线程的中断状态被设置，它将立即从选择操作返回，并可能带有一个非零值，就好像调用java.nio.channels.Selector.wakeup()方法一样。
* 如果上述条件都不成立，则该线程的中断状态将被设置。

小结：第一种情况最为特殊，阻塞于wait/join/sleep的线程，中断状态会被清除掉，同时收到著名的InterruptedException；而其他情况中断状态都被设置，并不一定收到异常。

对于本问题，我认为准确的说法是：停止一个线程的最佳方法是让它执行完毕，没有办法立即停止一个线程，但你可以控制何时或什么条件下让他执行完毕。

通过条件变量控制线程的执行，线程内部检查变量状态，外部改变变量值可控制停止执行。为保证线程间的即时通信，需要使用使用volatile关键字或锁，确保读线程与写线程间变量状态一致。下面给一个最佳模板：

```java
public class BestPractice extends Thread {
    private volatile boolean finished = false;   // ① volatile条件变量
    public void stopMe() {
        finished = true;    // ② 发出停止信号
    }
    @Override
    public void run() {
        while (!finished) {    // ③ 检测条件变量
            // do dirty work   // ④业务代码
        }
    }
}
```
