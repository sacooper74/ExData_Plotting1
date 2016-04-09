# Download the file to the working directory
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

# Download zip file
download.file(fileURL, destfile = "hpc.zip")

# Unzip file and unlink the zip file
hpc.zip <- unzip("hpc.zip")
unlink("hpc.zip")

# Unzip the file to workspace
hpc <- read.csv(hpc.zip, 
                sep=";",
                dec=".",
                na.strings = "?",
                colClasses=c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))

# Filter on dates 2007-02-01 and 2007-02-02
hpc <- hpc[(hpc$Date == "1/2/2007" | hpc$Date == "2/2/2007"), ]

# Concatenate date_time
hpc$date_time <- paste(hpc$Date, sep = " ", hpc$Time)

# Correctly format date_time
hpc$date_time <- strptime(hpc$date_time, "%d/%m/%Y %H:%M:%S")
# sub_hpc <- filter(hpc, date_time = as.Date("2007-02-01"))

# Open the png device
png(filename = "plot4.png", width = 480, height = 480, units = "px")

# Set the par for multiple base plots
par(mfrow = c(2,2), mar = c(4,4,2,1))

# Plot graph 1
plot(hpc$date_time, hpc$Global_active_power, ylab = "Global Active Power (kilowatts)", xlab = "", type = "n")
lines(hpc$date_time, hpc$Global_active_power)

# Plot graph 2
plot(hpc$date_time, hpc$Voltage, xlab = "datetime", ylab = "Voltage", type = "n")
lines(hpc$date_time, hpc$Voltage)

# Plot graph 3

# Tidy the data, we're going to need tidyr for this!
library(tidyr)

# There's a bug in dplyr/tidyr that I can't get around - it throws an error with dates in format POSIXlt, so I first remove
# by converting to date format
hpc2 <- hpc
hpc2$date_time <- as.Date(hpc2$date_time)

# Gather power by station
hpc_tidy <- hpc2 %>%
  gather(station, power, Sub_metering_1:Sub_metering_3)

# Reformat the date
hpc_tidy$date_time <- paste(hpc_tidy$Date, sep = " ", hpc_tidy$Time)
hpc_tidy$date_time <- strptime(hpc_tidy$date_time, "%d/%m/%Y %H:%M:%S")

# Subset the data by power station
hpc_1 <- subset(hpc_tidy, station == "Sub_metering_1")
hpc_2 <- subset(hpc_tidy, station == "Sub_metering_2")
hpc_3 <- subset(hpc_tidy, station == "Sub_metering_3")

# Plot the graph
plot(hpc_tidy$date_time, hpc_tidy$power, ylab = "Energy sub metering", xlab = "", type = "n")

# Add lines for each power station
lines(hpc_1$date_time, hpc_1$power)
lines(hpc_2$date_time, hpc_2$power, col = "red")
lines(hpc_3$date_time, hpc_3$power, col = "blue")

# Build the legend
legend("topright", border = "white", lwd = 1, lty = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty = "n")

# Plot Graph 4
plot(hpc$date_time, hpc$Global_reactive_power, xlab = "datetime", ylab = "Global_reactive_power", type = "n")
lines(hpc$date_time, hpc$Global_reactive_power)

# Close the png device
dev.off()