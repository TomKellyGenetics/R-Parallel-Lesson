args <- commandArgs()
cores <- as.numeric(args[1])
sample_size <- strtoi(args[2])
print(args)
str(sample_size)

library("snow")
dataset <- matrix(rnorm(60*sample_size), 60, sample_size)
cl <- makeSOCKcluster(cores) # number of cores
clusterExport(cl, list=ls())
mg_data <- matrix(NA, nrow(dataset)/3, ncol(dataset))
mg_data <-parLapply(cl, 1:(nrow(mg_data)), function(ii){
  svd(dataset[(ii-1)*3+1:3,])$v[,1]
})
mg_data <- t(as.data.frame(mg_data))
stopCluster(cl)

write.csv(mg_data, file=paste0("mg_data_", cores, "core_", sample_size, "N.csv"))
