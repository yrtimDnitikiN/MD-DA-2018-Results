11111111*11111111*1111111
lengths <- c(3,7,12,15, 20)
widths <- c(2, 5,8,11,15)
s <- lengths*widths
plot(lengths, widths)
learns <-c("english"=40,"math"=40,"sport"=10,"programming"=150)
barplot(learns)
drinks <-rnorm(5, mean = 450, sd = 4)
drinks > 455
manydrinks <- rnorm(10000, mean = 450, sd = 4)
length(manydrinks[manydrinks > 455])/length(manydrinks)
