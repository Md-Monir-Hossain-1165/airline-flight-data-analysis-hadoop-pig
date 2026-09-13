@echo off
setlocal
set ROOT=%~dp0..
set DATA=%ROOT%\data\flights.csv
set BUILD=%ROOT%\MapReduce\build
if not exist "%BUILD%\classes" mkdir "%BUILD%\classes"
for /f "delims=" %%i in ('C:\hadoop\bin\hadoop.cmd classpath') do set CP=%%i
"C:\Program Files\Java\jdk-1.8\bin\javac.exe" -encoding UTF-8 -cp "%CP%" -d "%BUILD%\classes" "%ROOT%\MapReduce\src\*.java"
"C:\Program Files\Java\jdk-1.8\bin\jar.exe" cf "%BUILD%\flightanalysis.jar" -C "%BUILD%\classes" .
call :job flightanalysis.AirlineFlightCount 01_airline_flight_count
call :job flightanalysis.AirportDepartureCount 02_airport_departure_count
call :job flightanalysis.MonthlyFlightCount 03_monthly_flight_count
call :job flightanalysis.CancellationByAirline 04_cancellation_by_airline
call :job flightanalysis.AverageArrivalDelayByAirline 05_average_arrival_delay_by_airline
exit /b
:job
if exist "%ROOT%\MapReduce\output\%2" rmdir /s /q "%ROOT%\MapReduce\output\%2"
hadoop jar "%BUILD%\flightanalysis.jar" %1 "%DATA%" "file:///%ROOT:\=/%/MapReduce/output/%2"
exit /b
