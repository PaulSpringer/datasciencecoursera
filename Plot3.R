## Function which generates Plot1. This function has no arguments


plot3 <- function() {
        ## get input from file "household_power_consumption.txt" from the
        ## working direktory (input is already constrained to dates 01/02/2007
        ## and 02/02/2007)
        input <- read.table("household_power_consumption.txt", header = FALSE,
                         sep = ";", skip = 66637, nrows = 2880)
        input_names <- read.table("household_power_consumption.txt",
                                  header = FALSE, sep = ";", nrows = 1)
        names(input) <- t(input_names)
        
        ## Create dummy attribute (column) "DateTime"
        input$DateTime <- paste(input$Date, " ", input$Time)
        
        ## Converts Column "DateTime", which is of type character to type
        ## POSIXct POSIXt
        input$DateTime <- as.POSIXct(input$DateTime,
                                     format = "%d/%m/%Y %H:%M:%S")
        
        ## Open PNG device
        png(filename = "Plot3.png",
            width = 480, height = 480, units = "px")
        
        ## Plot the plot
        with(input, plot(DateTime, Sub_metering_1, type = "l",
                         ylab = "Energy sub metering", xlab = ""))
        lines(input$DateTime, input$Sub_metering_2, col = "red")
        lines(input$DateTime, input$Sub_metering_3, col = "blue")
        legend("topright",
               legend = c("Sub-metering_1", "Sub-metering_2", "Sub-metering_3"),
               col = c("black", "red", "blue"), lty = c(1,1))
        
        ## Close PNG device
        dev.off()
        
        ## Output (Plot the same plot on screen device, in order to 
        ## immediately see the result)
        with(input, plot(DateTime, Sub_metering_1, type = "l",
                         ylab = "Energy sub metering", xlab = ""))
        lines(input$DateTime, input$Sub_metering_2, col = "red")
        lines(input$DateTime, input$Sub_metering_3, col = "blue")
        legend("topright",
               legend = c("Sub-metering_1", "Sub-metering_2", "Sub-metering_3"),
               col = c("black", "red", "blue"), lty = c(1,1))
}