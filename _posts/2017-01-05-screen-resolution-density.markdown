---
layout:     post
title:      "Android入门之分辨率和密度"
subtitle:   "Android Resolution Vs Pixel Density in Displays"
date:       2017-01-05
author:     "Vivi CAO"
header-img: "img/post-bg-notepad.jpg"
header-mask: 0.3
catalog:    true
tags:
    - Android
    - Display
---

## 基础概念 (Terms and concepts)

**`Screen size(屏幕尺寸)`**

按屏幕对角测量的实际物理尺寸(Actual physical size, measured as the screen's diagonal).

**`Screen density(屏幕密度)`**

屏幕物理区域中的像素量(the quantity of pixels)；通常称为 dpi（每英寸点数）`dpi (dots per inch)`.

涉及到的概念: ldpi, mdpi, hdpi, xdpi(extra-high), xxdpi, xxxdpi.

**`Resolution(分辨率)`**

屏幕上物理像素(physical pixels)的总数。对于多屏支持，应用不需考虑该元素而只关心**screen size**和**density**.

**`Density-independent pixel(密度无关像素) (dp)`**

在定义UI layout时使用的一种虚拟像素单元(virtual pixel unit)，它可以自由地表示布局维度(layout dimensions)或位置(position)而不用去关心屏幕密度(ensure proper display of your UI on screens with different densities).

dp等于160 dpi屏幕上的一个物理像素(physical pixel)--"medium" density screen. 系统会在运行时根据具体的屏幕密度对dp的大小进行缩放处理，该过程用户不可见。

**dp转换为像素pixel的公式: `px = dp * (dpi / 160)`. 例如，一个240 dpi屏幕, 1 dp 等于 1.5 physical pixels.**

* 六种通用的密度：
  - ldpi   （低）       ~120dpi (0.75dp)
  - mdpi   （中）       ~160dpi (1.0dp)       [基线]
  - hdpi   （高）       ~240dpi (1.5dp)
  - xhdpi  （超高）     ~320dpi (2.0dp)
  - xxhdpi （超超高）   ~480dpi (3.0dp)
  - xxxhdpi（超超超高） ~640dpi (4.0dp)

  **定义设备通用的屏幕尺寸(generalized screen size)和密度(density)两者是相互独立的。** 比如WVGA和high-density的屏被认为是正常尺寸屏幕normal size screen，因为其物理尺寸与 T-Mobile G1（Android 的第一代设备和基线屏幕配置）大致相同。另一方面，WVGA medium-density屏却被视为大尺寸屏幕。虽然它提供相同的分辨率（都是WVGA，相同的像素数pixels），但WVGA medium-density屏的屏幕密度更低，意味着每个像素实际上更大，因此整个屏幕大于基线（normal size）屏幕。

  > 注：WVGA是一种屏幕分辨率(Resolution)的规格，其中的W意味宽（wide），长宽比为800×480。与之相关的还有VGA（640×480）。 WVGA并不是16：9比例，而是5：3的显示分辨率，因此在播放HD规格视频时会留有黑色边框。
  > 这里也就是说WVGA规格的屏幕长有800个像素，宽有480个像素。中密度与高密度的屏幕相比，因为像素实际更大，所以实际物理尺寸WVGA的中密度屏更大。


## 密度独立性(Density independence)

**应用维持密度独立就是为了避免UI元素（比如button）在low-density的屏幕上显示的更大（每英寸点数更少，即每个像素更大），在high-density屏幕上显示的更小。**

Android系统可帮助您的应用以两种方式实现密度独立性：

* The system scales dp units as appropriate for the current screen density
* The system scales drawable resources to the appropriate size, based on the current screen density, if necessary

以上也就是说：
1) 非图片的一些布局尺寸定义如dimens.xml中的一些定义项，如果用dp值定义，系统就会自动伸缩匹配；
2)图片资源drawable根据不同的屏幕密度放在适当的资源文件夹下，比如drawable-hdpi, drawable-xxhdpi下系统会自动匹配。


## 支持多种屏幕

应用可通过以下几种方式来配合系统更适当地处理不同的屏幕配置：

* **Provide different layouts for different screen sizes**
* **Provide different bitmap drawables for different screen densities**
  * 对launcher icon以外的UI元素不应使用 xxxhdpi 限定符。
  * 将launcher icon放在_res/mipmap-[density]/_ 文件夹中，而非_res/drawable-[density]/_ 中。

在运行时，系统会先根据当前屏幕的尺寸和密度查找应用中最匹配的资源；如果没有找到匹配的资源，则会使用默认的资源(default resources)，并按需对资源进行缩放以使其匹配当前的屏幕尺寸和密度。但其实，系统也会使用其他特定密度的资源。比如对于低密度资源，系统更愿意降低高密度而不是中密度资源去适配，因为缩放因子是0.5而不是中密度的0.75，方便计算。

> "default" resources是那些没有标记configuration qualifier的资源。比如，_drawable/_ 目录下的资源就是默认可绘制资源.

**系统假定默认资源就是基线屏幕尺寸和密度(the baseline screen size and density)，即正常屏幕尺寸和中密度(normal screen size and a medium-density).**

 Nine-Patch位图是一种PNG格式的文件，它可以指定二维区域上的拉伸，比如button的背景图。虽然Nine-Patch位图可以适配任何大小，但是我们仍然需要为不同的屏幕密度提供其的替代版本。

 只有bitmap(位图文件)(.png, .jpg, or .gif)和Nine-Patch文件(.9.png)需要提供特定密度可绘制对象(density-specific drawables)；如果是xml定义的shapes, colors, 或者其他drawable资源，需要放一个副本在默认可绘制对象目录中 _(drawable/)_。


## Best Practices

下面是适应不同屏幕的三个主要规则：

1. Use `wrap_content`, `match_parent`, or `dp` units when specifying dimensions in an XML layout file
2. Do not use hard coded pixel values in your application code
3. Supply alternative bitmap drawables for different screen densities


## 其他密度注意事项：

由于性能的原因和简化代码的需要，**Android系统使用像素作为表示尺寸或坐标值的标准单位。这意味着， 视图的尺寸在代码中始终以像素表示，但始终基于当前的屏幕密度。**  例如，如果 `myView.getWidth()` 返回10，则表示视图在当前屏幕上为10像素宽，但在更高密度的屏幕上，返回的值可能是15。如果在应用代码中使用像素值来处理预先未针对当前屏幕密度缩放的位图，您可能需要缩放代码中使用的像素值，以与未缩放的位图来源匹配。

**注意，如果是创建内存中的位图（an in-memory Bitmap 对象），系统在默认情况下假设位图是针对基线中密度屏幕而设计，然后在绘制时自动缩放位图。如果没有根据当前的屏幕密度给位图指定一个密度属性时，系统会对Bitmap“自动缩放”，这有可能导致缩放伪影，就像未提供备用资源一样。**

可以使用`setDensity()`指定位图的密度，从`DisplayMetrics`传递密度常量，例如`DENSITY_HIGH`或 `DENSITY_LOW`。

如果使用`BitmapFactory`创建Bitmap，例如从文件或流创建，可以使用`BitmapFactory.Options`定义位图的属性（因为它已经存在），确定系统是否要缩放或者如何缩放。例如，您可以使用`inDensity`字段定义位图设计时的密度。


## 将dp单位转换为像素单位

如果需要设定手指移动至少16像素之后可以识别滚动或滑动手势，那么如果直接在代码中设定像素值为16,也就是基线屏幕上，用户必须移动`16 pixels / 160 dpi`（等于1/10 inch或者2.5 mm）才会识别该手势。而在具有高密度显示屏 (240dpi) 的设备上，用户必须移动`16 pixels / 240 dpi`（等于一英寸的1/15或者1.7 mm）此距离更短、更灵敏。

要修复此问题，手势阈值必须在代码中以`dp`表示，然后转换为实际像素，才能保证所有设备上移动距离相似。

```java
// The gesture threshold expressed in dp
private static final float GESTURE_THRESHOLD_DP = 16.0f;

// Get the screen's density scale
final float scale = getResources().getDisplayMetrics().density;
// Convert the dps to pixels, based on density scale
mGestureThreshold = (int) (GESTURE_THRESHOLD_DP * scale + 0.5f);

// Use mGestureThreshold as a distance in pixels...
```

`DisplayMetrics.density`字段根据当前屏幕密度指定将 dp 单位转换为像素必须使用的缩放系数。 在中密度屏幕上，DisplayMetrics.density等于1.0；在高密度屏幕上，它等于 1.5；该缩放系数`(dpi / 160)`乘以dp值以获取用于当前屏幕的实际像素数。（然后在转换时加上`0.5f`，将该数字四舍五入到最接近的整数。）

其实上面的例子可以用`ViewConfiguration`类的`getScaledTouchSlop()`方法直接获取滚动阈值的像素距离：

```java
private static final int GESTURE_THRESHOLD_DP = ViewConfiguration.get(myContext).getScaledTouchSlop();
```

`ViewConfiguration`类中所有以`getScaled`为前缀的方法返回的像素值都是根据当前屏幕密度可以正常显示的像素值。
