etl_presentation
========================================================
author: 陳嘉葳
date: 

需要的 package
========================================================

```r
library(RSelenium)
library(stringr)
library(reshape2)
library(xts)
```

打開 phantom
========================================================

```r
require(RSelenium)

pJS <- phantom()
Sys.sleep(5) # give the binary a moment
remDr <- remoteDriver(browserName = 'phantomjs')
remDr$open()
```

開始抓新聞
========================================================

```r
title <- list()

for(i in 1:10){
  url <- sprintf('https://tw.news.yahoo.com/real-estate/archive/%d.html', i)
  remDr$navigate(url)
  doc <- remDr$findElements("xpath", "//ul/li/div/div/h4/a")
  tmp <- sapply(doc, function(doc){
    doc$getElementText()})
  title <- append(title, tmp)
} 
```

讀寫表格資料
========================================================

```r
setwd('~/R_ETL/jiawei/)
doc <- do.call(rbind, title)
writeLines(doc, "news_yahoo.txt")
news_yahoo <- readLines('news_yahoo.txt')
```

匯入這次用的資料
========================================================
```r
setwd('~/R_ETL/jiawei/')
hourse_news <- readLines('news.txt')
```

抓出 時間 與 文章
========================================================

```r
dates <- str_extract(hourse_news, "\\d{4}-\\d{2}-\\d{2}")
titles <- str_replace(hourse_news, "\\d{4}-\\d{2}-\\d{2}", "")
hourse_news <- cbind(dates, titles)

```


找出單字
========================================================
```r
ngram <- function(sentence, n){
  chunk <- c()
  for(i in 1 : (nchar(sentence)-n+1)){
    chunk <- append(chunk, substr(sentence, i, i+n-1))
  }
  return(chunk)
}
```
找出單字
========================================================

```r
piece <- c()

for(i in 1:length(hourse_news)){
  piece <- append(piece, ngram(titles[i], 1))
  piece <- append(piece, ngram(titles[i], 2))
  piece <- append(piece, ngram(titles[i], 3))
  piece <- append(piece, ngram(titles[i], 4))
  piece <- append(piece, ngram(titles[i], 5))
  piece <- append(piece, ngram(titles[i], 6))
}

```

清除符號 (只是列出來，並沒有要做)
========================================================

```r
#punctuation <- "\u3002|\uff1b|\uff0c|\uff1a|\u201c|\u201d|\uff08|\uff09|\u3001|\uff1f|\u300a|\u300b"
#piece_clean <- str_replace_all(piece, punctuation, "")
#piece_clean <- str_replace_all(piece_clean, "[[:punct:]]", "")
#piece_clean <- str_replace_all(piece_clean, "[[:blank:]]", "")
#piece_clean <- str_replace_all(piece_clean, " ", "")
piece_clean <- piece

```
算 單字 出現次數
========================================================
```r
word_freq <- table(piece_clean)
```
分出 單字長度 區塊
========================================================
```r
words_length <- 
list(
"1" = names(word_freq[nchar(names(word_freq))==1]),
"2" = names(word_freq[nchar(names(word_freq))==2]),
"3" = names(word_freq[nchar(names(word_freq))==3]),
"4" = names(word_freq[nchar(names(word_freq))==4]),
"5" = names(word_freq[nchar(names(word_freq))==5]),
"6" = names(word_freq[nchar(names(word_freq))==6])
)
```
算出機率
========================================================
```r
N <- sum(word_freq[words_length[['1']]])
words_weight <- word_freq / N
```

單字分離
========================================================
```r
segmentWord <- function(word){
  n <- nchar(word)-1
  seg <- lapply(1: n, function(i){
    w1 <- substr(word, 1, i)
    w2 <- substr(word,i+1, n+1)
    c(w1,w2)
  })
  return(seg)
}
```

算出凝聚度
========================================================
```r
cohesion <- function(word){
  seg <- segmentWord(word)
  val <- sapply(seg, function(x){    
    f_word <- word_freq[word]
    f_x1 <- word_freq[x[1]]
    f_x2 <- word_freq[x[2]]
    mi <- log2(N) + log2(f_word) - log2(f_x1) - log2(f_x2)
    return(mi)
  }) 
  return (min(val))
}
```

算出單字左右亂度
========================================================

```r
disorder <- function(word){
  
  BASE <- words_length[[as.character(nchar(word)+1)]]
  
  PATTEN1 <- paste("^", word, sep = '')
  matchs1 <- grep(PATTEN1, BASE, value = TRUE)
  pre <- mean(-log2(words_weight[matchs1]))
  
  PATTEN2 <- paste(word, "$", sep = '')
  matchs2 <- grep(PATTEN2, BASE, value = TRUE)
  post <- mean(-log2(words_weight[matchs2]))
  
  index <- is.na(c(pre, post))
  condition <- any(index)
  return(ifelse(condition, c(pre, post)[index], min(pre, post)))
  
}
```

挑出 單字
========================================================

```r
word_2_5 <- unlist(words_length[2:5])
plot(word_freq[word_2_5])
words <- names(which(word_freq[word_2_5] > 2))

disorder_val <- sapply(words, disorder, USE.NAMES = FALSE)
names(disorder_val) <- words
sort(disorder_val)
plot(disorder_val)
test_words <- names(which(disorder_val > 12))

cohesion_val <- sapply(test_words, cohesion, USE.NAMES = FALSE)
names(cohesion_val) <- test_words
sort(cohesion_val)
plot(cohesion_val)
test_words_2 <- names(which(cohesion_val > 2))

```

算出單字 每個時間點的 出現次數
========================================================
```r
tmp <- lapply(test_words_2, function(word) str_count(titles, word))
words_tbl <- do.call(cbind, tmp)
colnames(words_tbl) <- test_words_2

```
算出單字 每個時間點的 出現次數
========================================================

```r
words_tbl_xts <- xts(words_tbl, as.POSIXct(dates))

```
下載營建股 股票指數
========================================================
營建股清單
http://www.wantgoo.com/stock/classcont.aspx?id=32

```r
library('quantmod')
f = file('~/stock.csv', encoding='utf-8')
stock <- read.csv(f, stringsAsFactors=FALSE)

stock_no <- stock[,1]
stock_name <- stock[,2]
stock_code <- paste(stock_no, '.TW', sep='')
```

開始下載
========================================================

```r
getSymbols(stock_code, env=mystocks, from="2014-01-01", to="2014-07-02")
mystocks <- do.call(cbind,eapply(mystocks, Cl))
names(mystocks) <- stock_name
saveRDS(mystocks, "mystocks.rds")
```

算出某段時間 股票的平均收入
========================================================
```r
mystocks <- readRDS('~/R_ETL/jiawei/mystocks.rds')
mystocks.return <- diff(mystocks, 1) / mystocks
mystocks.return_all <- apply(mystocks.return[-1,], 1, mean)
```

找出股票漲跌的五個狀態
========================================================

```r
cl <- kmeans(mystocks.return_all, 5)
return.status <- data.frame(cl$cluster)

for(i in 1:5){
  print (mean(mystocks.return_all[cl$cluster == i]))
}

```

欄位旋轉
========================================================
```r
return_date <- rownames(return.status)
return.status <- cbind(return_date, return.status)
return.status <- cbind(return.status, rep(1,127))

return.status <- dcast(return.status, return_date  ~ cl.cluster, fill = 0)
return.status <- data.frame(return.status,stringsAsFactors=FALSE)
return.status.xts <- xts(return.status[,-1], as.POSIXct(return_date))
```

單字 和 股票 依據時間合併
========================================================

```r
final_tbl <- merge.xts(words_tbl_xts, return.status.xts, fill=0)
names(final_tbl) <- c(test_words_2, names(return.status[,-1]))

```

算 彼此之間的相關度
========================================================

```r
tbl_cov <- cov(final_tbl)
d <- dist(t(final_tbl))
d2 <- as.matrix(dist(t(final_tbl),  method = "manhattan"))

head(sort(d2[,'X1']), 30)

kw <- list()
for(i in 1:5){
  col <- sprintf("X%s", i)
  kw <- cbind(kw, names(head(sort(d2[,col]), 30)))
}
```

看看營建股價上升/下降時, 對應哪些新聞標題
========================================================

```r
index <- str_extract(titles, "房貸|所得")
titles[!is.na(index)]

sindex <- str_extract(titles, "店租|標脫")
titles[!is.na(index)]

PATTEN <- paste(kw[1:10,4],collapse = '|')
index <- str_extract(titles, PATTEN)
titles[!is.na(index)]
```

視覺呈現
========================================================

```r
fit <- cmdscale(d2, eig = TRUE, k=2)
x <- fit$points[,1]
y <- fit$points[,2]
plot(x, y, xlab="Coordinate 1", ylab="Coordinate 2", type = "n")
text(x, y, labels = row.names(t(final_tbl)), cex=.7)

```
