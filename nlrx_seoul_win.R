#Sys.setenv(JAVA_HOME='/usr/local/software/spack/spack-0.11.2/opt/spack/linux-rhel7-x86_64/gcc-5.4.0/jdk-8u141-b15-p4aaoptkqukgdix6dh5ey236kllhluvr/jre') #Ubuntu cluster
#Sys.setenv(JAVA_HOME= "/home/hs621/jdk1.8.0_212-amd64/jre")
#Sys.setenv(JAVA_HOME= "C:/Program Files/Java/jre1.8.0_231/lib")

## Load packages
library(nlrx)
library(tidyverse) 
library(rcartocolor)
library(ggthemes) 


# Windows 
#netlogopath <- file.path("d:/Program Files/NetLogo 6.1.1/")
netlogopath <- file.path("c:/Program Files/NetLogo 6.0.4/")
outpath <- file.path("d:/out")



## Step1: Create a nl obejct:
nl <- nl(nlversion = "6.1.1",
         nlpath = netlogopath,
         modelpath = file.path("D:/Dropbox (Cambridge University)/2019_Cambridge/[Programming]/Netlogo/Dissertation_Chapter4/St111261_Gangnam.nlogo"),
         jvmmem = 1024)


## Step2: Add Experiment
nl@experiment <- experiment(expname = "seoul",
                            outpath = outpath,
                            repetition = 1,   
                            tickmetrics = "true",
                            idsetup = "setup",  
                            idgo = "go",        
                            runtime = 8764,
                            evalticks=seq(4382, 8764),# by = 100),
                            constants = list("PM10-parameters" = 100,
                                             "Scenario" = "\"BAU\"",
                                             "scenario-percent" = "\"inc-sce\"",
                                             "AC" = 100),
                            #variables = list('AC' = list(values=c(100,150,200))),
                            metrics.turtles =  list("people" = c("xcor", "ycor", "homename", "destinationName", "age", "health"))
                            #metrics.patches = c("pxcor", "pycor", "pcolor")
)

# Evaluate if variables and constants are valid:
eval_variables_constants(nl)

#nl@simdesign <- simdesign_distinct(nl = nl, nseeds = 1)
nl@simdesign <- simdesign_simple(nl = nl, nseeds = 1)

# Step4: Run simulations:
init <- Sys.time()
results <- run_nl_all(nl = nl)
Sys.time() - init


# Attach results to nl object:
setsim(nl, "simoutput") <- results

# Report spatial data:
results_unnest <- unnest_simoutput(nl)


# Write output to outpath of experiment within nl
#write_simoutput(nl)

# Do further analysis:
#analyze_nl(nl)

rm(nl)
save.image(paste("seoul_", results$`random-seed`[1], ".RData", sep = ""))
