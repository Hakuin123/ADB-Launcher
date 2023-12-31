@echo off
chcp 936
::如果出现乱码请尝试使用UTF-8版本
cls
title ADB，启动！  by 白隐Hakuin

:check
echo = 检查 ADB 环境=
adb version
if not %errorlevel%==0 (
echo 未找到 ADB（Android Debug Bridge）！请确保这台计算机拥有 ADB 运行环境（可参考网络教程）
echo Android SDK 平台工具：https://googledownloads.cn/android/repository/platform-tools-latest-windows.zip
echo 请使用浏览器打开上面的链接，下载并解压 'platform-tools' 文件夹，将此.bat文件放在该文件夹下，再次运行此.bat文件
pause
exit
)
echo.

:start
echo = 启动 ADB 服务 =
adb start-server||goto fix
echo 等待设备连接...
echo 请使用 USB 数据线连接设备，可能需要在设备上手动允许 USB 调试
:: 注意：当您连接搭载 Android 4.2.2（API 级别 17）或更高版本的设备时，系统会显示一个对话框，询问您是否接受允许通过此计算机进行调试的 RSA 密钥。
:: 这种安全机制可以保护用户设备，因为它可以确保用户只有在能够解锁设备并确认对话框的情况下才能执行 USB 调试和其他 adb 命令。
adb wait-for-device
echo.
echo = 已连接设备 =
adb devices -l

echo = 启动无线调试 =
adb tcpip 5555
echo 无线调试启用后有一定风险，请注意不要轻易允许来历不明的 ADB 调试请求
echo 等待重新连接...
adb wait-for-device
echo.


:Shizuku
adb shell pm list packages | findstr /i "moe.shizuku.privileged.api" > nul
if %errorlevel%==0 (
echo 已安装 Shizuku，执行启动命令...
  adb shell sh /storage/emulated/0/Android/data/moe.shizuku.privileged.api/start.sh||goto fix
) else (
  echo 未安装 Shizuku，跳过启动
)
echo.


:Scene
adb shell pm list packages | findstr /i "com.omarea.vtools" > nul
if %errorlevel%==0 (
echo 已安装 Scene，执行激活命令...
  adb shell sh /sdcard/Android/data/com.omarea.vtools/up.sh||goto fix
) else (
  echo 未安装 Scene，跳过激活
)
echo.


:icebox
adb shell pm list packages | findstr /i "com.catchingnow.icebox" > nul
if %errorlevel%==0 (
echo 已安装 冰箱，执行激活命令...
  adb shell sh /sdcard/Android/data/com.catchingnow.icebox/files/start.sh||goto fix
) else (
  echo 未安装 冰箱，跳过激活
)
echo.


:brevent
adb shell pm list packages | findstr /i "me.piebridge.brevent" > nul
if %errorlevel%==0 (
echo 已安装 黑阈，执行激活命令...
  adb shell sh /data/data/me.piebridge.brevent/brevent.sh||goto fix
) else (
  echo 未安装 黑阈，跳过激活
)
echo.

echo 全部执行完成，关闭 ADB 服务
adb kill-server
pause
exit



:fix
echo == 执行遇到错误，尝试修复ing ==
echo 尝试关闭正在运行的其它ADB进程防止冲突...
taskkill /F /IM adb.exe||echo 若提示没有找到进程说明无ADB冲突，可忽略
echo.
echo 尝试查看 ADB 默认端口（5037）是否被占用...
netstat -aon | findstr 5037
echo 若显示结果，则代表该端口已被其他进程占用。回显最右侧为该进程对应 PID，请在任务管理器中手动将其关闭
echo.
echo == 常见问题 ==
echo 1. 若提示“'adb' 不是内部或外部命令...”，请确保此脚本是否和 ADB 相关工具放在同一文件夹下，或确保你的计算机是否有ADB执行环境（可参考网络教程）
echo 2. 激活某个应用时若提示“no such file or directory”，请先在设备上启动一次该应用
echo 3. 若提示“adb server version (7601) doesn't match this client (41); killing...”，请关闭计算机上正在运行的“手机助手”类软件，如“360手机助手”“鲁大师手机助手”等
echo.
pause
cls
goto start
