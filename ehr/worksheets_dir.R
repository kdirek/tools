# read in multiple excel workbooks

#library(readxl)
library(XLConnect)

file.list <- list.files(pattern = "^Read.*\\.xlsx")

all_wb <- list()

for(i in file.list){
  
  wb <- loadWorkbook(paste0(getwd(), "/", i))
  lst = readWorksheet(wb, sheet = getSheets(wb))
  all_wb <- c(all_wb, lst)
}
  
# sort category column alphabetically

all_wb <- lapply(all_wb, data.table)

for(i in seq_along(all_wb)){
  colnames(all_wb[[i]])[grep("cat", colnames(all_wb[[i]]), ignore.case = T)] <- "Category"
}

for(i in seq_along(all_wb)){
  if(length(grep("Category", colnames(all_wb[[i]])))==1){
    setkey(all_wb[[i]], "Category")
  }
}
