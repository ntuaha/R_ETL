<<<<<<< HEAD
R_ETL
=====

提供Ｒ_ETL教學使用
=======
# 使用指令

1. 安裝`R`
2. 安裝`RStudio`
3. 安裝`slidify` package
4. include package

	```r
	library(slidify)
	```

5. 指定工作目錄

	```r
	author(deckdir="工作目錄",use_git="要不要開新的Repository,預設要",open_rmd="要不要幫開Rmd檔案")
	```


6. 編譯Rmd
	```r
	slidify("index.Rmd")
	publish(user="你的Github帳號",repo="Github上的專案名稱",host="github")
	```
>>>>>>> 1e3d85cb39e162511c074996a61df3bd272c1cc2
