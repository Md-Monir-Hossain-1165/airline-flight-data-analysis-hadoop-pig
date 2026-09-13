@echo off
setlocal
set ROOT=%~dp0..
for %%F in ("%ROOT%\PigAnalysis\scripts\*.pig") do call :run "%%~fF" "%%~nF"
exit /b
:run
set OUT=%ROOT%\PigAnalysis\output\%~2
if exist "%OUT%" rmdir /s /q "%OUT%"
pig -x local -param input=%ROOT%/data/flights.csv -param airlines=%ROOT%/data/airlines.csv -param output=%OUT:\=/% -f %1
exit /b
