# ADB，启动！

自动化开启 Android 系统“无线调试”并激活多数需要 ADB 权限的应用。适用于所有版本的 Android 系统（包括 Android 10 及更低版本）

## 功能

- 启动 Android 系统“无线调试”（监听端口 5555 上的 TCP/IP 连接）
- 激活 Shizuku 等需要 ADB 权限的应用
- 自动识别并跳过激活未安装的应用
- 执行完毕后提示使用技巧
- 支持自动故障排查并尝试修复

<details>
<summary>自动修复功能详情</summary>

- 未找到 ADB 工具时提醒并给出解决方案
- 尝试关闭正在运行的其它 ADB 进程防止冲突
- 检查应用激活脚本是否存在
- 执行遇到错误时提供疑难解答
- 可选忽略报错继续执行

</details>


## 支持激活的应用

> Tips：当连接的设备未安装目标应用时，将跳过激活。

### ADB 模式

- [**Shizuku**](https://shizuku.rikka.app/)
- [Scene](http://vtools.omarea.com/#/)
- [冰箱](https://www.coolapk.com/apk/com.catchingnow.icebox)
- [黑阈](https://brevent.jianyv.com/)
- [小黑屋](https://stopapp.https.gs/)（麦克斯韦妖）
- [权限狗](https://https.gs/archives/282/)

更多应用陆续支持中，欢迎[提交 issue ](https://github.com/Hakuin123/ADB-Launcher/issues/new/choose)补充~

### 设备管理员（DeviceAdmin）

现阶段仅利用设备管理员权限就可运作的玩机工具较少，欢迎[提交 issue ](https://github.com/Hakuin123/ADB-Launcher/issues/new/choose)补充~

### ~~设备所有者（DeviceOwner）~~

注：经评估后决定**不加入**`激活设备管理员模式`功能，原因详见[此处](https://github.com/Hakuin123/ADB-Launcher/issues/1)。推荐使用[秋之盒](https://atmb.top/guide/basic/dpm/)实现此功能。

- ~~[Dhizuku](https://github.com/iamr0s/Dhizuku)~~

> 需要借助设备所有者权限的应用数量繁多，但Android 系统设定具有`设备所有者`权限的应用有且仅能有一个。Dhizuku 参考 Shizuku 的设计思想，分享 DeviceOwner (设备所有者) 权限给其余应用

## 下载 & 使用
1. 转到 [Releases](https://github.com/Hakuin123/ADB-Launcher/releases/latest) 以获取最新版本
1. 在更新详情下方的`Assets`中选择`Source code(zip)`
2. 下载后**解压**`zip`格式的压缩文件
3. 双击或右键以管理员模式运行其中的`ADB，启动！- UTF-8.bat`或`ADB，启动！- GB2312.bat`

若遇到中文乱码问题，请尝试运行文件名中带有`GB2312`字样的版本，或自行搜索“[cmd显示中文乱码](https://tools.miku.ac/o/search_help/?q=Z2l0aHViIGNtZOaYvuekuuS4reaWh-S5seeggQ)”相关解决方案

## 开发

### TO DO

* 更精准的自动修复
* （待评估）执行完毕后返回桌面（部分应用被激活后会被唤醒到前台）
* ~~idk~~

### 一些碎碎念

+ 请注意，本项目的宗旨为**尽量减少人工干预**，解放双手，所以选择一次性批量激活多个应用。若需要选择性激活部分应用，请考虑自行修改源代码实现。
+ Windows 批处理不支持数组或列表数据结构，所以使用条件判而断非循环，这导致代码无法复用以减小体积~~（其实是懒所以直接复制粘贴然后替换内容）~~。后续*可能*尝试给予优化。
+ 未来*可能*将项目语言更换为 Powershell，也*有可能*支持图形化界面。~~当然前提是肝得动~~


## 参考文献

[Android 调试桥 (adb) - Android Developers](https://developer.android.google.cn/studio/command-line/adb)

[通过 Wi-Fi 连接到设备（Android 10 及更低版本） - Android Developers](https://developer.android.google.cn/studio/command-line/adb?hl=zh-cn#wireless)

[SDK 平台工具版本说明 - Android Developers](https://developer.android.google.cn/studio/releases/platform-tools?hl=zh-cn)

[冰箱 Ice Box 应用在线文档](https://iceboxdoc.catchingnow.cn/)

[如何激活Dhizuku](https://github.com/iamr0s/Dhizuku/discussions/16)

[秋之盒](https://atmb.top/)

[Android漫谈](https://atmb.top/guide/advanced/something_about_android/)