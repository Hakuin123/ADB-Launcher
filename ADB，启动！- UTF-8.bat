@echo off
chcp 65001 > nul
:: 如果出现乱码请尝试使用 GB2312 版本
title ADB，启动！  v1.5  by 白隐Hakuin

:setVar
:: 开启“延迟环境变量扩展”
setlocal EnableDelayedExpansion
:: 初始化忽略错误变量
set IGNORE_ERROR=0
:: 初始化应用激活脚本路径
set Act_Shizuku="/storage/emulated/0/Android/data/moe.shizuku.privileged.api/start.sh"
set Act_Scene="/sdcard/Android/data/com.omarea.vtools/up.sh"
set Act_IceBox="/sdcard/Android/data/com.catchingnow.icebox/files/start.sh"
set Act_Brevent="/data/data/me.piebridge.brevent/brevent.sh"
set Act_Stopapp="/storage/emulated/0/Android/data/web1n.stopapp/files/starter.sh"
set Act_PermissionDog="/storage/emulated/0/Android/data/com.web1n.permissiondog/files/starter.sh"

:check
echo = 检查 ADB 环境 =
adb version
if not %errorlevel% == 0 (
  echo [错误] 未找到 ADB（Android Debug Bridge）！请检查此脚本是否和 ADB 相关工具放在同一文件夹下，或确保这台计算机拥有 ADB 运行环境（可参考网络教程）
  echo [提示] Android SDK 平台工具：https://googledownloads.cn/android/repository/platform-tools-latest-windows.zip
  echo [提示] 请使用浏览器打开上面的链接，下载并解压 'platform-tools' 文件夹，将此.bat文件放在该文件夹下，再次运行此.bat文件
  pause
  exit
)
echo.

:start
echo = 启动 ADB 服务 =
adb start-server
if not %errorlevel% == 0 (
  if %IGNORE_ERROR% == 1 (
    echo [强制执行] 已选择强制执行模式，忽略错误并继续...
  )
  goto :fix-adb
)
echo 等待设备连接...
echo [提示] 请使用 USB 数据线连接设备，可能需要在设备上手动允许 USB 调试
:: 注意：当您连接搭载 Android 4.2.2（API 级别 17）或更高版本的设备时，系统会显示一个对话框，询问您是否接受允许通过此计算机进行调试的 RSA 密钥。
:: 这种安全机制可以保护用户设备，因为它可以确保用户只有在能够解锁设备并确认对话框的情况下才能执行 USB 调试和其他 adb 命令。
adb wait-for-device
echo.
echo = 已连接设备 =
adb devices -l

:wireless
echo = 启动无线调试 =
adb tcpip 5555
if not %errorlevel% == 0 (
  if %IGNORE_ERROR% == 1 (
    echo [强制执行] 已选择强制执行模式，忽略错误并继续...
  )
  goto :fix-adb
)
echo [注意] 无线调试启用后有一定风险，请勿允许来历不明的 ADB 调试请求
echo 等待自动重新连接...
adb wait-for-device
echo.

:force
if %IGNORE_ERROR% == 1 (
  echo [强制执行] 已选择强制执行模式，直接执行所有启动及激活命令...
  adb shell sh %Act_Shizuku% %Act_Scene% %Act_IceBox% %Act_Brevent% %Act_Stopapp% %Act_PermissionDog%
  goto :end
)


:shizuku
:: 检查是否安装 Shizuku
adb shell pm list packages | findstr /i "moe.shizuku.privileged.api" > nul
if %errorlevel% == 0 (
  echo 已安装 Shizuku，执行启动命令...
  adb shell sh %Act_Shizuku% || goto :fix-app
) else (
  echo 未安装 Shizuku，跳过启动
)
echo.


:scene
adb shell pm list packages | findstr /i "com.omarea.vtools" > nul
if %errorlevel% == 0 (
  echo 已安装 Scene，执行激活命令...
  adb shell sh %Act_Scene% || goto :fix-app
) else (
  echo 未安装 Scene，跳过激活
)
echo.


:icebox
adb shell pm list packages | findstr /i "com.catchingnow.icebox" > nul
if %errorlevel% == 0 (
  echo 已安装 冰箱，执行激活命令...
  adb shell sh %Act_IceBox% || goto :fix-app
) else (
  echo 未安装 冰箱，跳过激活
)
echo.


:brevent
adb shell pm list packages | findstr /i "me.piebridge.brevent" > nul
if %errorlevel% == 0 (
  echo 已安装 黑阈，执行激活命令...
  adb shell sh %Act_Brevent% || goto :fix-app
) else (
  echo 未安装 黑阈，跳过激活
)
echo.

::小黑屋 和 权限狗 由于完整日志太长，以及可能因为版本问题激活失败，故做特殊处理

:stopapp
adb shell pm list packages | findstr /i "web1n.stopapp" > nul
if %errorlevel% == 0 (
  echo 已安装 小黑屋，执行激活命令...
  adb shell sh %Act_Stopapp% > nul
  if %errorlevel% == 0 (
    echo 小黑屋 激活成功
    echo 鉴于小黑屋执行激活命令后无论是否成功都会显示完整日志，此处已隐藏回显
  ) else (
    echo 小黑屋 激活失败，重试并输出日志...
    adb shell sh %Act_Stopapp%
    echo [注意] 小黑屋可能无法正常激活
    set /p IGNORE_ERROR="[提示] 请按回车键继续执行，或输入 0 打开常规自动修复功能："
    if "%IGNORE_ERROR%" == "0" (
      goto :fix-app
    )
  )
) else (
  echo 未安装 小黑屋，跳过激活
)
echo.

:permissiondog
adb shell pm list packages | findstr /i "com.web1n.permissiondog" > nul
if %errorlevel% == 0 (
  echo 已安装 权限狗，执行激活命令...
  adb shell sh %Act_PermissionDog% > nul
  if %errorlevel% == 0 (
    echo 权限狗 激活成功
    echo 鉴于权限狗执行激活命令后无论是否成功都会显示完整日志，此处已隐藏回显
  ) else (
    echo 权限狗 激活失败，重试并输出日志...
    adb shell sh %Act_PermissionDog%
    echo [注意] 权限狗可能无法正常激活
    set /p IGNORE_ERROR="[提示] 请按回车键继续执行，或输入 0 打开常规自动修复功能："
    if "%IGNORE_ERROR%" == "0" (
      goto :fix-app
    )
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
echo 如需要激活 Dhizuku 等需要设备所有者权限的应用，请尝试秋之盒。
echo.
echo.
echo ============ SUCCESS! ============
echo == 全部执行完成，关闭 ADB 服务 ==
adb kill-server
echo [提示] 请按任意键退出...
pause > nul
exit


:fix-adb
echo == 执行遇到错误（ADB），尝试修复 ==
echo 尝试关闭正在运行的所有 ADB.exe 进程防止冲突...
taskkill /F /IM adb.exe || echo 若提示没有找到进程说明无 ADB 进程冲突，忽略即可
echo.
echo 检查 ADB 端口占用情况...
for /f "tokens=5 delims= " %%a in ('netstat -ano ^| findstr :5037 ^| findstr "LISTENING"') do (
  set process_pid=%%a
  if not !process_pid! == 0 (
    echo [注意] 检测到有进程占用 ADB 默认端口（5037），该进程 PID 为 !process_pid!
    for /f "tokens=1*" %%b in ('tasklist /NH /FI "PID eq !process_pid!"') do (
      set "process_name=%%b"
      echo [注意] 占用端口的进程名为：!process_name!
    )
    echo 尝试强制结束该进程...
    taskkill /F /PID !process_pid!
    if !errorlevel! == 0 (
      echo 已强制结束占用 5037 端口的进程，请尝试重新执行
    ) else (
      echo [注意] 强制结束进程失败，请尝试手动关闭该进程对应的程序，然后重新执行
    )
  )
)
echo.
echo [提示] 若运行时提示“adb server version (xxx) doesn't match this client (xxx); killing...”，请关闭计算机上正在运行的“手机助手”类软件，如“360手机助手”“鲁大师手机助手”等
goto :restart

:fix-app
echo == 执行遇到错误（应用），尝试修复 ==
echo 检查应用激活脚本是否存在...
set "NOT_FOUND="
adb shell ls "%Act_Shizuku%" > nul || set "NOT_FOUND=!NOT_FOUND! Shizuku"
adb shell ls "%Act_Scene%" > nul || set "NOT_FOUND=!NOT_FOUND! Scene"
adb shell ls "%Act_IceBox%" > nul || set "NOT_FOUND=!NOT_FOUND! 冰箱"
adb shell ls "%Act_Brevent%" > nul || set "NOT_FOUND=!NOT_FOUND! 黑阈"
adb shell ls "%Act_Stopapp%" > nul || set "NOT_FOUND=!NOT_FOUND! 小黑屋"
adb shell ls "%Act_PermissionDog%" > nul || set "NOT_FOUND=!NOT_FOUND! 权限狗"
if not "%NOT_FOUND%" == "" (
  echo [注意] 下列应用未找到激活脚本：%NOT_FOUND% （若未安装请忽略）
  echo [注意] 请尝试在设备上启动一次上述应用，并将运行模式设置为 ADB 模式
  echo [注意] 若仍未解决问题，请尝试更新上述应用至最新版本，部分旧版激活可能出现问题
)
goto :restart

:restart
echo.
set /p IGNORE_ERROR="[提示] 请按回车键重新执行，或输入 1 进入忽略错误并重新执行（强制执行模式）："
if "%IGNORE_ERROR%" == "1" (
  cls
  goto :start
)
cls
goto :start