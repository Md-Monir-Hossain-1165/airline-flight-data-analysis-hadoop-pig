flights = LOAD 'E:/BDAL/New_Dataset/flights.csv' USING PigStorage(',') AS (year:int,month:int,day:int,day_of_week:int,airline:chararray,flight_number:int,tail_number:chararray,origin:chararray,destination:chararray,scheduled_departure:chararray,departure_time:chararray,departure_delay:double,taxi_out:double,wheels_off:chararray,scheduled_time:double,elapsed_time:double,air_time:double,distance:double,wheels_on:chararray,taxi_in:double,scheduled_arrival:chararray,arrival_time:chararray,arrival_delay:double,diverted:int,cancelled:int,cancellation_reason:chararray,air_system_delay:double,security_delay:double,airline_delay:double,late_aircraft_delay:double,weather_delay:double);
airlines = LOAD 'E:/BDAL/New_Dataset/airlines.csv' USING PigStorage(',') AS (code:chararray,airline_name:chararray);
valid_flights = FILTER flights BY year IS NOT NULL;
valid_airlines = FILTER airlines BY code != 'IATA_CODE';
grouped = GROUP valid_flights BY airline;
totals = FOREACH grouped GENERATE group AS airline_code, COUNT(valid_flights) AS total_flights;
named = JOIN totals BY airline_code, valid_airlines BY code;
result = FOREACH named GENERATE totals::airline_code AS airline_code, valid_airlines::airline_name AS airline_name, totals::total_flights AS total_flights;
ordered = ORDER result BY total_flights DESC;
STORE ordered INTO 'E:/BDAL/Final_Assignment/Flight_Data_Analysis/PigAnalysis/output/01_airline_flight_totals' USING PigStorage('|');



