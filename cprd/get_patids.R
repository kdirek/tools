setwd("R:\\Pop_Health\\EPH_CEG_CALIBER\\_KEEP\\16_152_Asthma_COPD")

subdir <- "asthma"

library(data.table)

file_list <- list.files(subdir, pattern = "_[0-9]{3,3}.txt$")

patid_list <- list()
patid_list <- lapply(
                list.files(subdir, pattern = "_[0-9]{3,3}.txt$"),
                function(x)
                fread(paste0(subdir, "\\", x), select = "patid")
)

length(patid_list) == length(file_list)

# bind list + keep unique patids

patid_vector <- rbindlist(patid_list)
nrow(patid_vector)
patid_vector <- unique(patid_vector)
nrow(patid_vector)

write.csv(patid_vector, quote = F, row.names = F,
          file = 
            paste0(subdir, "\\", 
              paste(subdir, "patid.csv", sep = "_")
              )
)
