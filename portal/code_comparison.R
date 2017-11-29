rm(list=ls())
gc()

User <- "username"
Pass <- "password"

library(data.table)
library(xlsx)
library(rvest)
library(XML)

setwd("C:\\GitHub\\r_methods\\portal")

# get local codes
wb <- loadWorkbook("Read_stroke.xlsx")
sheets <- getSheets(wb)

ExcelSheets <- rbindlist(
               lapply(names(sheets), 
               function(x)
               data.table(
               cbind(Sheet = x,
               read.xlsx("Read_stroke.xlsx", sheetName = x, stringsAsFactors = F)
               ))))
rm(wb, sheets)

head(ExcelSheets)
ExcelSheets <- split(ExcelSheets, by = "Disease")
lapply(ExcelSheets, head)

names(ExcelSheets)

# pick the relevant pages
# https://www.caliberresearch.org/portal/show/haem_stroke_gprd
# https://www.caliberresearch.org/portal/show/ischaemic_stroke_gprd
# https://www.caliberresearch.org/portal/show/stroke_nos_gprd

Portal_Var <- c("haem_stroke_gprd", "ischaemic_stroke_gprd", "stroke_nos_gprd") 

# log into the portal

url <- "https://www.caliberresearch.org/login"

#pg_session <- html_session(url)
#pg_form <- html_form(pg_session)[[1]]

filled_form <-
  set_values(html_form(html_session(url))[[1]],
             username = User,
             password = Pass)
login <- submit_form(html_session(url), filled_form)
rm(url, filled_form)

# get portal codes

Portal_Data <-  lapply(
                  lapply(Portal_Var,
                    function(x)
                    login %>%
                      jump_to(paste0("https://www.caliberresearch.org/portal/show/", x)) %>%
                        html_nodes(xpath = '//*[(@id = "tab2")]') %>% .[[1]] %>%
                          htmlParse() %>% 
                            readHTMLTable(stringsAsFactors = F)), "[[", 2)

Portal_Data <- lapply(Portal_Data, data.table)
Portal_Data <- lapply(Portal_Data, function(x)
                      setnames(x, old=names(x), new=gsub(" ","",names(x))))

names(Portal_Data) <- Portal_Var
lapply(Portal_Data, head)

# Compare code lists

# Subarachnoid haemorrhage

ExcelSheets$`Subarachnoid haemorrhage`[
  ExcelSheets$`Subarachnoid haemorrhage`$Medcode %in%
  Portal_Data$haem_stroke_gprd[grep("Subarachnoid haemorrhage", `Category(code)`, ignore.case = T)]$CPRDMedcode
]

table(
    ExcelSheets$`Subarachnoid haemorrhage`$Medcode %in%
    Portal_Data$haem_stroke_gprd[grep("Subarachnoid haemorrhage", `Category(code)`, ignore.case = T)]$CPRDMedcode
)

# Intracerebral haemorrhage

ExcelSheets$`Intracerebral haemorrhage`[
  ExcelSheets$`Intracerebral haemorrhage`$Medcode %in%
    Portal_Data$haem_stroke_gprd[grep("Intracerebral haemorrhage", `Category(code)`, ignore.case = T)]$CPRDMedcode
  ]

table(
  ExcelSheets$`Intracerebral haemorrhage`$Medcode %in%
    Portal_Data$haem_stroke_gprd[grep("Intracerebral haemorrhage", `Category(code)`, ignore.case = T)]$CPRDMedcode
)

# Ischaemic stroke

ExcelSheets$`Ischaemic stroke`[
  ExcelSheets$`Ischaemic stroke`$Medcode %in%
    Portal_Data$ischaemic_stroke_gprd[grep("Ischaemic stroke", `Category(code)`, ignore.case = T)]$Datasourcelookup
  ]

table(
  ExcelSheets$`Ischaemic stroke`$Medcode %in%
    Portal_Data$ischaemic_stroke_gprd[grep("Ischaemic stroke", `Category(code)`, ignore.case = T)]$Datasourcelookup
)

# Stroke NOS

ExcelSheets$`Stroke NOS`[
  ExcelSheets$`Stroke NOS`$Medcode %in%
    Portal_Data$stroke_nos_gprd[grep("Stroke NOS", `Category(code)`, ignore.case = T)]$Datasourcelookup
  ]

table(
  ExcelSheets$`Stroke NOS`$Medcode %in%
    Portal_Data$stroke_nos_gprd[grep("Stroke NOS", `Category(code)`, ignore.case = T)]$Datasourcelookup
)