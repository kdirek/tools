setwd("C:\\GitHub\\datalab\\projects\\CALIBER_2\\phenotype")
dir()


file.remove(
  list.files(pattern = "^empty.txt$", 
             path = "C:/GitHub/datalab/projects/CALIBER_2/phenotype/",
             recursive = TRUE, 
             full.names = TRUE)
)

# git clean -df to remove the untracked directories after changes have been pushed to github
