@echo off
chcp 936 > nul
::如果出现乱码请尝试使用UTF-8版本
title ADB，启动！  v1.3  by 白隐Hakuin
:: 初始化忽略错误变量
set IGNORE_ERROR=0

:check
echo = 检查 ADB 环境 =
adb version
if not %errorlevel%==0 (
  echo 未找到 ADB（Android Debug Bridge）！请检查此脚本是否和 ADB 相关工具放在同一文件夹下，或确保这台计算机拥有 ADB 运行环境（可参考网络教程）
  echo Android SDK 平台工具：https://googledownloads.cn/android/repository/platform-tools-latest-windows.zip
  echo 请使用浏览器打开上面的链接，下载并解压 'platform-tools' 文件夹，将此.bat文件放在该文件夹下，再次运行此.bat文件
  pause
  exit
)
echo.

:start
echo = 启动 ADB 服务 =
adb start-server
if not %errorlevel%==0 (
  if %IGNORE_ERROR%==1 (
    echo [强制执行] 已选择强制执行模式，忽略错误并继续...
  )
  goto :fix
)
echo 等待设备连接...
echo 请使用 USB 数据线连接设备，可能需要在设备上手动允许 USB 调试
:: 注意：当您连接搭载 Android 4.2.2（API 级别 17）或更高版本的设备时，系统会显示一个对话框，询问您是否接受允许通过此计算机进行调试的 RSA 密钥。
:: 这种安全机制可以保护用户设备，因为它可以确保用户只有在能够解锁设备并确认对话框的情况下才能执行 USB 调试和其他 adb 命令。
adb wait-for-device
echo.
echo = 已连接设备 =
adb devices -l

:wireless
echo = 启动无线调试 =
adb tcpip 5555
if not %errorlevel%==0 (
  if %IGNORE_ERROR%==1 (
    echo [强制执行] 已选择强制执行模式，忽略错误并继续...
  )
  goto :fix
)
echo 无线调试启用后有一定风险，请注意不要轻易允许来历不明的 ADB 调试请求
echo 等待重新连接...
adb wait-for-device
echo.

:force
if %IGNORE_ERROR%==1 (
  echo [强制执行] 已选择强制执行模式，直接执行所有启动及激活命令...
  adb shell sh /storage/emulated/0/Android/data/moe.shizuku.privileged.api/start.sh
  adb shell sh /sdcard/Android/data/com.omarea.vtools/up.sh
  adb shell sh /sdcard/Android/data/com.catchingnow.icebox/files/start.sh
  adb shell sh /storage/emulated/0/Android/data/web1n.stopapp/files/starter.sh
  adb shell sh /storage/emulated/0/Android/data/com.web1n.permissiondog/files/starter.sh
  goto :end
)


:shizuku
:: 检查是否安装 Shizuku
adb shell pm list packages | findstr /i "moe.shizuku.privileged.api" > nul
if %errorlevel%==0 (
  echo 已安装 Shizuku，执行启动命令...
  adb shell sh /storage/emulated/0/Android/data/moe.shizuku.privileged.api/start.sh || goto :fix
) else (
  echo 未安装 Shizuku，跳过启动
)
echo.


:scene
adb shell pm list packages | findstr /i "com.omarea.vtools" > nul
if %errorlevel%==0 (
  echo 已安装 Scene，执行激活命令...
  adb shell sh /sdcard/Android/data/com.omarea.vtools/up.sh || goto :fix
) else (
  echo 未安装 Scene，跳过激活
)
echo.


:icebox
adb shell pm list packages | findstr /i "com.catchingnow.icebox" > nul
if %errorlevel%==0 (
  echo 已安装 冰箱，执行激活命令...
  adb shell sh /sdcard/Android/data/com.catchingnow.icebox/files/start.sh || goto :fix
) else (
  echo 未安装 冰箱，跳过激活
)
echo.


:brevent
adb shell pm list packages | findstr /i "me.piebridge.brevent" > nul
if %errorlevel%==0 (
  echo 已安装 黑阈，执行激活命令...
  adb shell sh /data/data/me.piebridge.brevent/brevent.sh || goto :fix
) else (
  echo 未安装 黑阈，跳过激活
)
echo.

::小黑屋 和 权限狗 由于完整日志太长，以及可能因为版本问题激活失败，故做特殊处理

:stopapp
adb shell pm list packages | findstr /i "web1n.stopapp" > nul
if %errorlevel%==0 (
  echo 已安装 小黑屋，执行激活命令...
  adb shell sh /storage/emulated/0/Android/data/web1n.stopapp/files/starter.sh > nul
  if %errorlevel%==0 (
    echo 小黑屋 激活成功
    echo 鉴于小黑屋执行激活命令后无论是否成功都会显示完整日志，此处已隐藏回显
  ) else (
    echo 小黑屋 激活失败，重试并输出日志...
    adb shell sh /storage/emulated/0/Android/data/web1n.stopapp/files/starter.sh
    echo 注意：小黑屋可能无法正常激活
    adb shell dumpsys package web1n.stopapp | findstr /C:"versionCode"
    echo 若“versionCode”小于 297 请尝试升级应用版本
    pause
  )
) else (
  echo 未安装 小黑屋，跳过激活
)
echo.

:permissiondog
adb shell pm list packages | findstr /i "com.web1n.permissiondog" > nul
if %errorlevel%==0 (
  echo 已安装 权限狗，执行激活命令...
  adb shell sh /storage/emulated/0/Android/data/com.web1n.permissiondog/files/starter.sh > nul
  if %errorlevel%==0 (
    echo 权限狗 激活成功
    echo 鉴于权限狗执行激活命令后无论是否成功都会显示完整日志，此处已隐藏回显
  ) else (
    echo 权限狗 激活失败，重试并输出日志...
    adb shell sh /storage/emulated/0/Android/data/web1n.stopapp/files/starter.sh
    echo 注意：权限狗可能无法正常激活
    pause
  )
) else (
  echo 未安装 权限狗，跳过激活
)
echo.


:end
echo == 使用技巧 ==
echo 1. 若重新插拔 USB 数据线后,无线调试或 Shizuku 等停止，
echo 请尝试在开发者选项中将“选择 USB 配置”修改为“仅充电”，
echo 并开启“仅充电模式下允许 ADB 调试”或“USB调试（安全模式）”
echo.
echo 2. 若因为网络环境改变使得 Shizuku 服务停止，
echo 可在 Shizuku 中选择“通过无线调试启动”→“启动”→“5555”
echo.
echo == 全部执行完成，关闭 ADB 服务 ==
adb kill-server
echo 请按任意键退出...
pause > nul
exit


:fix
echo == 执行遇到错误，尝试修复 ==
echo 尝试关闭正在运行的其它 ADB.exe 进程防止冲突...
taskkill /F /IM adb.exe || echo 若提示没有找到进程说明无 ADB 冲突，可忽略
echo.
echo 尝试查看 ADB 默认端口（5037）是否被占用...
netstat -aon | findstr 5037
echo 若显示结果，则代表该端口可能已被其他进程占用。回显最右侧为该进程对应 PID，请在任务管理器中手动将其关闭
echo.
echo == 常见问题 ==
echo 1. 激活某个应用时若提示“no such file or directory”，请先在设备上启动一次该应用并选择对应的模式
echo 2. 若提示“adb server version (xxx) doesn't match this client (xxx); killing...”，请关闭计算机上正在运行的“手机助手”类软件，如“360手机助手”“鲁大师手机助手”等
echo.
set /p IGNORE_ERROR="请按回车键重新执行，或输入 1 忽略错误并重新执行："
if "%IGNORE_ERROR%" == "1" (
  cls
  goto :start
)
cls
goto :start