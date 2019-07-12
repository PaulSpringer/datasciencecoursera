## Function which generates Plot1. This function has no arguments


plot1 <- function() {
        ## get input from file "household_power_consumption.txt" from the
        ## working direktory (input is already constrained to dates 01/02/2007
        ## and 02/02/2007)
        input <- read.table("household_power_consumption.txt", header = FALSE,
                         sep = ";", skip = 66637, nrows = 2880)
        input_names <- read.table("household_power_consumption.txt",
                                  header = FALSE, sep = ";", nrows = 1)
        names(input) <- t(input_names)
        
        ## Open PNG device
        png(filename = "Plot1.png",
            width = 480, height = 480, units = "px")
        
        ## Plot the histogramm
        hist(input$Global_active_power, col = "red",
             xlab = "Global Active Power (kilowatts)",
             main = "Global Active Power")
        
        ## Close PNG device
        dev.off()
        
        ## Output (Plot the same histogramm on screen device, in order to 
        ## immediately see the result)
        hist(input$Global_active_power, col = "red",
             xlab = "Global Active Power (kilowatts)",
             main = "Global Active Power")
}