## This scripts downloads, if not already done, data set from UCI site, 
## loads data from the ./data/ directory and plots Energy Sub Metering
## diagram in function of time. Generated diagram is saved in ./plot3.png file

library(dplyr)
library(data.table)

source("./tools.R")

## load data from the file (see tools.R)
powerConsumption <- loadData()

## because my system is French, I need to change it to English inorder to get
## English week day names
Sys.setlocale(category = "LC_TIME", "English")

png(filename = "plot3.png",
    width = 480, height = 480)

## create diagram (see tools.R)
plot3(powerConsumption)

dev.off()  ## Close the png file device