## This script will download the HPC Data and will then read it into  R and construct plot3.png

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
HPC_Data$Sub_metering_1 <- as.numeric(HPC_Data$Sub_metering_1)
HPC_Data$Sub_metering_2 <- as.numeric(HPC_Data$Sub_metering_2)
HPC_Data$Sub_metering_3 <- as.numeric(HPC_Data$Sub_metering_3)

plot(HPC_Data$Date_Time, (HPC_Data$Sub_metering_1), type = "l", xlab = "", 
     ylab = "Energy sub metering", ylim = c(0,40))
lines(HPC_Data$Date_Time, HPC_Data$Sub_metering_2, type = "l", col = "red")
lines(HPC_Data$Date_Time, HPC_Data$Sub_metering_3, type = "l", col = "blue")
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       col = c("black", "red", "blue"), lty = 1)

dev.copy(png, "plot3.png")
dev.off()
