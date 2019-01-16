data <- read.csv("data.csv",header=T,sep=",")
data$date <- format(as.Date(data$date,format="%d-%m-%Y"),format="%d-%b, %Y")
data$time <- paste(data$time_m,":",data$time_s,sep="")
colnames(data) <- c("Date", "Distance (km)", "time_m", "time_s", "Weight (kg)", "Pushups", "Time")
data1 <- data[,c(1,2,7)]
head(data1)
