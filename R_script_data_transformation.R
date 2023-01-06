library(ggplot2)
library(tidyverse) 
library(lubridate) 

setwd("C:/Users/ohagg/OneDrive - University College London/Desktop/Divvy_bike_data/Initial_files")

q2_2019 <- read_csv("Divvy_Trips_2019_Q2.csv")
q3_2019 <- read_csv("Divvy_Trips_2019_Q3.csv")
q4_2019 <- read_csv("Divvy_Trips_2019_Q4.csv")
q1_2020 <- read_csv("Divvy_Trips_2020_Q1.csv")

(q4_2019 <- rename(q4_2019
                   ,ride_id = trip_id
                   ,rideable_type = bikeid 
                   ,started_at = start_time  
                   ,ended_at = end_time  
                   ,start_station_name = from_station_name 
                   ,start_station_id = from_station_id 
                   ,end_station_name = to_station_name 
                   ,end_station_id = to_station_id 
                   ,member_casual = usertype))

(q3_2019 <- rename(q3_2019
                   ,ride_id = trip_id
                   ,rideable_type = bikeid 
                   ,started_at = start_time  
                   ,ended_at = end_time  
                   ,start_station_name = from_station_name 
                   ,start_station_id = from_station_id 
                   ,end_station_name = to_station_name 
                   ,end_station_id = to_station_id 
                   ,member_casual = usertype))

(q2_2019 <- rename(q2_2019
                   ,ride_id = "01 - Rental Details Rental ID"
                   ,rideable_type = "01 - Rental Details Bike ID" 
                   ,started_at = "01 - Rental Details Local Start Time"  
                   ,ended_at = "01 - Rental Details Local End Time"  
                   ,start_station_name = "03 - Rental Start Station Name" 
                   ,start_station_id = "03 - Rental Start Station ID"
                   ,end_station_name = "02 - Rental End Station Name" 
                   ,end_station_id = "02 - Rental End Station ID"
                   ,member_casual = "User Type"))

colnames(q3_2019)
colnames(q4_2019)
colnames(q2_2019)
colnames(q1_2020)

(q2_2019 <- rename(q2_2019
                   #,tripduration = "01 - Rental Details Duration In Seconds Uncapped"
                   #,birthyear = "05 - Member Details Member Birthday Year"
                   , gender =  "Member Gender"))

(q1_2020 <- rename(q2_2019
                   #,tripduration = "01 - Rental Details Duration In Seconds Uncapped"
                   #,birthyear = "05 - Member Details Member Birthday Year"
                   , gender =  "Member Gender"))

#Access the structure of the data
str(q1_2020)
str(q4_2019)
str(q3_2019)
str(q2_2019)

#Change strucutre to char to bind
q4_2019 <-  mutate(q4_2019, ride_id = as.character(ride_id)
                   ,rideable_type = as.character(rideable_type)) 
q3_2019 <-  mutate(q3_2019, ride_id = as.character(ride_id)
                   ,rideable_type = as.character(rideable_type)) 
q2_2019 <-  mutate(q2_2019, ride_id = as.character(ride_id)
                   ,rideable_type = as.character(rideable_type)) 

#Combine three different data sets into one larger set
all_data <- bind_rows(q1_2020,q2_2019,q3_2019,q4_2019)

#Check the top 5 rows of data
head(all_data)

#Remove data that doesn't have unwanted rows
all_data <- all_data %>% 
  select(-c(end_lat,end_lng,start_lat,start_lng,birthyear,gender,tripduration))

#Inspect the colnames
colnames(all_data)
dim(all_data)
str(all_data)

#See the instances of each category
table(all_data$member_casual)

#Reassign to desired values (recode)
all_data <- all_data %>% 
  mutate(member_casual = recode(member_casual
                                ,"Subscriber" = "member"
                                ,"Customer" = "casual"))
#Reinspct the data
table(all_data$member_casual)

#Change and add columns
all_data$date <- as.Date(all_data$started_at) #The default format is yyyy-mm-dd
all_data$month <- format(as.Date(all_data$date), "%m")
all_data$day <- format(as.Date(all_data$date), "%d")
all_data$year <- format(as.Date(all_data$date), "%Y")
all_data$day_of_week <- format(as.Date(all_data$date), "%A")



