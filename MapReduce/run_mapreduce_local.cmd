@echo off
setlocal

set ROOT=%~dp0..
set DATA=%ROOT%\data\flights.csv
set BUILD=%ROOT%\MapReduce\build

if exist "%BUILD%\classes" rmdir /s /q "%BUILD%\classes"
mkdir "%BUILD%\classes"

for /f "delims=" %%i in ('C:\hadoop\bin\hadoop.cmd classpath') do set CP=%%i

echo Compiling Java files...

for %%f in ("%ROOT%\MapReduce\src\*.java") do (
    echo Compiling %%~nxf
    "C:\Program Files\Java\jdk-1.8\bin\javac.exe" -encoding UTF-8 -cp "%CP%" -d "%BUILD%\classes" "%%f"
)

echo.
echo Creating JAR...

if exist "%BUILD%\flightanalysis.jar" del /q "%BUILD%\flightanalysis.jar"

"C:\Program Files\Java\jdk-1.8\bin\jar.exe" cf "%BUILD%\flightanalysis.jar" -C "%BUILD%\classes" .

echo.
echo Checking compiled classes...
dir /s /b "%BUILD%\classes\*.class"

echo.
echo JAR created successfully.
echo.

pause