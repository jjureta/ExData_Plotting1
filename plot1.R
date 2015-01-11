## This scripts downloads, if not already done, data set from UCI site, 
## loads data from the ./data/ directory and plots Global Active Power
## histogram. Generated histogram is saved in ./plot1.png file

library(dplyr)
library(data.table)

source("./tools.R")

## load data from the file (see tools.R)
powerConsumption <- loadData()

## created png device
png(filename = "plot1.png",
    width = 480, height = 480)

## plot histogram (see tools.R)
plot1(powerConsumption)

dev.off()  ## Close the png file device