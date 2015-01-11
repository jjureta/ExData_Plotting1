require(lubridate)
require(data.table)

## This function download and unzip data from UCI site if it is not already done
## dataFolder - folder wher data will be downloaded and unzipped
## fileURL - the YRL from where the file is downloaded
downloadData <- function(dataFolder, fileURL) {
  downloadedFileName <- "household_power_consumption.zip"
  downloadedFilePath <- paste(dataFolder, downloadedFileName, sep = "/")
  
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
  }
}

## This function creates file containing subset of UCI data set, 
## if it is not already done.
## Current limitation: fromDate < toDate and todate - fromDate = 1 day
## fromDate - lower limit date from which data are kept
## toDate - upper limit date til which data are kept
## dataFolder - folder where will be put a file containing subset of data
## filePath - file containing data
##
## return - file path containing subset data
subsetData <- function(fromDate, toDate, dataFolder, filePath) {
  ## verify if fromDate is before toDate
  if (fromDate >= toDate) {
    stop("fromDate must be lower than toDate")
  }
  
  ## verify if todate is the day after fromDate
  if(as.numeric(toDate - fromDate) != 1) {
    stop("toDate must be the day after fromDate")
  }
  
  subsetFileName <- paste0("subset", format(fromDate, "%Y%m%d"), 
                           format(toDate, "%Y%m%d"), ".txt")
  subsetFilePath <- paste(dataFolder, subsetFileName, sep = "/")
  
  if (file.exists(subsetFilePath)) {
    return (subsetFilePath)
  }
  
  ## create regex for date. 
  ## the Date is added to keep header information
  fromDateString <- paste0("^", day(fromDate), "/", 
                           month(fromDate), "/", 
                           year(fromDate)) 
  toDateString <- paste0("^", day(toDate), "/", 
                         month(toDate), "/", 
                         year(toDate)) 
  regex <- paste(fromDateString, toDateString, "^Date", sep = "|")
  
  ## verify if toDate is day after fromDate
  ## subset file by reading line by line
  ## because it is not stated that file is ordered by date/time, the fix offset is not used
  cin <- file(filePath, "r") 
  cout <- file(subsetFilePath, 'w') 
  while (length(input <- readLines(cin, n=1000)) > 0) { 
    writeLines(input[grepl(regex, input)], con=cout)  
  }
  close(cin)
  close(cout)
  
  return (subsetFilePath)
}

## Download data, if not already done, and load it into a data.table
##
## return - loaded data.table
loadData <- function() {
  dataFolder <- "./data"
  fileName <- "household_power_consumption.txt"
  
  fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  filePath <- paste(dataFolder, fileName, sep = "/")
  
  ## download UCI data (see tools.R)
  downloadData(dataFolder, fileURL)
  ## subset UCI data for given range (see tools.R)
  subsetFilePath <- subsetData(as.Date("2007-02-01"), as.Date("2007-02-02"), 
                               dataFolder, filePath)
  
  ## load data from the file
  powerConsumption <- fread(subsetFilePath, na.strings = "?")
  
  ##powerConsumption[, DateTime := paste(Date, Time)]
  powerConsumption <- cbind(powerConsumption, 
                            as.POSIXct(paste(powerConsumption$Date, powerConsumption$Time), 
                                     format = "%d/%m/%Y %H:%M:%S"))
  setnames(powerConsumption, 10, "DateTime")
  return (powerConsumption)
}

## Plot Globale Active Power histogram
##
## data - data
plot1 <- function(data) {
  hist(data$Global_active_power, 
       main = "Global Active Power", 
       col = "red", 
       xlab = "Globale Active Power (kilowatts)")
}

## Plot Globale Active Power diagram in function of time
##
## data - data
## ylav - y labbel
plot2 <- function(data, ylab = "Globale Active Power (kilowatts)") {
  with(data,  
       plot(
         DateTime,
         Global_active_power, type = "l",
         xlab = "",
         ylab = ylab))
}

## Plot Energy sub metering diagram 
##
## data - data
## bty - to plot (bty = "o") or not (bty = "n") a box around the legend
plot3 <- function(data, bty = "o") {
  with(data, 
       plot(
         DateTime,
         Sub_metering_1, type = "n",
         xlab = "",
         ylab = "Energy sub metering")
  )
  
  with(data, 
       points(
         DateTime,
         Sub_metering_1, type = "l")
  )
  
  with(data, 
       points(
         DateTime,
         Sub_metering_2, type = "l",
         col = "red")
  )
  
  with(data, 
       points(
         DateTime,
         Sub_metering_3, type = "l",
         col = "blue")
  )
  
  legend("topright", lty=1, col = c("black", "blue", "red"), 
         legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
         bty = bty)
}

## Plot the Voltage in function of time
##
## data - data
plotVoltage <- function(data) {
  with(data,  
       plot(
         DateTime,
         Voltage, type = "l",
         xlab = "datetime",
         ylab = "Voltage"))  
}

## Plot the Global Reactive Power in function of time
##
## data - data
plotGlobalReactivePower <- function(data) {
  with(data,  
       plot(
         DateTime,
         Global_reactive_power, type = "l",
         xlab = "datetime",
         ylab = "Global_reactive_power"))  
}

## Plot 4 diagrams as a matrix 2*2.
## Diafram (1,1) - 
plot4 <- function(data) {
  with(powerConsumption, {
    plot2(powerConsumption, ylab = "Globale Active Power")
    plotVoltage(powerConsumption)
    plot3(powerConsumption, bty = "n")
    plotGlobalReactivePower(powerConsumption)
  })
}