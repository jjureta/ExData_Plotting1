## This scripts downloads, if not already done, data set from UCI site, 
## loads data from the ./data/ directory and plots Global Active Power
## histogram. Generated histogram is saved in ./plots/plot1.png file

library(dplyr)
library(data.table)

## set working directory
setwd("E:/doc/projects/r-test/ExData_Plotting1")

dataFolder <- "./data"
downloadedFileName <- "household_power_consumption.zip"
fileName <- "household_power_consumption.txt"
subsetFileName <- "household_power_consumption_sub.txt"

fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
downloadedFilePath <- paste(dataFolder, downloadedFileName, sep = "/")
filePath <- paste(dataFolder, fileName, sep = "/")
subsetFilePath <- paste(dataFolder, subsetFileName, sep = "/")

## creats data folder if not already done
if (!file.exists(dataFolder)) {
  dir.create(dataFolder)
}

## download and unzip data file if not already done
if (!file.exists(downloadedFilePath)) {
  ## method = "curl" doesn't work on windows
  download.file(fileURL, destfile = downloadedFilePath, mode="wb")
  dateDownloaded <- date()
  
  unzip(downloadedFilePath, exdir = dataFolder)
  
  ## subset file by reading line by line
  ## because it is not stated that file is ordered by date/time, the fix offset is not used
  cin <- file(filePath, "r") 
  cout <- file(subsetFilePath, 'w') 
  while (length(input <- readLines(cin, n=1000)) > 0) { 
      writeLines(input[grepl("^1/2/2007|^2/2/2007|^Date", input)], con=cout)  
  }
  close(cin)
  close(cout)
  
}

## load data from the file
powerConsumption <- fread(subsetFilePath, na.strings = "?")

hist(powerConsumption$Global_active_power)