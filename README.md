# Divvy_bike_data

Thing I learnt with this project:

Steps to take when changing and clenaing data

-use read.csv to load the data file(s) into the console
-make sure all the column names are consistent with each other if you have more than one file

- rename column to make them consistent using:
(q3_2019 <- rename(q3_2019
                   ,ride_id = trip_id
                   ,rideable_type = bikeid)

alwyas check the structure of the data by using:
str(q1_2020)
str(q4_2019)

When you want to combine multiple datasets into one data frame use:

-all_data <- bind_rows(q1_2020,q2_2019,q3_2019,q4_2019)

To remove unwanted rows from a data frame:
all_data <- all_data %>% 
  select(-c(end_lat,end_lng,start_lat,start_lng,birthyear,gender,tripduration))
  
In order to only select rows to a new data frame use: (notice the changed c)

all_data <- all_data %>% 
  select(c(end_lat,end_lng,start_lat,start_lng,birthyear,gender,tripduration))
  
In order to extract dates form certain columns use;

all_data$date <- as.Date(all_data$started_at) #The default format is yyyy-mm-dd
all_data$month <- format(as.Date(all_data$date), "%m")
all_data$day <- format(as.Date(all_data$date), "%d")
all_data$year <- format(as.Date(all_data$date), "%Y")
all_data$day_of_week <- format(as.Date(all_data$date), "%A")


Compare means of two different variables use:

aggregate(all_data_2$ride_length ~ all_data_2$member_casual, FUN = mean)
aggregate(all_data_2$ride_length ~ all_data_2$member_casual, FUN = median)
aggregate(all_data_2$ride_length ~ all_data_2$member_casual, FUN = max)
aggregate(all_data_2$ride_length ~ all_data_2$member_casual, FUN = min)


                  
