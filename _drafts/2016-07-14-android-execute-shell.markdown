---
layout:     post
title:      "Android execute shell in Java"
subtitle:   "Android App Useful Techniques --- execute shell script"
date:       2016-07-14
author:     "Vivi CAO"
header-img: "img/post-bg-notepad.jpg"
tags:
    - Android
    - Java
    - Shell
---

## How to use Asset resources

If you want to use asset resources, you should copy it from assets directory to `/data/data/{your package name}/files` directory with openFileOutput() method at first, and then use Context.getFilesDir() method to get back resources.

[Context.getFilesDir()](https://developer.android.com/reference/android/content/Context.html#getFilesDir%28%29) Returns the absolute path to the directory on the filesystem where files created with [openFileOutput(String, int)](https://developer.android.com/reference/android/content/Context.html#openFileOutput%28java.lang.String,%20int%29) are stored.

But in Android6.0,

> /data/data/{your package name}/files

> /data/user/0/{your package name}/files


```java
/**
 * Copy file from assets directory into /data/data/[my_package_name]/files/,
 * cause it write by <code>openFileOutput()</code> method
 * <p></p>
 * <p>You can use <code>getFileStreamPath</code> method to open file directly.</p>
 * <p><code>File file = getFileStreamPath(file);</code></p>
 * <p></p>
 * <p>and use <code>setExecutable</code> method to set it executable(744).
 * <p><code>boolean res = file.setExecutable(true);</code></p>
 * <p></p>
 * @param filename the file in the asset directory.
 */
public void copyFromAssets(String filename) {
    if (DEBUG) {
        Log.d(TAG, "Attempting to copy this file: " + filename);
    }
    try {
        InputStream ins = mContext.getAssets().open(filename);
        byte[] buffer = new byte[ins.available()];  //check
        ins.read(buffer);
        ins.close();
        FileOutputStream fos = mContext.openFileOutput(filename, Context.MODE_PRIVATE);
        fos.write(buffer);
        fos.close();
    } catch (IOException e) {
        e.printStackTrace();
    }
}
```
