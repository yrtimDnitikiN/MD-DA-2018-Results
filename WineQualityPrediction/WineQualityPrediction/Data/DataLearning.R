#Файл описывает как подготавливались данные и как выбирался подходящий алгоритм
install.packages("caret")
install.packages("ellipse")
install.packages("e1071")
install.packages("randomForest")

library(caret)

w.p <- read.csv("/home/dmitry/Рабочий стол/winequality-white.csv")
#Изучаем устройство данных чтобы избавиться от выбросов
hist(w.p$fixed.acidity)#>5.5&<10
hist(w.p$volatile.acidity)#>0.1&<0.8
hist(w.p$citric.acid)#<0.8
hist(w.p$residual.sugar)#<20
hist(w.p$chlorides)#<0.17
hist(w.p$free.sulfur.dioxide)#<90
hist(w.p$total.sulfur.dioxide)
hist(w.p$density)
hist(w.p$pH)#<3.7
hist(w.p$sulphates)
hist(w.p$alcohol)#>8.5
#Избавляемся от выбросов
w.p <- w.p[w.p$fixed.acidity>5.5&w.p$fixed.acidity<8.5&
           w.p$volatile.acidity>0.1&w.p$volatile.acidity<0.45&
           w.p$citric.acid>0.15&w.p$citric.acid<0.5&
           w.p$residual.sugar<16&
           w.p$chlorides>0.02&w.p$chlorides<0.065&
           w.p$free.sulfur.dioxide<70&w.p$free.sulfur.dioxide>5&
           w.p$total.sulfur.dioxide<240&w.p$total.sulfur.dioxide>60&
           w.p$density<1.00&w.p$density>0.989&
           w.p$pH>2.8&w.p$pH<3.55&
           w.p$sulphates<0.7&w.p$sulphates>0.3&
           w.p$alcohol>8.5&w.p$alcohol<13,]

#550 - каждой категории вина кроме 3,4 и 8,9 так как слишком мало данных
#Делаем случайную выборку по 550 объектов чтобы метрика Accuracy была корректной
q5 <- w.p[w.p$quality == 5,]
q6 <- w.p[w.p$quality == 6,]
q7 <- w.p[w.p$quality == 7,]
q5 <- q5[sample(1:nrow(q5),550,replace=FALSE),]
q6 <- q6[sample(1:nrow(q6),550,replace=FALSE),]
q7 <- q7[sample(1:nrow(q7),550,replace=FALSE),]
#Формируем dataframe с данными без выбросов
w.p <- rbind(q5, q6, q7)
w.p$quality <- factor(c("BAD","GOOD","GREAT")[w.p$quality-4])
percentage <- prop.table(table(w.p$quality)) * 100
cbind(freq=table(w.p$quality), percentage=percentage)
#Cоздаем тестовый и тренирововочный наборы данных
validation_index <- createDataPartition(w.p$quality, p=0.80, list=FALSE)
validation <- w.p[-validation_index,]
w.p <- w.p[validation_index,]

#Анализ: будем запускать все алгоримы и проерять кроссвалидацией(cv) через 10 блоков
control <- trainControl(method="cv", number=10)
# Контролируема метрика
metric <- "Accuracy" 
#LDA
set.seed(13)
fit.lda <- train(quality~., data=w.p, method="lda", metric=metric, trControl=control)
#CART
set.seed(13)
fit.cart <- train(quality~., data=w.p, method="rpart", metric=metric, trControl=control)
# kNN
set.seed(13)
fit.knn <- train(quality~., data=w.p, method="knn", metric=metric, trControl=control)
# SVM
set.seed(13)
fit.svm <- train(quality~., data=w.p, method="svmRadial", metric=metric, trControl=control)
#RandomForest
set.seed(13)
fit.rf <- train(quality~., data=w.p, method="rf", metric=metric, trControl=control)

#Получим оценки конролируемой метрики для каждого алгоритма
results <- resamples(list(lda=fit.lda, cart=fit.cart, knn=fit.knn, svm=fit.svm, rf=fit.rf))
summary(results)
#визуализируем
dotplot(results)
#лучше всех RandomForest в среднем предсказывает с точностью 67% 
#Слабая точность получилась из-за того что области для разных классов сильно пересекаются на featurePlot()
print(fit.rf)
#Её и будем использовать
#для этого у нас подготовлен валидационный набор
predictions <- predict(fit.rf, validation)
confusionMatrix(predictions, validation$quality)
