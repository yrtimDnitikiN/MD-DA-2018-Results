gmp <- read.table(file="https://raw.githubusercontent.com/SergeyMirvoda/MD-DA-2018/master/data/gmp.dat")
gmp$pop <- gmp$gmp/gmp$pcgmp
View(gmp)
#функция для проверки гипотезы https://arxiv.org/pdf/1102.4101.pdf
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
  mse <- function(a) { mean((response - y0*predictor^a)^2) }
  for (iteration in 1:maximum.iterations) {
    deriv <- (mse(a+deriv.step) - mse(a))/deriv.step
    a <- a - step.scale*deriv
    if (abs(deriv) <= stopping.deriv) { break() }
  }
  fit <- list(a=a,iterations=iteration,
              converged=(iteration < maximum.iterations))
  return(fit)
}
#Пример вызова с начальным занчением a
a.before.del<-estimate.scaling.exponent(0.15);
a.before.del

#С помошью полученного коэффициента постройте кривую (функция curve) зависимости
curve((y0=6611)*x^estimate.scaling.exponent(0.15)$a, gmp$pop)
#Удалите точку из набора исходных данных случайным образом, как изменилось статистическая оценка коэффициента a?
gmp<-gmp[-sample(x = 1:366, size = 1),]
a.after.deletion<-estimate.scaling.exponent(0.15)
a.after.deletion
a.after.deletion$a-a.before.deletion$a
#Запустите оценку несколько раз с разных стартовых точек. Как изменилось значение a?
estimate.scaling.exponent(0) #a=0.1212198, 77 итераций, сходится
estimate.scaling.exponent(0.1) #a=0.1212198, 61 итерация, сходится
estimate.scaling.exponent(0.2) #a=0.1211533, 70 итерация, сходится
estimate.scaling.exponent(0.2198) #a=0.1212198, 99 итераций, сходится
estimate.scaling.exponent(0.2199) #a=0.1209941, 100 итераций, расходится
estimate.scaling.exponent(0.3) #a=-2.861204, 2 итерации, сходится
estimate.scaling.exponent(3) #a=-2.394772e+38, 2 итерации, сходится
estimate.scaling.exponent(-0.124); #a=0.1212197, 100 итераций, расходится
estimate.scaling.exponent(-0.123); #a=0.1212198, 100 итераций, расходится
estimate.scaling.exponent(-3); #a=-3, 1 итерация, сходится
#а достигает своего максимального значения 0.1212198 при изменении стартовой точки в промежутке [-0.124, 0.2198].
