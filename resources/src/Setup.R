#安裝slidy
#install.packages("devtools")
library(devtools)
#install_github('slidify', 'ramnathv')
#install_github('slidifyLibraries', 'ramnathv')
#install.packages("knitr")

#pkgs <- c("slidify", "slidifyLibraries", "rCharts")
#devtools::install_github(pkgs, "ramnathv", ref = "dev")


#初始化
library(slidify)
#setwd("path/to/folder")
#author(deckdir="Volumes/AhaStorage/Project/R")
author(deckdir="Volumes/AhaStorage/Project/R",use_git=FALSE,open_rmd=FALSE)

#git remote add wush https://github.com/wush978/TwRUserSlidifyTemplate.git
#git fetch wush
#git checkout gh-pages
#git merge remote/wush/master
slidify("index.Rmd");publish(user = "ntuaha", repo = "R_ETL_LAB", host = 'github')


#第一步
slidify("index.Rmd")
#更新
publish(user = "ntuaha", repo = "R_ETL_LAB", host = 'github')

#Commands
library(dplyr)
Cl_info_part = select(Cl_info,data_dt,bank_nm,mortgage_bal)
Cl_info_part2 = filter(Cl_info,mortgage_bal>1000000)

Cl_info_part5 = mutate(Cl_info,time=data_dt) #已看過
Cl_info_part6 = group_by(Cl_info_part5,time) #先匯總
Cl_info_part7 = summarise(Cl_info_part6,
                          mortage_total_bal = sum(mortgage_bal, na.rm = TRUE),
                          mortage_total_cnt = sum(mortgage_cnt,na.rm=TRUE))


