flights = LOAD 'E:/BDAL/New_Dataset/flights.csv' USING PigStorage(',') AS (year:int,month:int,day:int,day_of_week:int,airline:chararray,flight_number:int,tail_number:chararray,origin:chararray,destination:chararray,scheduled_departure:chararray,departure_time:chararray,departure_delay:double,taxi_out:double,wheels_off:chararray,scheduled_time:double,elapsed_time:double,air_time:double,distance:double,wheels_on:chararray,taxi_in:double,scheduled_arrival:chararray,arrival_time:chararray,arrival_delay:double,diverted:int,cancelled:int,cancellation_reason:chararray,air_system_delay:double,security_delay:double,airline_delay:double,late_aircraft_delay:double,weather_delay:double);
valid = FILTER flights BY year IS NOT NULL AND origin IS NOT NULL;
grouped = GROUP valid BY origin;
counts = FOREACH grouped GENERATE group AS origin_airport, COUNT(valid) AS departures;
ordered = ORDER counts BY departures DESC;
result = LIMIT ordered 10;
STORE result INTO 'E:/BDAL/Final_Assignment/Flight_Data_Analysis/PigAnalysis/output/03_top_origin_airports' USING PigStorage('|');



