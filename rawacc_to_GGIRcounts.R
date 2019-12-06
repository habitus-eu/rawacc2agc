# Script to read raw accelerometer data, apply activityCounts package, and store the counts in the output
rm(list=ls())
# library(GGIR)
# load functions directly from local clone of the R package repository
dirR = "/home/vincent/GGIR/R"
ffnames = dir(dirR) # creating list of filenames of scriptfiles to load
for (i in 1:length(ffnames))  source(paste(dirR,"/",ffnames[i],sep="")) #loading scripts for reading geneactiv data
# library("Rcpp")
# pathR = "/home/vincent/GGIR"
# sourceCpp(paste0(pathR,"/src/numUnpack.cpp"))
# sourceCpp(paste0(pathR,"/src/resample.cpp"))


source(paste0(getwd(),"/home/vincent/rawacc2agc/externalfunctions/exampleExtFunction.R"))

myfun =  list(FUN=exampleExtFunction,
              parameters = 30, # sample rate is a parameter for the external function
              expected_sample_rate= 30, # needed for resampling
              expected_unit="g",
              colnames = c("countx","county","countz"),
              minlength = 5,
              outputres = 1,
              outputtype="numeric", #"numeric" (averaging is possible), "category" (majority vote)
              aggfunction = sum)

datadir = "/media/vincent/data/Habitus/Ruben/acc_raw"
outputdir = "/media/vincent/projects/Habitus"
studyname = "acc_raw"

g.shell.GGIR(mode=1,
             datadir=datadir, #specify above
             outputdir=outputdir, #specify above
             studyname=studyname, #specify above
             f0=1, #specify above
             f1=1, #specify above
             overwrite = TRUE, #overwrite previous milestone data?
             do.report=c(), #for what parts does and report need to be generated? (option: 2, 4 and 5)
             idloc=2, #id location (1 = file header, 2 = filename)
             print.filename=TRUE,
             storefolderstructure = TRUE,
             do.parallel = FALSE,
             myfun=myfun,
             epochvalues2csv = TRUE,
             windowsizes = c(5,900,3600), #Epoch length, non-wear detection resolution, non-wear detection evaluation window
             do.cal= TRUE, # Apply autocalibration? (recommended)
             chunksize=1, #size of data chunks to be read (value = 1 is maximum)
             printsummary=TRUE,
             visualreport=FALSE)
