@echo off
chcp 936
::������������볢��ʹ��UTF-8�汾
cls
title ADB��������  by ����Hakuin

:check
echo = ��� ADB ����=
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
adb start-server||goto fix
echo �ȴ��豸����...
echo ��ʹ�� USB �����������豸��������Ҫ���豸���ֶ����� USB ����
:: ע�⣺�������Ӵ��� Android 4.2.2��API ���� 17������߰汾���豸ʱ��ϵͳ����ʾһ���Ի���ѯ�����Ƿ��������ͨ���˼�������е��Ե� RSA ��Կ��
:: ���ְ�ȫ���ƿ��Ա����û��豸����Ϊ������ȷ���û�ֻ�����ܹ������豸��ȷ�϶Ի��������²���ִ�� USB ���Ժ����� adb ���
adb wait-for-device
echo.
echo = �������豸 =
adb devices -l

echo = �������ߵ��� =
adb tcpip 5555
echo ���ߵ������ú���һ�����գ���ע�ⲻҪ������������������ ADB ��������
echo �ȴ���������...
adb wait-for-device
echo.


:Shizuku
adb shell pm list packages | findstr /i "moe.shizuku.privileged.api" > nul
if %errorlevel%==0 (
echo �Ѱ�װ Shizuku��ִ����������...
  adb shell sh /storage/emulated/0/Android/data/moe.shizuku.privileged.api/start.sh||goto fix
) else (
  echo δ��װ Shizuku����������
)
echo.


:Scene
adb shell pm list packages | findstr /i "com.omarea.vtools" > nul
if %errorlevel%==0 (
echo �Ѱ�װ Scene��ִ�м�������...
  adb shell sh /sdcard/Android/data/com.omarea.vtools/up.sh||goto fix
) else (
  echo δ��װ Scene����������
)
echo.


:icebox
adb shell pm list packages | findstr /i "com.catchingnow.icebox" > nul
if %errorlevel%==0 (
echo �Ѱ�װ ���䣬ִ�м�������...
  adb shell sh /sdcard/Android/data/com.catchingnow.icebox/files/start.sh||goto fix
) else (
  echo δ��װ ���䣬��������
)
echo.


:brevent
adb shell pm list packages | findstr /i "me.piebridge.brevent" > nul
if %errorlevel%==0 (
echo �Ѱ�װ ���У�ִ�м�������...
  adb shell sh /data/data/me.piebridge.brevent/brevent.sh||goto fix
) else (
  echo δ��װ ���У���������
)
echo.

echo ȫ��ִ����ɣ��ر� ADB ����
adb kill-server
pause
exit



:fix
echo == ִ���������󣬳����޸�ing ==
echo ���Թر��������е�����ADB���̷�ֹ��ͻ...
taskkill /F /IM adb.exe||echo ����ʾû���ҵ�����˵����ADB��ͻ���ɺ���
echo.
echo ���Բ鿴 ADB Ĭ�϶˿ڣ�5037���Ƿ�ռ��...
netstat -aon | findstr 5037
echo ����ʾ����������ö˿��ѱ���������ռ�á��������Ҳ�Ϊ�ý��̶�Ӧ PID������������������ֶ�����ر�
echo.
echo == �������� ==
echo 1. ����ʾ��'adb' �����ڲ����ⲿ����...������ȷ���˽ű��Ƿ�� ADB ��ع��߷���ͬһ�ļ����£���ȷ����ļ�����Ƿ���ADBִ�л������ɲο�����̳̣�
echo 2. ����ĳ��Ӧ��ʱ����ʾ��no such file or directory�����������豸������һ�θ�Ӧ��
echo 3. ����ʾ��adb server version (7601) doesn't match this client (41); killing...������رռ�������������еġ��ֻ����֡���������硰360�ֻ����֡���³��ʦ�ֻ����֡���
echo.
pause
cls
goto start
