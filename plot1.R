## This scripts downloads, if not already done, data set from UCI site, 
## loads data from the ./data/ directory and plots Global Active Power
## histogram. Generated histogram is saved in ./plot1.png file

library(dplyr)
library(data.table)

source("./tools.R")

## set working directory
setwd("E:/doc/projects/r-test/ExData_Plotting1")

## load data from the file (see tools.R)
powerConsumption <- loadData()

png(filename = "plot1.png",
    width = 480, height = 480)

hist(powerConsumption$Global_active_power, main = "Global Active Power", col = "red", 
     xlab = "Globale Active Power (kilowatts)")

dev.off()  ## Close the png file device