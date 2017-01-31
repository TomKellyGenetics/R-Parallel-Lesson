# This lesson assumes you are familiar with repeating operations in loops
# e.g.:

for(ii in 1:10){
  print(ii^2)
}

# Clearly for more iterations or more complex functions this could soon take a considerable amount of time:

max_n <- 100
vector <- rep(NA, max_n)

system.time({
  for(ii in 1:max_n){
    vector[ii] <- ii^2
  }
})

for(max_n in c(100, 1000, 10000, 100000)){
  print(max_n)
  print(system.time({
    for(ii in 1:max_n){
      vector[ii] <- ii^2
    }
  }))
}


#apply functions
max_n <- 100
vector <- lapply(1:max_n, function(x) x^2) #create list
vector <- sapply(1:max_n, function(x) x^2) #create vector
vector


system.time({
  for(ii in 1:max_n){
    vector <- lapply(1:max_n, function(x) x^2) #create list
  }
})

system.time({
  for(ii in 1:max_n){
    vector <- sapply(1:max_n, function(x) x^2) #create vector
  }
})

for(max_n in c(100, 1000, 10000, 100000)){
  print(max_n)
  print(system.time({
    vector <- sapply(1:max_n, function(x) x^2) #create vector
  }))
}

#vectorisation
max_n <- 100
vector <- 1:max_n
vector <- vector^2
vector

for(max_n in c(100, 1000, 10000, 100000)){
  print(max_n)
  print(system.time({
      vector <- 1:max_n
      vector <- vector^2
  }))
}

#parallelisation (if iterations independent)
library("snow") #simple network of workstations

cl <- makeSOCKcluster(2) # number of cores
#makeMPIcluster(2)
#makeCluster(2)
clusterExport(cl, list=ls())

max_n <- 100
vector <- parLapply(cl, 1:max_n, function(x) x^2) #create list
vector <- unlist(vector)
vector

system.time({
  vector <- parLapply(cl, 1:max_n, function(x) x^2) #create list
  })
stopCluster()

cl <- makeSOCKcluster(2) # number of cores
clusterExport(cl, list=ls())
for(max_n in c(100, 1000, 10000, 100000)){
  print(max_n)
  print(system.time({
    vector <- parLapply(cl, 1:max_n, function(x) x^2) #create list
  }))
}
stopCluster(cl)

cl <- makeSOCKcluster(3) # number of cores
clusterExport(cl, list=ls())
for(max_n in c(100, 1000, 10000, 100000)){
  print(max_n)
  print(system.time({
    vector <- parLapply(cl, 1:max_n, function(x) x^2) #create list
  }))
}
stopCluster(cl)
#increase in speed near linear

#Note "overhead time" to set up cluster
system.time({
  cl <- makeSOCKcluster(2) # number of cores
  #makeMPIcluster(2)
  #makeCluster(2)
  clusterExport(cl, list=ls())
  stopCluster(cl)
})

for(max_n in c(100, 1000, 10000, 100000)){
  print(max_n)
  print(system.time({
    cl <- makeSOCKcluster(2) # number of cores
    clusterExport(cl, list=ls())
    vector <- parLapply(cl, 1:max_n, function(x) x^2) #create list
    stopCluster(cl)
  }))
}

for(max_n in c(100, 1000, 10000, 100000)){
  print(max_n)
  print(system.time({
    cl <- makeSOCKcluster(3) # number of cores
    clusterExport(cl, list=ls())
    vector <- parLapply(cl, 1:max_n, function(x) x^2) #create list
    stopCluster(cl)
    }))
}
#diminishing returns in practice


################################
##       Question Time        ##
################################

max_n <- 100

#for loop
for(ii in 1:max_n){
  print(ii^2)
}

#lapply
vector <- lapply(1:max_n, function(x) x^2) #create list

#parLapply on 2 cores
cl <- makeSOCKcluster(2) # number of cores
clusterExport(cl, list=ls())
vector <- parLapply(cl, 1:max_n, function(x) x^2) #create list
stopCluster(cl)

#setup data
dataset <- matrix(rnorm(600), 60, 10)
head(dataset)

#for loop:
mg_data <- matrix(NA, nrow(dataset)/3, ncol(dataset))
for(ii in 1:(nrow(mg_data))){
  mg_data[ii,] <- svd(dataset[(ii-1)*3+1:3,])$v[,1]
}

#make an lapply loop
mg_data <- matrix(NA, nrow(dataset)/3, ncol(dataset))
mg_data <-lapply(1:(nrow(mg_data)), function(ii){
  ##fill in function
})
mg_data <- t(as.data.frame(mg_data))

#make it parallel
cl <- makeSOCKcluster(2) # number of cores
clusterExport(cl, list=ls())
mg_data <- matrix(NA, nrow(dataset)/3, ncol(dataset))
mg_data <-parLapply(#here, #here, function(ii){
  #here
  })
mg_data <- t(as.data.frame(mg_data))
stopCluster(cl)

################################
##       Question Time        ##
################################

#Running scripts

source("loop_script.R")

system("Rscript loop_script.R")
library("data.table")
mg_data <- fread("mg_data.csv", data.table = F)
head(mg_data)
dir()

##passing arguments to Rscripts

system("Rscript loop_script_Rstudio_generic.R 3 100")
library("data.table")
mg_data <- fread("mg_data.csv", data.table = F)
head(mg_data)
dim(mg_data)
dir()

for(ii in c(10, 20, 30)){
  system(paste("Rscript loop_script_Rstudio_generic.R 3", ii))
}
dir()

#passing arguments to bash

system("bash loop_script_generic.sh 3 80")
dir()

system("bash loop_script_generic.sh 3 2..5 10 15")
dir()

##Running scripts in the background
system("nohup Rscript loop_script_Rstudio_generic.R 3 100 &")
system("nohup bash loop_script_generic.sh 3 2..5 10 15 &")

#Running R on the cluster
system("sbatch loop_script_generic.sl 3 105")
system("sbatch loop_script_generic_array.sl 3 35 45 55")


#Remote access

system("rsh pan") #remote shell
system("rcp loop_script_generic_array.sl pan:/projects/uoo00010/test_dir") #remote copy

## "secure shell"
system("ssh pan")
system("scp loop_script_generic_array.sl pan:/projects/uoo00010/test_dir")
## sync (move changes)
system("rsync -u loop_script_generic_array.sl pan:/projects/uoo00010/test_dir")

##ssh alias
system("cat ~/.ssh/config")
system("ssh simon.kelly@login.uoa.nesi.org.nz")
system("ssh pan")

system("ssh biochembioinfo.otago.ac.nz")
system("ssh bio")

#NeSI Set Up (Wiki) for Otago Users
##https://github.com/dannybaillie/NeSI

#Install R packages on NeSI
##https://github.com/TomKellyGenetics/install.nesi

#Notes for this guide
##https://github.com/TomKellyGenetics/R-Parallel-Lesson