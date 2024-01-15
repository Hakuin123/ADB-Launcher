@echo off
chcp 936 > nul
::������������볢��ʹ��UTF-8�汾
title ADB��������  v1.2  by ����Hakuin
:: ��ʼ�����Դ������
set IGNORE_ERROR=0

:check
echo = ��� ADB ���� =
adb version
if not %errorlevel%==0 (
  echo δ�ҵ� ADB��Android Debug Bridge������ȷ����̨�����ӵ�� ADB ���л������ɲο�����̳̣�
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
echo ��ʹ�� USB �����������豸��������Ҫ���豸���ֶ����� USB ����
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
echo ���ߵ������ú���һ�����գ���ע�ⲻҪ������������������ ADB ��������
echo �ȴ���������...
adb wait-for-device
echo.

:force
if %IGNORE_ERROR%==1 (
  echo [ǿ��ִ��] ��ѡ��ǿ��ִ��ģʽ��ֱ��ִ��������������������...
  adb shell sh /storage/emulated/0/Android/data/moe.shizuku.privileged.api/start.sh
  adb shell sh /sdcard/Android/data/com.omarea.vtools/up.sh
  adb shell sh /sdcard/Android/data/com.catchingnow.icebox/files/start.sh
  adb shell sh /storage/emulated/0/Android/data/web1n.stopapp/files/starter.sh
  adb shell sh /storage/emulated/0/Android/data/com.web1n.permissiondog/files/starter.sh
  goto :end
)


:shizuku
:: ����Ƿ�װ Shizuku
adb shell pm list packages | findstr /i "moe.shizuku.privileged.api" > nul
if %errorlevel%==0 (
  echo �Ѱ�װ Shizuku��ִ����������...
  adb shell sh /storage/emulated/0/Android/data/moe.shizuku.privileged.api/start.sh || goto :fix
) else (
  echo δ��װ Shizuku����������
)
echo.

goto fix

:scene
adb shell pm list packages | findstr /i "com.omarea.vtools" > nul
if %errorlevel%==0 (
  echo �Ѱ�װ Scene��ִ�м�������...
  adb shell sh /sdcard/Android/data/com.omarea.vtools/up.sh || goto :fix
) else (
  echo δ��װ Scene����������
)
echo.


:icebox
adb shell pm list packages | findstr /i "com.catchingnow.icebox" > nul
if %errorlevel%==0 (
  echo �Ѱ�װ ���䣬ִ�м�������...
  adb shell sh /sdcard/Android/data/com.catchingnow.icebox/files/start.sh || goto :fix
) else (
  echo δ��װ ���䣬��������
)
echo.


:brevent
adb shell pm list packages | findstr /i "me.piebridge.brevent" > nul
if %errorlevel%==0 (
  echo �Ѱ�װ ���У�ִ�м�������...
  adb shell sh /data/data/me.piebridge.brevent/brevent.sh || goto :fix
) else (
  echo δ��װ ���У���������
)
echo.

::С���� �� Ȩ�޹� ����������־̫�����Լ�������Ϊ�汾���⼤��ʧ�ܣ��������⴦��

:stopapp
adb shell pm list packages | findstr /i "web1n.stopapp" > nul
if %errorlevel%==0 (
  echo �Ѱ�װ С���ݣ�ִ�м�������...
  adb shell sh /storage/emulated/0/Android/data/web1n.stopapp/files/starter.sh > nul
  if %errorlevel%==0 (
    echo С���� ����ɹ�
    echo ����С����ִ�м�������������Ƿ�ɹ�������ʾ������־���˴������ػ���
  ) else (
    echo С���� ����ʧ�ܣ����Բ������־...
    adb shell sh /storage/emulated/0/Android/data/web1n.stopapp/files/starter.sh
    echo ע�⣺С���ݿ����޷���������
    adb shell dumpsys package web1n.stopapp | findstr /C:"versionCode"
    echo ����versionCode��С�� 297 �볢������Ӧ�ð汾
    pause
  )
) else (
  echo δ��װ С���ݣ���������
)
echo.

:permissiondog
adb shell pm list packages | findstr /i "com.web1n.permissiondog" > nul
if %errorlevel%==0 (
  echo �Ѱ�װ Ȩ�޹���ִ�м�������...
  adb shell sh /storage/emulated/0/Android/data/com.web1n.permissiondog/files/starter.sh > nul
  if %errorlevel%==0 (
    echo Ȩ�޹� ����ɹ�
    echo ����Ȩ�޹�ִ�м�������������Ƿ�ɹ�������ʾ������־���˴������ػ���
  ) else (
    echo Ȩ�޹� ����ʧ�ܣ����Բ������־...
    adb shell sh /storage/emulated/0/Android/data/web1n.stopapp/files/starter.sh
    echo ע�⣺Ȩ�޹������޷���������
    pause
  )
) else (
  echo δ��װ Ȩ�޹�����������
)
echo.


:end
echo ȫ��ִ����ɣ��ر� ADB ����
adb kill-server
pause
exit



:fix
echo == ִ���������󣬳����޸� ==
echo ���Թر��������е����� ADB ���̷�ֹ��ͻ...
taskkill /F /IM adb.exe || echo ����ʾû���ҵ�����˵���� ADB ��ͻ���ɺ���
echo.
echo ���Բ鿴 ADB Ĭ�϶˿ڣ�5037���Ƿ�ռ��...
netstat -aon | findstr 5037
echo ����ʾ����������ö˿ڿ����ѱ���������ռ�á��������Ҳ�Ϊ�ý��̶�Ӧ PID������������������ֶ�����ر�
echo.
echo == �������� ==
echo 1. ����ʾ��'adb' �����ڲ����ⲿ����...������ȷ���˽ű��Ƿ�� ADB ��ع��߷���ͬһ�ļ����£���ȷ����ļ�����Ƿ��� ADB ִ�л������ɲο�����̳̣�
echo 2. ����ĳ��Ӧ��ʱ����ʾ��no such file or directory�����������豸������һ�θ�Ӧ�ò�ѡ���Ӧ��ģʽ
echo 3. ����ʾ��adb server version (xxx) doesn't match this client (xxx); killing...������رռ�������������еġ��ֻ����֡���������硰360�ֻ����֡���³��ʦ�ֻ����֡���
echo.
set /p IGNORE_ERROR="�밴�س�������ִ�У������� 1 ���Դ�������ִ�У�"
if "%IGNORE_ERROR%" == "1" (
  cls
  goto :start
)
cls
goto :start

