library(datasets)
library(ggplot2)

# get data
rdata <- data()$results
data.list <- as.list(lapply(strsplit(rdata[,"Item"], "[[:space:]]"), "[[", 1))
names(data.list) <- unlist(data.list)

for(i in seq_along(data.list)){
  data.list[[i]] <- get(data.list[[i]], envir = .GlobalEnv)
}
data.list <- data.list[unlist(lapply(data.list, class)) %in% "data.frame"] # drop anything not a df, e.g. matrix, array, table
lapply(data.list, class)

# explore data
lapply(data.list, function(x) sapply(x, class))

# midwest has good mix of classes + pid
sapply(data.list[["midwest"]], class)
head(data.list[["midwest"]])
temp <- data.list[["midwest"]]
temp$date <- sample(seq(as.Date('2010/01/01'), as.Date('2015/01/01'), by="day"), nrow(temp), replace = T)

# plot data
for(j in seq_along(data.list)){
  for(i in 2:ncol(temp)){
    
    dbplot <- ggplot(temp, aes(x = temp[,i])) + labs(title = names(data.list)[j], x = colnames(temp)[i])
  
  if(any(c("integer", "numeric", "Date") %in% class(temp[,i]))) {
    print(dbplot + geom_histogram())} else
        print(dbplot + geom_bar())
  }
}
