pollutantmean <- function(directory, pollutant,  id = 1:332){
        #set working directory to the folder conatining data files
        wd <- getwd()
        setwd(paste(wd, directory, sep="/"))
        
        #initial results
        result_sum <- 0
        number_results <- 0
        # Loop over all files to read them and calculate intermediate rsults
        # for each file
        for (i in id) {
                # Determine names of relevant file
                if (i < 10) {
                        filename <- paste("00",i,".csv",sep="")
                } else if (i <100){
                        filename <- paste("0",i,".csv",sep="")
                } else {
                        filename <- paste(i,".csv",sep="")
                }
                
                # Read the file
                data <- read.csv(filename)
                
                # Calculate  the number of non-NA observations and their sum 
                # for relevant pollutant
                result_sum <- result_sum + sum(data[, pollutant], na.rm = TRUE)
                number_results <- number_results + sum(!is.na(data[, pollutant]))
        }
        
        # set working directory back to the original folder
        setwd(wd)
        
        # output
        result_mean <- result_sum / number_results
        result_mean
}