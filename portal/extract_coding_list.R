# Get categories from portal

library(data.table)
library(rvest)
library(XML)
 
url <- "https://www.caliberresearch.org/login"

pg_session <- html_session(url)
pg_form <- html_form(pg_session)[[1]]

filled_form <-
   set_values(pg_form,
    `username` = "YOUR USERNAME",
    `password` = "YOUR PASSWORD")
login <- submit_form(pg_session, filled_form)

variable <- "ethnic_gprd"

code_list <-
  login %>% jump_to(paste0("https://www.caliberresearch.org/portal/show/", variable)) %>%
  html_nodes(xpath = '//*[(@id = "tab2")]') %>% .[[1]] %>% htmlParse() %>% readHTMLTable(stringsAsFactors = F)
code_list <- data.table(code_list[[2]])

