library(xlsx)

# load data + get sheets
wb <- loadWorkbook("xlsx")
sheets <- getSheets(wb)

# import + export each sheet
paste0(names(sheets), ".master.1")

for(i in names(sheets)){
  
  tmp <-  read.xlsx("xlsx", sheetName = i)
 
  if(length(grep("_cprd$", colnames(tmp)[1], ignore.case = T))==1){
    colnames(tmp) <- c("metadata", "category", "readcode", "readterm", "medcode")} else
      if(length(grep("_hes$", colnames(tmp)[1], ignore.case = T))==1){
        colnames(tmp) <- c("metadata", "icd_code", "icd_term", "category")}
  
  write.csv(tmp, quote = T, row.names = F, file = paste0(i, ".master.1.csv"))
  
}



