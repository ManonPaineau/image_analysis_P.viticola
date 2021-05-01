
#
#		R script aiming to measure the sporulation area (in percentage) of Downy mildew sporulation on grapevine leaf discs

#				by: Manon PAINEAU
#				published in:
#       link: 

# sporulation percentage calculation from files obtained with the ImageJ macro



#package
library(stringr)


#stwd :
setwd("write/your/path/to/your/working/directory/tutorial/Results_recuperation_R")

#data
data_AreaDisk<-read.csv2("report_disk_area.csv",sep=",",h=T,quote="",dec=".",na.strings = "NA")
data_AreaSpo<-read.csv2("results.csv",sep=",",h=T,quote="",dec=".",na.strings = "NA")


#identificationDisk
identificationDisk<-data_AreaSpo[1]
IDdisk <- data.frame(do.call('rbind', strsplit(as.character(identificationDisk$Slice),'-',fixed=TRUE)))  
IDdisk<-IDdisk[-3]
colnames(IDdisk)<-c("ImageName", "location")

#areaDisk
areaDisk<-data_AreaDisk[2]

#areaSpo
areaSpo<-data_AreaSpo[3]

#Sporulation percentage
SporulationResults<-cbind(IDdisk, areaDisk, areaSpo)
colnames(SporulationResults)<-c("ImageName", "location","areaDisk", "areaSpo")
SporulationResults$SporulationPercentage<-SporulationResults$areaSpo/SporulationResults$areaDisk*100
SporulationResults$SporulationPercentage<-round(SporulationResults$SporulationPercentage, digits = 2)
hist(SporulationResults$SporulationPercentage)

#saving
write.table(SporulationResults, "SporulationResults.csv", row.names=FALSE, sep=";",dec=".", na=" ")
