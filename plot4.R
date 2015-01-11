library(dplyr)
library(data.table)

source("./tools.R")

## load data from the file (see tools.R)
powerConsumption <- loadData()

## because my system is French, I need to change it to English inorder to get
## English week day names
Sys.setlocale(category = "LC_TIME", "English")

png(filename = "plot4.png",
    width = 480, height = 480)

par(mfrow = c(2, 2))

## create 4 diagrams. for plot2, plotVoltage, plot3 and plotGlobalReactivePower see tools.R
plot4(powerConsumption)


dev.off()  ## Close the png file device