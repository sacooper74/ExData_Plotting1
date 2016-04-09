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
png(filename = "plot2.png", width = 480, height = 480, units = "px")

# Plot the graph
plot(hpc$date_time, hpc$Global_active_power, ylab = "Global Active Power (kilowatts)", xlab = "", type = "n")
lines(hpc$date_time, hpc$Global_active_power)

# Close the png device
dev.off()