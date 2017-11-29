lipids <- c("ldl", "hdl", "tri", "chol")

for(j in seq_along(dbTableList)){
	for(i in seq_along(lipids)){
		if(any(grepl(lipids[i], colnames(dbTableList[[j]]), ignore.case = T))){
				print(cat("\n"))
				print(paste("table = ", names(dbTableList)[j]))
				print(grep(lipids[i], colnames(dbTableList[[j]]), ignore.case = T, value = T))}
	}
}
