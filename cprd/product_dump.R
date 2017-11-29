library(data.table)

product <- fread("product.txt")
product

drugs <- xxx

for(i in drugs){
  write.table(product[grep(i, V5, ignore.case = T),],
              quote = F, 
              sep = "\t", 
              row.names = F, 
              col.names = F, 
              file = paste0(getwd(), "/R03BC/", i, ".txt")
              )
}