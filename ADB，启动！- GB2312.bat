@echo off
chcp 936 > nul
::������������볢��ʹ��UTF-8�汾
title ADB��������  v1.3  by ����Hakuin

:setVar
:: �������ӳٻ���������չ��
setlocal EnableDelayedExpansion
:: ��ʼ�����Դ������
set IGNORE_ERROR=0
:: ��ʼ��Ӧ�ü���ű�·��
set Act_Shizuku="/storage/emulated/0/Android/data/moe.shizuku.privileged.api/start.sh"
set Act_Scene="/sdcard/Android/data/com.omarea.vtools/up.sh"
set Act_IceBox="/sdcard/Android/data/com.catchingnow.icebox/files/start.sh"
set Act_Brevent="/data/data/me.piebridge.brevent/brevent.sh"
set Act_Stopapp="/storage/emulated/0/Android/data/web1n.stopapp/files/starter.sh"
set Act_PermissionDog="/storage/emulated/0/Android/data/com.web1n.permissiondog/files/starter.sh"

:check
echo = ��� ADB ���� =
adb version
if not %errorlevel%==0 (
  echo [����] δ�ҵ� ADB��Android Debug Bridge��������˽ű��Ƿ�� ADB ��ع��߷���ͬһ�ļ����£���ȷ����̨�����ӵ�� ADB ���л������ɲο�����̳̣�
  echo Android SDK ƽ̨���ߣ�https://googledownloads.cn/android/repository/platform-tools-latest-windows.zip
  echo ��ʹ�����������������ӣ����ز���ѹ 'platform-tools' �ļ��У�����.bat�ļ����ڸ��ļ����£��ٴ����д�.bat�ļ�
  pause
  exit
)
echo.

:start
echo = ���� ADB ���� =
adb start-server
if not %errorlevel%==0 (
  if %IGNORE_ERROR%==1 (
    echo [ǿ��ִ��] ��ѡ��ǿ��ִ��ģʽ�����Դ��󲢼���...
  )
  goto :fix
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
echo = �������ߵ��� =
adb tcpip 5555
if not %errorlevel%==0 (
  if %IGNORE_ERROR%==1 (
    echo [ǿ��ִ��] ��ѡ��ǿ��ִ��ģʽ�����Դ��󲢼���...
  )
  goto :fix
)
echo [ע��] ���ߵ������ú���һ�����գ������������������� ADB ��������
echo �ȴ���������...
adb wait-for-device
echo.

:force
if %IGNORE_ERROR%==1 (
  echo [ǿ��ִ��] ��ѡ��ǿ��ִ��ģʽ��ֱ��ִ��������������������...
  adb shell sh %Act_Shizuku% %Act_Scene% %Act_IceBox% %Act_Brevent% %Act_Stopapp% %Act_PermissionDog%
  goto :end
)


:shizuku
:: ����Ƿ�װ Shizuku
adb shell pm list packages | findstr /i "moe.shizuku.privileged.api" > nul
if %errorlevel%==0 (
  echo �Ѱ�װ Shizuku��ִ����������...
  adb shell sh %Act_Shizuku% || goto :fix
) else (
  echo δ��װ Shizuku����������
)
echo.


:scene
adb shell pm list packages | findstr /i "com.omarea.vtools" > nul
if %errorlevel%==0 (
  echo �Ѱ�װ Scene��ִ�м�������...
  adb shell sh %Act_Scene% || goto :fix
) else (
  echo δ��װ Scene����������
)
echo.


:icebox
adb shell pm list packages | findstr /i "com.catchingnow.icebox" > nul
if %errorlevel%==0 (
  echo �Ѱ�װ ���䣬ִ�м�������...
  adb shell sh %Act_IceBox% || goto :fix
) else (
  echo δ��װ ���䣬��������
)
echo.


:brevent
adb shell pm list packages | findstr /i "me.piebridge.brevent" > nul
if %errorlevel%==0 (
  echo �Ѱ�װ ���У�ִ�м�������...
  adb shell sh %Act_Brevent% || goto :fix
) else (
  echo δ��װ ���У���������
)
echo.

::С���� �� Ȩ�޹� ����������־̫�����Լ�������Ϊ�汾���⼤��ʧ�ܣ��������⴦��

:stopapp
adb shell pm list packages | findstr /i "web1n.stopapp" > nul
if %errorlevel%==0 (
  echo �Ѱ�װ С���ݣ�ִ�м�������...
  adb shell sh %Act_Stopapp% > nul
  if %errorlevel%==0 (
    echo С���� ����ɹ�
    echo ����С����ִ�м�������������Ƿ�ɹ�������ʾ������־���˴������ػ���
  ) else (
    echo С���� ����ʧ�ܣ����Բ������־...
    adb shell sh %Act_Stopapp%
    echo [ע��] С���ݿ����޷���������
    adb shell dumpsys package web1n.stopapp | findstr /C:"versionCode"
    echo ����versionCode��С�� 297 �볢�Ը���Ӧ�������°汾
    set /p IGNORE_ERROR="�밴�س�������ִ�У������� 0 �򿪳����Զ��޸����ܣ�"
    if "%IGNORE_ERROR%" == "0" (
      goto :fix
    )
  )
) else (
  echo δ��װ С���ݣ���������
)
echo.

:permissiondog
adb shell pm list packages | findstr /i "com.web1n.permissiondog" > nul
if %errorlevel%==0 (
  echo �Ѱ�װ Ȩ�޹���ִ�м�������...
  adb shell sh %Act_PermissionDog% > nul
  if %errorlevel%==0 (
    echo Ȩ�޹� ����ɹ�
    echo ����Ȩ�޹�ִ�м�������������Ƿ�ɹ�������ʾ������־���˴������ػ���
  ) else (
    echo Ȩ�޹� ����ʧ�ܣ����Բ������־...
    adb shell sh %Act_PermissionDog%
    echo [ע��] Ȩ�޹������޷���������
    set /p IGNORE_ERROR="�밴�س�������ִ�У������� 0 �򿪳����Զ��޸����ܣ�"
    if "%IGNORE_ERROR%" == "0" (
      goto :fix
    )
  )
) else (
  echo δ��װ Ȩ�޹�����������
)
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
echo ����Ҫ���� Dhizuku ����Ҫ�豸������Ȩ�޵�Ӧ�ã��볢����֮�С�
echo.
echo.
echo ============ SUCCESS! ============
echo == ȫ��ִ����ɣ��ر� ADB ���� ==
adb kill-server
echo �밴������˳�...
pause > nul
exit


:fix
echo == ִ���������󣬳����޸� ==
echo ���Թر��������е����� ADB.exe ���̷�ֹ��ͻ...
taskkill /F /IM adb.exe || echo ����ʾû���ҵ�����˵���� ADB ���̳�ͻ�����Լ���
echo.

echo ��� ADB Ĭ�϶˿ڣ�5037���Ƿ�ռ��...
netstat -aon | findstr 5037
if %errorlevel%==0 (
  echo [ע��] 5037 �˿ڿ����ѱ���������ռ��
  echo [ע��] ��رռ�������������еġ��ֻ����֡���������硰360�ֻ����֡���³��ʦ�ֻ����֡���
  echo [ע��] ������׼ȷ��λ���̣��Ϸ��������Ҳ�Ϊ�ý��̶�Ӧ PID������������������ֶ�����ر�
)
echo.

echo ���Ӧ�ü���ű��Ƿ����...
set "NOT_FOUND="
adb shell ls "%Act_Shizuku%" || set "NOT_FOUND=!NOT_FOUND! Shizuku"
adb shell ls "%Act_Scene%" || set "NOT_FOUND=!NOT_FOUND! Scene"
adb shell ls "%Act_IceBox%" || set "NOT_FOUND=!NOT_FOUND! ����"
adb shell ls "%Act_Brevent%" || set "NOT_FOUND=!NOT_FOUND! ����"
adb shell ls "%Act_Stopapp%" || set "NOT_FOUND=!NOT_FOUND! С����"
adb shell ls "%Act_PermissionDog%" || set "NOT_FOUND=!NOT_FOUND! Ȩ�޹�"
if not "%NOT_FOUND%" == "" (
  echo [ע��] ����Ӧ��δ�ҵ�����ű���%NOT_FOUND%
  echo [ע��] �볢�����豸������һ������Ӧ�ã���������ģʽ����Ϊ ADB ģʽ
  echo [ע��] ����δ������⣬�볢�Ը�������Ӧ�������°汾
)
echo.

echo == �������� ==
echo 1. ����ĳ��Ӧ��ʱ����ʾ��no such file or directory�����������豸������һ�θ�Ӧ�ò�ѡ���Ӧ��ģʽ
echo 2. ����ʾ��adb server version (xxx) doesn't match this client (xxx); killing...������رռ�������������еġ��ֻ����֡���������硰360�ֻ����֡���³��ʦ�ֻ����֡���
echo.
set /p IGNORE_ERROR="�밴�س�������ִ�У������� 1 ���Դ�������ִ�У�"
if "%IGNORE_ERROR%" == "1" (
  cls
  goto :start
)
cls
goto :start