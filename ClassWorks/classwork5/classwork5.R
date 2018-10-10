#Модифицируйте код из предыдущей лекции (функцию estimate.scaling.exponent), чтобы он возвращал список a и y0
gmp <- read.table(file="https://raw.githubusercontent.com/SergeyMirvoda/MD-DA-2018/master/data/gmp.dat")
gmp$pop <- gmp$gmp/gmp$pcgmp
#функция проверки гипотезы https://arxiv.org/pdf/1102.4101.pdf
#a - подгоняемый коэффициент
#y0 - некое начальное значение 
#responce - средний доход на душу населения в мегалаполисе
#predicator - количесто населения в мегалаполисе
#deriv.step - шаг диференцирования
#step.scale - шаг изменения a
#stopping.deriv - условие прекращения вычислений
estimate.scaling.exponent <- function(a, y0=6611, response=gmp$pcgmp,
                                      predictor = gmp$pop, maximum.iterations=100, deriv.step = 1/100,
                                      step.scale = 1e-12, stopping.deriv = 1/100) {
  vector.a <- c(a)
  mse <- function(a) { mean((response - y0*predictor^a)^2) }
  for (iteration in 1:maximum.iterations) {
    deriv <- (mse(a+deriv.step) - mse(a))/deriv.step
    a <- a - step.scale*deriv
    vector.a <- c(vector.a, a)
    if (abs(deriv) <= stopping.deriv) { break() }
  }
  fit <- list(list.a=vector.a, y0=y0)
  return(fit)
}
estimate.scaling.exponent(0.15)
#Напишите рекурсивные функции факториала и фибоначчи
factorial <- function(n){
  if(n==0)
    return(1)
  return(n*factorial(n-1))
}

fib <- function(n){
  if(n==1 || n==2)
    return(1)
  return(fib(n-1) + fib(n-2))
}

factorial(4)
fib(8)

#Улучшите функцию из примера к лекции 4.1 (код в файле 4.1.R)
predict.plm <- function(obj, dt) {
  # Проверим что входные данные подходят для того чтобы с ними можно было оперировать
  stopifnot("a" %in% names(obj), "y0" %in% names(obj),
            is.numeric(obj$a),length(obj$a)==1, is.numeric(obj$y0),length(obj$y0)==1, 
            is.numeric(dt))
  return(obj$y0*dt^obj$a) # Вычислим и выйдем
}

predict.plm(data.frame(a=0.15, y0=6611), 0.01)