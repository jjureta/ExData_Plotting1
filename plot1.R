## This scripts downloads, if not already done, data set from UCI site, 
## loads data from the ./data/ directory and plots Global Active Power
## histogram. Generated histogram is saved in ./plot1.png file

library(dplyr)
library(data.table)

source("./tools.R")

## set working directory
setwd("E:/doc/projects/r-test/ExData_Plotting1")

dataFolder <- "./data"
fileName <- "household_power_consumption.txt"

fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
filePath <- paste(dataFolder, fileName, sep = "/")

## download UCI data (see tools.R)
downloadData(dataFolder)
## subset UCI data for given range (see tools.R)
subsetFilePath <- subsetData(as.Date("2007-02-01"), as.Date("2007-02-02"), 
                             dataFolder, filePath)

## load data from the file
powerConsumption <- fread(subsetFilePath, na.strings = "?")

png(filename = "plot1.png",
    width = 480, height = 480)

hist(powerConsumption$Global_active_power, main = "Global Active Power", col = "red", 
     xlab = "Globale Active Power (kilowatts)")

dev.off()  ## Close the png file device