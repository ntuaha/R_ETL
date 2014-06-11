---
title       : R的ETL流程
subtitle    : 
author      : Cheng Yu Lin (aha)
job         : 
license     : by-sa
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
ext_widgets : {rCharts: libraries/nvd3}
widgets     : [mathjax, quiz, bootstrap]            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
---


## 故事的起源

> 1. 房價節節高升
> 2. 大熊被抓了
> 3. 房價真的太高了嗎?

--- &twocol

## 資料在哪裡

*** =left
### 你想知道什麼資料?

> 1. GDP
> 2. 房貸餘額
> 3. 股價
> 4. 新聞

*** =right
### 可能的來源?
> 1. 政府公開資料
> 2. 新聞
> 3. 股市


--- .quote

<q>即便知道資料在哪，可是資料還是如同`一盤散沙`</q>

---  

## ETL

> 1. Extraction
> 2. Transformation
> 3. Loading

--- 

## Extraction

### 讀入CSV

至少要記得的 `read.table`
```
DF = read.table(file='檔案路徑',sep=",",stringsAsFactors=F,header=T)
```
- 輸出形態為`Data Frame`
- file 就是指讀入的檔案路徑
- sep 指的是欄位分割用的符號,通常csv檔案格式是透過`,`做分割
- stringsAsFactors 預設是`True`, 會讓讀入的字串都用Factor形態儲存，那麼資料就會轉為整數儲存與額外的對照表
- header 預設是`False`，表示第一行是不是表格標頭，作為輸出的dataframe欄位名的colnames

---  .quote

<q> 開始動手做吧!</q>

--- .quote 

<q> 等等 先安裝幾個建議的套件</q>

> - `dplyr` 可用類似SQL語法操作data frome
> - `xts` 處理時間格式好用的套件
> - `gdata` 可以處理Excel 2007以上的文件


--- .quote 

<q> 等等 先安裝幾個建議的套件</q>

- `dplyr` 可用類似SQL語法操作data frome
- `xts` 處理時間格式好用的套件
- `gdata` 可以處理Excel 2007以上的文件

```
install.packages("dplyr")
install.packages("xts")
install.packages("gdata")
```


--- .quote

<q> 好! 開始動手做吧!</q>


--- .quote 

<q> 好! 開始動手做吧!</q>

<q> `資料勒？！`</q>

---

## 第一步:開始收集資料(房貸餘額)

<iframe src = 'https://survey.banking.gov.tw/statis/stmain.jsp?sys=100&funid=r100' height='600px'></iframe>

---
## 第一步:開始收集資料

### 房貸餘額,直接下載現成的csv檔案

直接到[https://raw.githubusercontent.com/ntuaha/TWFS/master/db/cl_info_other.csv](https://raw.githubusercontent.com/ntuaha/TWFS/master/db/cl_info_other.csv)下載檔案

### 將資料讀入

```
Cl_info = read.table(file='./cl_info_other.csv',header=T,sep=",",stringsAsFactors=F)
```


```r
Cl_info = read.table(file='./cl_info_other.csv',header=T,sep=",",stringsAsFactors=F)
str(Cl_info)
```

```
## 'data.frame':	9041 obs. of  14 variables:
##  $ etl_dt           : chr  "2013-11-26 22:30:07.971327" "2013-11-26 22:30:07.974241" "2013-11-26 22:30:07.979319" "2013-11-26 22:30:07.995118" ...
##  $ bank_code        : chr  "020       " "N000      " "809       " "146       " ...
##  $ data_dt          : chr  "2006-01-01 00:00:00" "2006-01-01 00:00:00" "2006-01-01 00:00:00" "2006-01-01 00:00:00" ...
##  $ bank_nm          : chr  "日商瑞穗實業銀行" "台北縣淡水第一信用合作社" "萬泰商業銀行" "台中市第二信用合作社" ...
##  $ mortgage_cnt     : num  0 9924 4051 11167 1551 ...
##  $ mortgage_bal     : num  0.00 1.69e+10 5.62e+09 1.89e+10 3.77e+09 ...
##  $ decorator_hse_cnt: num  0 173 1329 118 336 ...
##  $ decorator_hse_bal: num  0.00 1.83e+08 1.47e+09 9.70e+07 4.70e+08 ...
##  $ ln_car_cnt       : num  0 2 3128 11 178 ...
##  $ ln_car_bal       : num  0.00 1.00e+06 9.26e+08 0.00 4.70e+07 ...
##  $ ln_worker_cnt    : num  0 953 0 0 0 984 277 0 0 0 ...
##  $ ln_worker_bal    : num  0.00 3.72e+08 0.00 0.00 0.00 5.80e+08 6.10e+07 0.00 0.00 0.00 ...
##  $ other_cl_cnt     : num  0 1101 1697098 1027 2295 ...
##  $ other_cl_bal     : num  0.00 3.09e+08 7.61e+10 3.99e+08 5.15e+08 ...
```
