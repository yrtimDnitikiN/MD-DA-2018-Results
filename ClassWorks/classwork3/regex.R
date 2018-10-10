#Загрузите данные о землятресениях
anss <- readLines("https://raw.githubusercontent.com/SergeyMirvoda/MD-DA-2018/master/data/earthquakes_2011.html", warn=FALSE)
anss
#Выберите строки, которые содержат данные с помощью регулярных выражений и функции grep
pattern<-"^\\d+/\\d+/\\d+\\s\\d+:\\d+:\\d+\\.\\d+,-?\\d+\\.\\d+,-?\\d+\\.\\d+,-?\\d+\\.\\d+,-?\\d+\\.\\d+,\\w+,\\d+,,,-?\\d+\\.\\d+,\\w+,\\d+$"
bool.result <- grepl(pattern, anss)
result <- regmatches(anss, regexpr(pattern, anss))

#Проверьте что все строки (all.equal) в результирующем векторе подходят под шаблон. 
all.equal(result, anss[bool.result])
