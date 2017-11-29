library(data.table)

setwd("your directory")

zipped_content <- lapply(list.files(pattern = "\\.zip$"), function(x) unzip(x, list = TRUE))
zipped_content <- rbindlist(zipped_content)

sapply(zipped_content, class)
setkey(zipped_content, Date)

zipped_content[, Name := unlist(lapply(strsplit(Name, split="^[0-9]{6}\\."), "[[", 2))]

cprd_list <- fread("file_check/cprd_file_list.csv") # copy + paste from the file list on cprd
cprd_list[, Date := strptime(Date, "%d/%m/%Y %R")] # ignore warning

sapply(cprd_list, class)
setkey(zipped_content, Date)

nrow(zipped_content)
nrow(cprd_list)

same <- merge(zipped_content, cprd_list, by = "Name")

nrow(same)
