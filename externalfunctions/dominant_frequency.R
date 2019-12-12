dominant_frequency = function(data=c(), parameters=c()) {
  # data: 3 column matrix with acc data
  # parameters: the sample rate of data
  source_python(parameters)
  sf=30
  N = nrow(data)
  ws = 5 # windowsize
  if (ncol(data) == 4) {
    data= data[,2:4]
  }
  data = data.frame(t= floor(seq(0,(N-1)/sf,by=1/sf)/ws),
                    x=data[,1], y=data[,2], z=data[,3])
  df = aggregate(data, by = list(data$t), 
                 FUN=function(x) {return(dominant_frequency(x,sf))})
  df = df[,-c(1:2)]
  return(df)
}