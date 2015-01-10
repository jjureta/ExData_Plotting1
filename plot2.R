library(dplyr)
library(data.table)

source("./tools.R")

## set working directory
setwd("E:/doc/projects/r-test/ExData_Plotting1")

## load data from the file (see tools.R)
powerConsumption <- loadData()

## because my system is French, I need to change it to English inorder to get
## English week day names
Sys.setlocale(category = "LC_TIME", "English")

png(filename = "plot2.png",
    width = 480, height = 480)

with(powerConsumption, 
     plot(
       DateTime,
       Global_active_power, type = "l",
       xlab = "",
       ylab = "Globale Active Power (kilowatts)"))

dev.off()  ## Close the png file device