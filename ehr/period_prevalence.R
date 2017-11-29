# calculate period prevalence in EHR
# https://www.cdc.gov/ophss/csels/dsepd/ss1978/lesson3/section2.html

library(data.table)
library(lubridate)
set.seed(1)

# data
test1 <- data.table(patid = 1:1e3,
                    start = sample(
                    seq(as.Date("1999-01-01"), as.Date("2010-01-01"), 1),
                    replace = T, size = 1e3))

test1[, end := start + sample(1:1e3, replace = T, size = nrow(test1))]

test1[, case := rbinom(nrow(test1), 1, 0.1)]
table(test1$cases)

test1$eventdate <- NA
test1$eventdate[test1$case == 1] <-
  runif(length(which(test1$case == 1)),
        test1$start[test1$case == 1],
        test1$end[test1$case == 1])
test1[, eventdate := as.Date(eventdate, origin = as.Date("1970-01-01"))]


doi <- interval(as.Date("2000-01-01"), as.Date("2000-12-31"))

all <- interval(test1$start, test1$end) # denominator
status <- interval(test1$eventdate, test1$end) # numerator

table(int_overlaps(all, doi))
table(int_overlaps(status, doi))

round(100 * as.numeric(
          table(int_overlaps(status, doi))["TRUE"] /
            table(int_overlaps(all, doi))["TRUE"])
      , 2) # period prevalence
