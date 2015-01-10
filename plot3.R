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

png(filename = "plot3.png",
    width = 480, height = 480)

with(powerConsumption, 
     plot(
       DateTime,
       Sub_metering_1, type = "n",
       xlab = "",
       ylab = "Energy sub metering")
)

with(powerConsumption, 
     points(
       DateTime,
       Sub_metering_1, type = "l")
     )

with(powerConsumption, 
     points(
       DateTime,
       Sub_metering_2, type = "l",
       col = "red")
     )

with(powerConsumption, 
     points(
       DateTime,
       Sub_metering_3, type = "l",
       col = "blue")
     )

legend("topright", lty=1, col = c("black", "blue", "red"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))


dev.off()  ## Close the png file device