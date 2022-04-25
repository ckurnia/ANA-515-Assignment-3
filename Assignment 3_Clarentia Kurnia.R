getwd()

#install.packages("tidyverse")
#install.packages("readr")
#install.packages("dplyr")
#install.packages("stringr")
library(tidyverse)
library(readr)
library(dplyr)
library(stringr)

head(StormEvents_details.ftp_v1.0_d1998_c20210803, 6)

#select variables
myvars <- c("BEGIN_YEARMONTH", "BEGIN_DAY", "BEGIN_TIME", "END_YEARMONTH",
            "END_DAY", "END_TIME", "BEGIN_DATE_TIME", "END_DATE_TIME",
            "EPISODE_ID", "EVENT_ID", "STATE", "STATE_FIPS", "CZ_NAME",
            "CZ_TYPE", "CZ_FIPS", "EVENT_TYPE", "SOURCE", "BEGIN_LAT",
            "BEGIN_LON", "END_LAT", "END_LON")
newdata <- StormEvents_details.ftp_v1.0_d1998_c20210803[myvars]

head(newdata)

newdata <- arrange(newdata, BEGIN_YEARMONTH)

newdata$STATE <- str_to_title(newdata$STATE)
newdata$CZ_NAME <- str_to_title(newdata$CZ_NAME)

newdata <- filter(newdata, CZ_TYPE == "C")
newdata <- select(newdata, -CZ_TYPE)

newdata$STATE_FIPS <- str_pad(newdata$STATE_FIPS, width = 3, side = "left",
                      pad = "0")
newdata$CZ_FIPS <- str_pad(newdata$CZ_FIPS, width = 4, side = "left", pad = "0")

newdata <- unite(newdata, "fips", c("STATE_FIPS","CZ_FIPS"))

newdata <- rename_all(newdata, tolower)

data("state")
us_state_info <- data.frame(state=state.name, region=state.region,
                  area=state.area)

Newset <- data.frame(table(newdata$STATE))
head(Newset)

newset1 <- rename(Newset,c("state"="Var1"))
merged <- merge(x=newset1, y=us_state_info, by.x="state", by.y="state")
head(merged)

library(ggplot2)
storm_plot <- ggplot(merged, aes(x=area, y=Freq)) +
  geom_point(aes(color=region)) +
  labs(x="Land area (square miles)",
       y="Number of storm events in 1998")
storm_plot

