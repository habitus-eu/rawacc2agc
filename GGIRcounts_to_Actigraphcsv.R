# Script to create imitated Actigraph file from counts in GGIR output
# These are used by PALMS.
#------------------------------------------------------------------------
rm(list=ls())
library(data.table)

# Specify GGIR output directory:
outputdir = "/media/vincent/projects/Habitus/output_acc_raw"

#------------------------------------------------------------------------
# Add folder for simulated actigraph output:
actigraphdir = paste0(outputdir,"/actigraph")
if (dir.exists(actigraphdir) == FALSE) {
  dir.create(actigraphdir)
}
# Load GGIR part 1 milestone files
rdafolder = paste0(outputdir,"/meta/basic")
rdafiles = dir(rdafolder, full.names = T)
desiredtz = "Europe/Brussels"
for (i in 1:length(rdafiles)) {
  load(rdafiles[i])
  
  # Extract windowsize
  tmp = as.POSIXlt(M$metashort$timestamp[1:2],format="%Y-%m-%dT%H:%M:%S%z",desiredtz)
  ws3 = as.numeric(difftime(tmp[2],tmp[1],units="secs"))
  
  # Create file header for the Actigraph file
  start = as.POSIXlt(M$metashort$timestamp[1],format="%Y-%m-%dT%H:%M:%S%z",desiredtz)
  starttime = unlist(strsplit(as.character(start), " "))[2]
  startdate = paste0(start$mday,"/",start$mon+1,"/",start$year+1900) #day month year 
  SN = which(rownames(I$header) == "Serial Number:")
  DT = which(rownames(I$header) == "Download Date")
  if (length(SN) > 0) {  
    serialnumber = unlist(strsplit(as.character(I$header[SN,1])," "))
    if (length(serialnumber) > 0) {
      serialnumber = serialnumber[which(nchar(serialnumber) == max(nchar(serialnumber)))]
    }
  } else {
    serialnumber = "notidentified"
  }
  if (length(DT) > 0) {  
    downloaddate = unlist(strsplit(as.character(I$header[DT,1])," "))
    if (length(downloaddate) > 0) {
      downloaddate =downloaddate[which(nchar(downloaddate) == max(nchar(downloaddate)))]
      splitdt = unlist(strsplit(downloaddate,"-"))
      if (length(splitdt) > 0) { # change - to / seperator
        downloaddate = paste0(splitdt[c(3:1)], collapse = "/") 
      }
    }
  } else {
    downloaddate = "notidentified"
  }
  header = c("------------ Data File Created By ActiGraph wGT3XPlus ActiLife v6.10.2 Firmware v2.2.1 date format M/d/yyyy Filter Normal -----------",
             paste0("Serial Number: ",serialnumber),
             paste0("Start Time ", starttime),
             paste0("Start Date ",startdate),
             "Epoch Period (hh:mm:ss) 00:00:15",
             paste0("Download Time ",starttime),
             paste0("Download Date ",downloaddate),
             "Current Memory Address: 0",
             "Current Battery Voltage: 4.03     Mode = 13",
             "--------------------------------------------------")
  # Aggregate GGIR counts per 15 minutes
  colsofinterest = c("countx","county","countz")
  counts5sec = M$metashort[,colsofinterest]
  counts5sec$timenum = floor(seq(0,nrow(counts5sec)-1,1)/((15*60)/ws3))
  # Assuming that count unit is counts/min, so we have sum the epochs per 15 minutes and then devide by 15
  counts15min = round( as.matrix(aggregate(counts5sec, by=list(counts5sec$timenum),sum)[,colsofinterest]) / 15)
  # Add dummy fourth column for which we do not have an estimate
  counts15min = cbind(counts15min,ifelse(test = counts15min[,2] > 200,yes = 1,no = 0))
  colnames(counts15min) = NULL
  # Append GGIR output
  counts15min = rbind(matrix("",length(header),ncol(counts15min)),counts15min)
  counts15min[1:length(header),1] = header
  # Store to csv file
  fname = unlist(strsplit(rdafiles[i],"eta_|[.]RD"))
  fname = fname[length(fname)-1]
  write.table(counts15min, file= paste0(actigraphdir,"/",fname),row.names = F, col.names = F,sep=",",fileEncoding="UTF-8")
}