#Файл необходимый для получения модели по котрой будет осуществляться предсказания
library("caret")
# Категоризируем данные по качеству 5 плохое качество, 6 - вино хорошего качества
# 7 наивысшее качество
w.p <- w.p[w.p$fixed.acidity > 5.5 & w.p$fixed.acidity < 8.5 &
		   w.p$volatile.acidity > 0.1 & w.p$volatile.acidity < 0.45 &
		   w.p$citric.acid > 0.15 & w.p$citric.acid < 0.5 &
		   w.p$residual.sugar < 16 &
		   w.p$chlorides > 0.02 & w.p$chlorides < 0.065 &
		   w.p$free.sulfur.dioxide < 70 & w.p$free.sulfur.dioxide > 5 &
		   w.p$total.sulfur.dioxide < 240 & w.p$total.sulfur.dioxide > 60 &
		   w.p$density < 1.00 & w.p$density > 0.989 &
		   w.p$pH > 2.8 & w.p$pH < 3.55 &
		   w.p$sulphates < 0.7 & w.p$sulphates > 0.3 &
		   w.p$alcohol > 8.5 & w.p$alcohol < 13,]

#550 - каждой категории вина кроме 3,4 и 8,9 так как слишком мало данных
#Делаем случайную выборку по 550 объектов чтобы метрика Accuracy была корректной
q5 <- w.p[w.p$quality == 5,]
q6 <- w.p[w.p$quality == 6,]
q7 <- w.p[w.p$quality == 7,]
q5 <- q5[sample(1:nrow(q5), 550, replace = FALSE),]
q6 <- q6[sample(1:nrow(q6), 550, replace = FALSE),]
q7 <- q7[sample(1:nrow(q7), 550, replace = FALSE),]

w.p <- rbind(q5, q6, q7)
w.p$quality <- factor(c("BAD", "GOOD", "GREAT")[w.p$quality - 4])

control <- trainControl(method="cv", number=10)
metric <- "Accuracy"
set.seed(13)
fit.rf <- train(quality ~ ., data = w.p, method = "rf", metric = metric, trControl = control)

