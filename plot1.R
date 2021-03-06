## This script will download the HPC Data and will then read it into  R and construct plot1.png

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
                       header = TRUE, sep = ";", na.strings = "?")

HPC_Data <- subset(HPC_Data, Date == "1/2/2007" | Date == "2/2/2007")

HPC_Data$Global_active_power <- as.numeric(HPC_Data$Global_active_power)

hist((HPC_Data$Global_active_power), col = "red", main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)", ylim = c(0,1300), breaks = 12)

dev.copy(png, "plot1.png")
dev.off()