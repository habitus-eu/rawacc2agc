calculateCounts = function(data=c(), parameters=c()) {
  # data: 3 column matrix with acc data
  # parameters: the sample rate of data
  library("activityCounts")
  if (ncol(data) == 4) {
    data= data[,2:4]
  }
  mycounts = counts(data=data, hertz=parameters, 
                    x_axis=1, y_axis=2, z_axis=3,
                    start_time = Sys.time())
  mycounts = mycounts[,2:4] #Note: do not provide timestamps to GGIR
  return(mycounts)
}