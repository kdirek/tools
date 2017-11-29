library(data.table)

# create fake data
set.seed(1)
dt = data.table(
  patid = sample(seq(1e3, 10e3, 1), size = 10e3, replace = T),
  eventdate = sample(seq(as.Date("1997-01-01"), as.Date("2010-03-25"), 1), size = 10e3, replace = T),
  category = sample(0:5, size = 10e3, replace = T)
)

var.win <- function(data, 
                    categories = NULL,
                    cat_col = "category",
                    event_date, window = 365, 
                    closest = FALSE){
  
  if(is.null(categories)){
    categories <- unique(data[, get(cat_col)])}

  output <- data[get(cat_col) %in% categories & 
                   eventdate >= event_date - window & 
                   eventdate <= event_date + window,
                   colnames(data), with = F]
  
  if(closest == FALSE){
    output <- output[output[,.I[which.min(eventdate)], patid]$V1,]
  }
  
return(output)
}

var.win(data = dt, 
        event_date = as.Date("2005-01-01"))

var.win(data = dt,
        event_date = as.Date("2005-01-01"), 
        closest = TRUE)
