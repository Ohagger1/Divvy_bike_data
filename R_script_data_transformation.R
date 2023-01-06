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

#Change ride time to seconds - difference in seconds
all_data$ride_length <- difftime(all_data$ended_at,all_data$started_at)
#Check data is correct
all_data$ride_length
str(all_data$ride_length)

is.factor(all_data$ride_length)

#Change ride length to numeric
all_data$ride_length <- as.numeric(as.character(all_data$ride_length))
is.numeric(all_data$ride_length)

colnames(all_data)

table(all_data$ride_length<0)

drop(all_data_2)

#Remove variables which are updated by Divva or the ride length is less than 0
all_data_2 <- all_data[!(all_data$start_station_name == "HQ QR" | all_data$ride_length<0),]

#Investigation into remaining data
table(all_data_2$ride_id)
table(all_data_2$rideable_type)
head(all_data$rideable_type)
str(all_data_2$rideable_type)
table(all_data_2$member_casual)
print(all_data_2$rideable_type)
table((all_data_2$rideable_type="docked_bike"))

mean(all_data_2$ride_length) #straight average (total ride length / rides)
median(all_data_2$ride_length) #midpoint number in the ascending array of ride lengths
max(all_data_2$ride_length) #longest ride
min(all_data_2$ride_length) #shortest ride

#Summary of statistics above
summary(all_data_2$ride_length)

#Comparing members and casual users
aggregate(all_data_2$ride_length ~ all_data_2$member_casual, FUN = mean)
aggregate(all_data_2$ride_length ~ all_data_2$member_casual, FUN = median)
aggregate(all_data_2$ride_length ~ all_data_2$member_casual, FUN = max)
aggregate(all_data_2$ride_length ~ all_data_2$member_casual, FUN = min)


# See the average ride time by each day for members vs casual users
aggregate(all_data_2$ride_length ~ all_data_2$member_casual + all_data_2$day_of_week, FUN = mean)

#Order the days of the week
all_data_2$day_of_week <- ordered(all_data_2$day_of_week, levels=c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))

table(all_data_2$day_of_week)
summary(all_data_2$day_of_week)


#Summary of number of rides and number on given days for a casual and member
all_data_2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>%  #creates weekday field using wday()
  group_by(member_casual, weekday) %>%  #groups by usertype and weekday
  summarise(number_of_rides = n()							#calculates the number of rides and average duration 
            ,average_duration = mean(ride_length)) %>% 		# calculates the average duration
  arrange(member_casual, weekday)# sorts

#Visualization of data from above
all_data_2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday)  %>% 
  ggplot(aes(x = weekday, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge")

#Visualization for average duration
all_data_2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday)  %>% 
  ggplot(aes(x = weekday, y = average_duration, fill = member_casual)) +
  geom_col(position = "dodge")

#Export a summary for analysis
counts <- aggregate(all_data_2$ride_length ~ all_data_2$member_casual + all_data_2$day_of_week, FUN = mean)
write.csv(counts, file = "C:/Users/ohagg/OneDrive - University College London/Desktop/Divvy_bike_data/avg_ride_length.csv")


