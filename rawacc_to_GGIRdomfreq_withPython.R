# Script to explore how to embed Python code in GGIR
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

library("reticulate")
use_virtualenv("~/venv_GGIR", required = TRUE) # Local Python environment

source("~/rawacc2agc/externalfunctions/dominant_frequency.R")
myfun =  list(FUN=dominant_frequency,
              parameters= "~/rawacc2agc/externalfunctions/dominant_frequency.py",
              expected_sample_rate= 30,
              expected_unit="g",
              colnames = c("domfreqX", "domfreqY", "domfreqZ"),
              minlength = 5,
              outputres = 5,
              outputtype="numeric",
              aggfunction = median,
              timestamp=T)
datadir = "/media/vincent/data/Habitus/Ruben/acc_raw"
outputdir = "/media/vincent/projects/Habitus" #config$outputdir
studyname = "acc_raw" #config$studyname

g.shell.GGIR(mode=1:2,
             datadir=datadir,
             outputdir=outputdir,
             studyname=studyname,
             desiredtz="Europe/Brussels",
             f0=1,
             f1=1,
             overwrite = TRUE, #overwrite previous milestone data?
             do.report=c(2), #for what parts does and report need to be generated? (option: 2, 4 and 5)
             do.imp=TRUE, # Do imputation? (recommended)
             idloc=2, #id location (1 = file header, 2 = filename)
             print.filename=TRUE,
             storefolderstructure = TRUE,
             do.parallel = FALSE,
             chunksize=1,
             myfun=myfun,
             epochvalues2csv = TRUE,
             do.cal= TRUE,
             printsummary=TRUE,
             strategy = 1, #2, #Strategy (see tutorial for explanation)
             hrs.del.start = 0, # Only relevant when strategy = 2. How many HOURS need to be ignored at the START of the measurement?
             hrs.del.end = 0, # Only relevant when strategy = 2. How many HOURS need to be ignored at the END of the measurement?
             maxdur = 0, # How many DAYS of measurement do you maximumally expect?
             includedaycrit = 15, # number of minimum valid hours in a day to attempt physical activity analysis
             visualreport=FALSE)
