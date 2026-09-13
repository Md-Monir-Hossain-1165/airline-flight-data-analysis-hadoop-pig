flights = LOAD 'E:/BDAL/New Dataset/flights.csv' USING PigStorage(',') AS (year:int,month:int,day:int,day_of_week:int,airline:chararray,flight_number:int,tail_number:chararray,origin:chararray,destination:chararray,scheduled_departure:chararray,departure_time:chararray,departure_delay:double,taxi_out:double,wheels_off:chararray,scheduled_time:double,elapsed_time:double,air_time:double,distance:double,wheels_on:chararray,taxi_in:double,scheduled_arrival:chararray,arrival_time:chararray,arrival_delay:double,diverted:int,cancelled:int,cancellation_reason:chararray,air_system_delay:double,security_delay:double,airline_delay:double,late_aircraft_delay:double,weather_delay:double);
valid = FILTER flights BY year IS NOT NULL AND arrival_delay IS NOT NULL;
grouped = GROUP valid BY month;
result = FOREACH grouped GENERATE group AS month, AVG(valid.arrival_delay) AS average_arrival_delay_minutes;
ordered = ORDER result BY month ASC;
STORE ordered INTO 'E:/BDAL/Final_Assignment/Flight_Data_Analysis/PigAnalysis/output/07_average_arrival_delay_by_month' USING PigStorage('|');



