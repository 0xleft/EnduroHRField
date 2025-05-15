@echo off

REM IF "%~1"=="-FIXED_CTRL_C" (
REM    REM Remove the -FIXED_CTRL_C parameter
REM    SHIFT
REM ) ELSE (
REM    REM Run the batch with <NUL and -FIXED_CTRL_C
REM    CALL <NUL %0 -FIXED_CTRL_C %*
REM    GOTO :EOF
REM )

set SDK_PATH=C:\Users\adoma\AppData\Roaming\Garmin\ConnectIQ\Sdks\connectiq-sdk-win-8.1.1-2025-03-27-66dae750f

echo Start Simulator Application
start "Simulator" %SDK_PATH%\bin\simulator.exe

REM Low Mem Devices
echo ----------------------------------------
echo Running Simulator on low-memory devices
echo ----------------------------------------

FOR %%d IN (
    edge1030
    edge1050
    edge530
    edge540
    edge840
) DO (
  CALL :RUN_SIMULATOR "%%d"
)

GOTO :eof

:RUN_SIMULATOR
echo.
echo %~1
echo  + Compile
start %1 java -Xms1g -Dfile.encoding=UTF-8 -Dapple.awt.UIElement=true -jar %SDK_PATH%\bin\monkeybrains.jar -o bin\EnduroHRField.prg -f f:\projects\EnduroHRField\monkey.jungle -y c:\Users\adoma\.garmin\developer_key -d %1 -w

echo  + Run
start %1 %SDK_PATH%\bin\monkeydo.bat bin\EnduroHRField.prg %1

pause

tasklist /FI "IMAGENAME eq Simulator.exe" 2>NUL | find /I /N "Simulator">NUL
if errorlevel 1 (
  echo Restart Simulator Application
  start "Simulator" %SDK_PATH%\bin\simulator.exe
  GOTO RUN_SIMULATOR %1
)