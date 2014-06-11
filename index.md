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




