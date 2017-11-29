$file = "C:\test\empty.txt"
$dir = "C:\GitHub\datalab\projects\CALIBER_2\phenotype"

#Store in sub directories
dir $dir -recurse | % {copy $file -destination $_.FullName}
#Store in the directory
copy $file -destination $dir