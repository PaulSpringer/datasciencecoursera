corr <- function(directory,  threshold = 0){
        
        # Get table with complete observation per monitoring facility
        source("complete.R")
        compl <- complete(directory)
        
        # Vector with id's od monitoring facilities which fulfill threshold
        # restriction
        id_vec <- compl[compl[,2] > threshold, 1]
        
        #set working directory to the folder conatining data files
        wd <- getwd()
        setwd(paste(wd, directory, sep="/"))
        
        # Initial correlation vector
        corr_vec <- vector(mode = "numeric", length = length(id_vec))
        # Loop over all relevant files to read the data
        for (i in id_vec) {
                # Determine name of relevant file
                if (i < 10) {
                        filename <- paste("00",i,".csv",sep="")
                } else if (i <100){
                        filename <- paste("0",i,".csv",sep="")
                } else {
                        filename <- paste(i,".csv",sep="")
                }
                
                # Read the file
                data <- read.csv(filename)
                
                # Calculate correlation
                corr_vec[which(i == id_vec)] <- cor(data[, 2], data[, 3],
                                                use = "complete.obs",
                                                method = "pearson")
        }
        
        # set working directory back to the original folder
        setwd(wd)
        
        # output
        corr_vec
}