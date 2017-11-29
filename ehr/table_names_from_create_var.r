# get table names
infect_scripts <- readLines("infect_scripts.sql")
sqlscripts <- "C:/GitHub/datalab/projects/CALIBER/datasets/external/17_048_Shallcross/scripts/infect/"
setwd(sqlscripts)
infect_scripts <- readLines("infect_scripts.sql")
tables <- trimws(grep("CREATE TABLE phenotype", infect_scripts, value = T, ))
tables <- gsub("CREATE TABLE | AS", "", tables)
tables <- paste(tables, letters[2:(length(tables)+1)])

# add patid match
x.patid <- paste0(
            trimws(
              regmatches(
                tables,
                  regexpr("[[:space:]][a-z]_[0-9]+",tables)
      )
    ), ".patid"
)

# OR lines + indentation
cat(paste0("a.patid = ", x.patid), sep= "\nOR\n\t")