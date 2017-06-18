## This script will download the HPC Data and will then read it into  R and construct plot4.png

Data_URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
dirCreated <- FALSE
version <- 0

## creates a new base directory specific to this instance of script running
while(dirCreated == FALSE){
        version <- version + 1
        baseDir <- paste("./HPC Directory ver_", version, sep = "")
        if(!file.exists(baseDir)){
                dir.create(baseDir)
                dirCreated = TRUE
        }
}

## downloads the file, then creates an unzipped version
download.file(Data_URL, paste(baseDir,"/HPC.zip", sep = ""))
unzip(paste(baseDir, "/HPC.zip", sep = ""), exdir = paste(baseDir, "/HPC", sep = ""))

HPC_Data <- read.delim(paste(baseDir, "/HPC/household_power_consumption.txt", sep = ""),
                       header = TRUE, sep = ";")

HPC_Data <- subset(HPC_Data, Date == "1/2/2007" | Date == "2/2/2007")

HPC_Data$Date_Time <- as.POSIXct(paste(HPC_Data$Date, HPC_Data$Time), format = "%d/%m/%Y %H:%M:%S")
HPC_Data$Global_active_power <- as.numeric(HPC_Data$Global_active_power)
HPC_Data$Global_reactive_power <- as.numeric(HPC_Data$Global_reactive_power)
HPC_Data$Sub_metering_1 <- as.numeric(HPC_Data$Sub_metering_1)
HPC_Data$Sub_metering_2 <- as.numeric(HPC_Data$Sub_metering_2)
HPC_Data$Sub_metering_3 <- as.numeric(HPC_Data$Sub_metering_3)

par(mfcol=c(2,2))

#Creates top left plot
plot(HPC_Data$Date_Time, (HPC_Data$Global_active_power)/500, type = "l", xlab = "", 
     ylab = "Global Active Power (kilowatts)")

#Creates bottom left plot
plot(HPC_Data$Date_Time, (HPC_Data$Sub_metering_1), type = "l", xlab = "", 
     ylab = "Energy sub metering", ylim = c(0,40))
lines(HPC_Data$Date_Time, HPC_Data$Sub_metering_2, type = "l", col = "red")
lines(HPC_Data$Date_Time, HPC_Data$Sub_metering_3, type = "l", col = "blue")
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col = c("black", "red", "blue"), lty = 1)

#Creates top right plot
plot(HPC_Data$Date_Time, HPC_Data$Voltage, type = "l", xlab = "datetime", ylab = "Voltage")

#Creates bottom right plot
plot(HPC_Data$Date_Time, HPC_Data$Global_reactive_power, type = "l", xlab = "datetime", 
     ylab = "Global_reactive_power")

dev.copy(png, "plot4.png")
dev.off()
