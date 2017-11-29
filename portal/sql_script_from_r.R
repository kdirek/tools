# script to create variables from existing SQL scripts

# ssh -L localhost:localserver:port server address  -N

library(RMySQL)

mydb <- dbConnect(
  MySQL(), 
  user     = "", 
  password = "",
  dbname = "",
  host     = "",
  port     = ""
)


dbListTables(mydb)

testfile <- "filename"

readLines(testfile)

dbSendQuery(mydb, paste0(readLines(testfile, warn = FALSE), collapse = ""))
           

dbListConnections(MySQL())
lapply( dbListConnections( dbDriver( drv = "MySQL")), dbDisconnect)
