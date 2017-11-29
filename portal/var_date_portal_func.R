library(data.table)
library(rvest)
library(XML)

# create fake data
set.seed(1)
  dt = data.table(
      patid = sample(seq(1e3, 10e3, 1), size = 10e3, replace = T),
      eventdate = sample(seq(as.Date("1997-01-01"), as.Date("2010-03-25"), 1), size = 10e3, replace = T),
      category = sample(0:5, size = 10e3, replace = T)
      )

var.win.portal <- function(data,
                    variable,
                    categories = NULL,
                    cat_col = "category",
                    event_date, window = 90, 
                    closest = FALSE){

if(html_session(paste0("https://www.caliberresearch.org/portal/show/", variable))$url == 
  "https://www.caliberresearch.org/error"){
    print(paste0("Not found on the CALIBER portal: ", variable))} else {
  
var_cat <-  data.frame(
html_session(paste0("https://www.caliberresearch.org/portal/show/", variable)) %>% 
html_nodes(xpath = '//*[(@id = "tab1")]') %>% .[[1]] %>% 
htmlParse() %>% 
readHTMLTable(stringsAsFactors = F)
)

if(is.null(categories)){
  categories <- unique(data[, get(cat_col)])}

  if(any(categories %in% var_cat$NULL.Name)){
  
  output <- data[get(cat_col) %in% categories & 
                     eventdate >= event_date - window & 
                     eventdate <= event_date + window,
                     colnames(data), with = F]

  if(closest == TRUE){
    output <- output[output[,.I[which.min(eventdate)], patid]$V1,]
    }

return(output)
  } else {
    print("No categories found on the CALIBER portal")}

  }
}

var.win.portal(data= dt, 
               variable = "copd_hes", 
               event_date = as.Date("2005-01-01"))

var.win.portal(data= dt, 
               variable = "copd_hes", 
               event_date = as.Date("2005-01-01"),
               closest = TRUE)