# ADB，启动！

自动化开启 Android 系统无线调试并激活多数需要 ADB 权限的应用。适用于所有版本的 Android 系统（包括Android 10 及更低版本）

请注意，本工具的初衷是为了解放双手，尽可能一次性激活更多应用。若需要选择性激活部分应用，请考虑自行修改源代码实现。

## 功能

- 启动 Android 系统无线调试
- 激活 Shizuku 等需要 ADB 权限的应用
- 自动识别并跳过激活未安装的应用
- 未找到 ADB 工具时提醒并给出解决方案
- 执行遇到错误时尝试关闭正在运行的其它ADB进程防止冲突
- 执行遇到错误时提供疑难解答

## 支持激活的应用

Tips：当连接的设备未安装目标应用时，将跳过激活。

### ADB 模式

- [Shizuku](https://shizuku.rikka.app/)
- [Scene](http://vtools.omarea.com/#/)
- [冰箱](https://www.coolapk.com/apk/com.catchingnow.icebox)
- [黑阈](https://brevent.jianyv.com/)

### 设备管理员（Device Admin）

TO DO

### 设备所有者（Device Owner）

TO DO

## TO DO

* 支持激活设备管理员模式
* 支持激活设备所有者模式
* 支持自动故障排查并尝试解决
* idk


## 参考文献

[Android 调试桥 (adb) - Android Developers](https://developer.android.google.cn/studio/command-line/adb)

[通过 Wi-Fi 连接到设备（Android 10 及更低版本） - Android Developers](https://developer.android.google.cn/studio/command-line/adb?hl=zh-cn#wireless)

[SDK 平台工具版本说明 - Android Developers](https://developer.android.google.cn/studio/releases/platform-tools?hl=zh-cn)

[冰箱 Ice Box 应用在线文档](https://iceboxdoc.catchingnow.cn/)