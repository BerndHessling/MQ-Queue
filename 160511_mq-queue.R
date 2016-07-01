###############################################################################
### Select folders ###
###############################################################################

dir <- choose.dir(caption = "***Please choose the queue folder***")

MQDir <- choose.dir(caption = "***Please choose the MaxQuant/bin/ folder***")

resultDir <- choose.dir(caption = "***Please choose the folder results should be copied in***")

###############################################################################
### Start loop ###
###############################################################################

while(1>0){
  
  #  check for existing files
  mqpars <- as.data.frame(list.files(path = dir,
                         pattern = "^.*\\.xml$",
                         recursive = TRUE,
                         include.dirs = TRUE))
  
  if(dim(mqpars)[1] != 0) {
  
    names(mqpars) <- "file"
    
    mqpars[ , 1] <- as.character(mqpars[ , 1])
    
    mqpars$fileDate <- as.POSIXct(rep(NA, dim(mqpars)[1]))
    
    mqpars$priority <- as.logical(rep(NA, dim(mqpars)[1]))
    
    mqpars$ak <- as.character(rep(NA, dim(mqpars)[1]))
    
    mqpars$project <- as.character(rep(NA, dim(mqpars)[1]))
    
    ###########################################################################
    ### Create xml data frame with extracted info ###
    ###########################################################################
    
    for(i in 1:dim(mqpars)[1]){
      
      fileInfo <- file.info(paste0(dir, "/", mqpars[i, 1]))
      
      mqpars$fileDate[i] <- fileInfo$mtime
      
      mqpars$priority[i] <- grepl(pattern = "priority",
            x = mqpars$file[i])
      
      mqpars$project[i] <- substr(mqpars$file[i],
                             start = 1,
                             stop = regexpr("_", mqpars$file[i]) - 1 )
      
      mqpars$project[i] <- gsub("priority/", "", mqpars$project[i])
      
      mqpars$ak[i] <- substr(mqpars$file[i],
                                  start = regexpr("_", as.character(mqpars$file[i])) + 1,
                                  stop = nchar(mqpars$file[i]) - 4)
      
    }
    
    #  sort by priority and date
    
    mqpars <- mqpars[order(-mqpars[ , 3], mqpars[ , 2]), ]
    
    
    ###########################################################################
    ### MaxQuant analysis of first xml file ###
    ###########################################################################
    
    MQCommand <- paste0(MQDir,
                        "/MaxQuantCmd.exe ",
                        dir,
                        "/",
                        mqpars[1,1])
    
    MQCommand <- gsub("\\\\", "/", MQCommand)
    
    print(paste0(Sys.time(),
                 "   Start maxquant analysis ",
                 mqpars[1,1]))
    
    system(MQCommand)
    
    print(paste0(Sys.time(),
                 "   Finished maxquant analysis ",
                 mqpars[1,1]))
    
    ###########################################################################
    ### Copy result files in result folder ###
    ###########################################################################
    
    setwd(dir)
    
    xml <- readLines(mqpars[1,1])
    
    rawline <-  grep(pattern = "filePaths", x = xml)[1] + 1
    
    backslashPos <-  gregexpr(pattern = "\\\\", xml[rawline])
    
    lastBackslash <- backslashPos[[1]][length(backslashPos[[1]])]
    
    rawDir <- substr(xml[rawline],
                     start = 15,
                     stop = lastBackslash)
    
    txtDir <- paste0(rawDir, "combined\\txt")
    
    currentResultDir <- paste0(resultDir,
                               "\\",
                               mqpars[1, 4],
                               "\\",
                               mqpars[1, 5],
                               "\\"
                               )
    
    dir.create(currentResultDir, recursive = TRUE)
    
    file.copy(from = txtDir,
              to = currentResultDir,
              recursive = TRUE)
    
    file.copy(from = mqpars[1,1],
              to = currentResultDir,
              recursive = TRUE)
    
    file.remove(mqpars[1,1])
    
    
  } else {
    
    print(paste0(Sys.time(),
                 "   no analysis queued, check again in 2 min "))
    
    Sys.sleep(120)
    
  }
  
}
    
  
  
  
  
  