complete <- function(directory,  id = 1:332){
        #set working directory to the folder conatining data files
        wd <- getwd()
        setwd(paste(wd, directory, sep="/"))
        
        #initial data frame
        initial_vector <- vector(mode = "numeric", length = length(id))
        dataframe <- data.frame(initial_vector,initial_vector)
        colnames(dataframe) <- c("id", "nobs")
        # Loop over all files to read them and extract the number of complete
        # cases per file.
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
                
                # Calculate number of complete data sets
                Not_NA_Vector = complete.cases(data)
                
                # Store them in the output table
                dataframe[which(i == id), 1] <- i
                dataframe[which(i == id), 2] <- sum(Not_NA_Vector)
        }
        
        # set working directory back to the original folder
        setwd(wd)
        
        # output
        dataframe
}