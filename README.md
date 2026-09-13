# Airline Flight Data Analysis

## Project layout

- `MapReduce/src/` - Java MapReduce source code
- `MapReduce/output/` - MapReduce results
- `PigAnalysis/scripts/` - Pig scripts
- `PigAnalysis/output/` - Pig results
- `docs/` - final report
- `data/` - Kaggle CSV files, excluded from Git

## Run from Administrator Command Prompt

```cmd
cd /d E:\BDAL\Final_Assignment\Flight_Data_Analysis
MapReduce\run_mapreduce_local.cmd
PigAnalysis\run_pig_local.cmd
```

Download the 2015 flight-delay dataset from https://www.kaggle.com/datasets/usdot/flight-delays and place `flights.csv`, `airlines.csv`, and `airports.csv` in `data/`.
