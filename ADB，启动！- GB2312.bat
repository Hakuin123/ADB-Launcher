@echo off
chcp 936 > nul
:: ������������볢��ʹ�� UTF-8 �汾
title ADB��������  v1.6  by ����Hakuin

:setVar
:: �������ӳٻ���������չ��
setlocal EnableDelayedExpansion
:: ��ʼ�����Դ������
set IGNORE_ERROR=0
:: ��ʼ��Ӧ�ü���ű�·��
set Act_Shizuku="/storage/emulated/0/Android/data/moe.shizuku.privileged.api/start.sh"
set Act_Scene="/sdcard/Android/data/com.omarea.vtools/up.sh"
set Act_Scene_2="/data/user/0/com.omarea.vtools/files/up.sh"
set Act_IceBox="/sdcard/Android/data/com.catchingnow.icebox/files/start.sh"
set Act_Brevent="/data/data/me.piebridge.brevent/brevent.sh"
set Act_Stopapp="/storage/emulated/0/Android/data/web1n.stopapp/files/starter.sh"
set Act_PermissionDog="/storage/emulated/0/Android/data/com.web1n.permissiondog/files/starter.sh"

:check
echo = ��� ADB ���� =
adb version
if not %errorlevel% == 0 (
  echo [����] δ�ҵ� ADB��Android Debug Bridge��������˽ű��Ƿ�� ADB ��ع��߷���ͬһ�ļ����£���ȷ����̨�����ӵ�� ADB ���л������ɲο�����̳̣�
  echo [��ʾ] Android SDK ƽ̨���ߣ�https://googledownloads.cn/android/repository/platform-tools-latest-windows.zip
  echo [��ʾ] ��ʹ�����������������ӣ����ز���ѹ 'platform-tools' �ļ��У�����.bat�ļ����ڸ��ļ����£��ٴ����д�.bat�ļ�
  pause
  exit
)
echo.

:start
echo = ���� ADB ���� =
adb start-server
if not %errorlevel% == 0 (
  if %IGNORE_ERROR% == 1 echo [ǿ��ִ��] ��ѡ��ǿ��ִ��ģʽ�����Դ��󲢼���...
  goto :fix-adb
)
echo �ȴ��豸����...
echo [��ʾ] ��ʹ�� USB �����������豸��������Ҫ���豸���ֶ����� USB ����
:: ע�⣺�������Ӵ��� Android 4.2.2��API ���� 17������߰汾���豸ʱ��ϵͳ����ʾһ���Ի���ѯ�����Ƿ��������ͨ���˼�������е��Ե� RSA ��Կ��
:: ���ְ�ȫ���ƿ��Ա����û��豸����Ϊ������ȷ���û�ֻ�����ܹ������豸��ȷ�϶Ի��������²���ִ�� USB ���Ժ����� adb ���
adb wait-for-device
echo.
echo = �������豸 =
adb devices -l

:wireless
echo = ���������ߵ��ԡ� =
adb tcpip 5555
if not %errorlevel% == 0 (
  if %IGNORE_ERROR% == 1 echo [ǿ��ִ��] ��ѡ��ǿ��ִ��ģʽ�����Դ��󲢼���...
  goto :fix-adb
)
echo [ע��] �˷�ʽ���ú���һ�����գ������������������� ADB ��������
echo �ȴ��Զ���������...�������豸��Ҫ�ֶ��������ӣ�
adb wait-for-device
echo.

:force
if %IGNORE_ERROR% == 1 (
  echo [ǿ��ִ��] ��ѡ��ǿ��ִ��ģʽ��ֱ��ִ��������������������...
  adb shell sh %Act_Shizuku% %Act_Scene% %Act_IceBox% %Act_Brevent% %Act_Stopapp% %Act_PermissionDog%
  goto :end
)


:shizuku
:: ����Ƿ�װ Shizuku
adb shell pm list packages | findstr /i "moe.shizuku.privileged.api" > nul
if %errorlevel% == 0 (
  echo �Ѱ�װ Shizuku��ִ����������...
  adb shell sh %Act_Shizuku% || goto :fix-app
) else echo δ��װ Shizuku����������
echo.


:scene
adb shell pm list packages | findstr /i "com.omarea.vtools" > nul
if %errorlevel% == 0 (
  echo �Ѱ�װ Scene��ִ�м�������...
  adb shell sh %Act_Scene% || adb shell sh %Act_Scene_2% || goto :fix-app
) else echo δ��װ Scene����������
echo.


:icebox
adb shell pm list packages | findstr /i "com.catchingnow.icebox" > nul
if %errorlevel% == 0 (
  echo �Ѱ�װ ���䣬ִ�м�������...
  adb shell sh %Act_IceBox% || goto :fix-app
) else echo δ��װ ���䣬��������
echo.


:brevent
adb shell pm list packages | findstr /i "me.piebridge.brevent" > nul
if %errorlevel% == 0 (
  echo �Ѱ�װ ���У�ִ�м�������...
  adb shell sh %Act_Brevent% || goto :fix-app
) else echo δ��װ ���У���������
echo.

::С���� �� Ȩ�޹� ����������־̫�����Լ�������Ϊ�汾���⼤��ʧ�ܣ��������⴦��

:stopapp
adb shell pm list packages | findstr /i "web1n.stopapp" > nul
if %errorlevel% == 0 (
  echo �Ѱ�װ С���ݣ�ִ�м�������...
  adb shell sh %Act_Stopapp% > nul
  if %errorlevel% == 0 (
    echo С���� ����ɹ�
    echo ����С����ִ�м�������������Ƿ�ɹ�������ʾ������־���˴������ػ���
  ) else (
    echo С���� ����ʧ�ܣ����Բ������־...
    adb shell sh %Act_Stopapp%
    echo [ע��] С���ݿ����޷���������
    set /p IGNORE_ERROR="[��ʾ] �밴�س�������ִ�У������� 0 �򿪳����Զ��޸����ܣ�"
    if "%IGNORE_ERROR%" == "0" (
      goto :fix-app
    )
  )
) else echo δ��װ С���ݣ���������
echo.

:permissiondog
adb shell pm list packages | findstr /i "com.web1n.permissiondog" > nul
if %errorlevel% == 0 (
  echo �Ѱ�װ Ȩ�޹���ִ�м�������...
  adb shell sh %Act_PermissionDog% > nul
  if %errorlevel% == 0 (
    echo Ȩ�޹� ����ɹ�
    echo ����Ȩ�޹�ִ�м�������������Ƿ�ɹ�������ʾ������־���˴������ػ���
  ) else (
    echo Ȩ�޹� ����ʧ�ܣ����Բ������־...
    adb shell sh %Act_PermissionDog%
    echo [ע��] Ȩ�޹������޷���������
    set /p IGNORE_ERROR="[��ʾ] �밴�س�������ִ�У������� 0 �򿪳����Զ��޸����ܣ�"
    if "%IGNORE_ERROR%" == "0" (
      goto :fix-app
    )
  )
) else echo δ��װ Ȩ�޹�����������
echo.


:end
echo == ʹ�ü��� ==
echo 1. �����²�� USB �����ߺ�,���ߵ��Ի� Shizuku ��ֹͣ��
echo �볢���ڿ�����ѡ���н���ѡ�� USB ���á��޸�Ϊ������硱��
echo �������������ģʽ������ ADB ���ԡ���USB���ԣ���ȫģʽ����
echo.
echo 2. ����Ϊ���绷���ı�ʹ�� Shizuku ����ֹͣ��
echo ���� Shizuku ��ѡ��ͨ�����ߵ�����������������������5555��
echo.
echo ����Ҫ���� Dhizuku ����Ҫ�豸������Ȩ�޵�Ӧ�ã��볢��ʹ�á���֮�С�
echo.

for /f "usebackq" %%a in (`adb shell getprop ro.build.version.release`) do (
  if %%a GEQ 11 (
    echo �� Android 11 ��ʼ������ͨ�����ߵ���ֱ������ Shizuku ���������Ӽ����
    echo ����ǰ�豸�� Android ϵͳ�汾��Ϊ %%a������ Shizuku ��ͨ�����ߵ������������˽�����
  )
)

echo.
echo.
echo ============ SUCCESS! ============
echo == ȫ��ִ����ɣ��ر� ADB ���� ==
adb kill-server
echo [��ʾ] �밴������˳�...
pause > nul
exit


:fix-adb
echo == ִ����������ADB���������޸� ==
echo ���Թر��������е����� ADB.exe ���̷�ֹ��ͻ...
taskkill /F /IM adb.exe || echo ����ʾû���ҵ�����˵���� ADB ���̳�ͻ�����Լ���
echo.
echo ��� ADB �˿�ռ�����...
for /f "tokens=5 delims= " %%a in ('netstat -ano ^| findstr :5037 ^| findstr "LISTENING"') do (
  set process_pid=%%a
  if not !process_pid! == 0 (
    echo [ע��] ��⵽�н���ռ�� ADB Ĭ�϶˿ڣ�5037�����ý��� PID Ϊ !process_pid!
    for /f "tokens=1*" %%b in ('tasklist /NH /FI "PID eq !process_pid!"') do (
      set "process_name=%%b"
      echo [ע��] ռ�ö˿ڵĽ�����Ϊ��!process_name!
    )
    echo [��ʾ] �볢���ֶ��رոý��̶�Ӧ�ĳ��򣬻����������ǿ�ƽ����ý���
    pause
    taskkill /F /PID !process_pid!
    if !errorlevel! == 0 (
      echo ��ǿ�ƽ���ռ�� 5037 �˿ڵĽ��̣��볢������ִ��
    ) else (
      echo [ע��] ǿ�ƽ�������ʧ�ܣ��볢���ֶ��رոý��̶�Ӧ�ĳ���Ȼ������ִ��
    )
  )
)
echo.
echo [��ʾ] ������ʱ��ʾ��adb server version (xxx) doesn't match this client (xxx); killing...������رռ�������������еġ��ֻ����֡���������硰360�ֻ����֡���³��ʦ�ֻ����֡���
goto :restart

:fix-app
echo == ִ����������Ӧ�ã��������޸� ==
echo ���Ӧ�ü���ű��Ƿ����...
set "NOT_FOUND="
adb shell ls "%Act_Shizuku%" > nul || set "NOT_FOUND=!NOT_FOUND! Shizuku"
adb shell ls "%Act_Scene%" > nul || adb shell ls "%Act_Scene%" > nul || set "NOT_FOUND=!NOT_FOUND! Scene"
adb shell ls "%Act_IceBox%" > nul || set "NOT_FOUND=!NOT_FOUND! ����"
adb shell ls "%Act_Brevent%" > nul || set "NOT_FOUND=!NOT_FOUND! ����"
adb shell ls "%Act_Stopapp%" > nul || set "NOT_FOUND=!NOT_FOUND! С����"
adb shell ls "%Act_PermissionDog%" > nul || set "NOT_FOUND=!NOT_FOUND! Ȩ�޹�"
if not "%NOT_FOUND%" == "" (
  echo [ע��] ����Ӧ��δ�ҵ�����ű���%NOT_FOUND% ����δ��װ����ԣ�
  echo [ע��] �볢�����豸������һ������Ӧ�ã���������ģʽ����Ϊ ADB ģʽ
  echo [ע��] ����δ������⣬�볢�Ը�������Ӧ�������°汾�����־ɰ漤����ܳ�������
)
goto :restart

:restart
echo.
echo [��ʾ] �Զ��޸���ɣ���ѡ����һ������...
echo �س��� - ����ִ��
echo ���� 1 - ����ִ���Һ��Դ���ǿ��ִ��ģʽ��
echo ���� 2 - �����޸� ADB ����
echo ���� 3 - �����޸�Ӧ�ô���
set /p IGNORE_ERROR="[��ʾ] ��ѡ��"
if "%IGNORE_ERROR%" == "1" cls & goto :start
if "%IGNORE_ERROR%" == "2" goto :fix-adb
if "%IGNORE_ERROR%" == "3" goto :fix-app
cls
goto :start