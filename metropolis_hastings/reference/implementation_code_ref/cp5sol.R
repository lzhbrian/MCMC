#Task 1
#Evaluates the density of a bivariate normal distribution at a single point
mvdnorm <- function(x, mu, sigma){
	x.minus.mu <- x - mu 
		#subtract mu from x
	exp.arg <- -0.5 * sum(x.minus.mu * solve(sigma, x.minus.mu))
		#evaluates the expression inside exp(...)
	return( 1 / (2 * pi * sqrt(det(sigma))) * exp(exp.arg) )
	}

#Task 2
#Metropolis Hastings

#set the mean parameter
mu <- c(0,0)
#set the covarince parameter
sigma <- matrix(c(4,1,1,4), nrow=2)

#set the standard deviation of the proposal
sd.proposal <- 2.5
#set the desired sample size
n <- 1000
x <- matrix(nrow=n, ncol=2)

#set the starting value
cur.x <- c(0,0)
#evaluate the density at the starting value
cur.f <- mvdnorm(cur.x, mu, sigma)

n.accepted <- 0
for(i in 1:n){
	new.x <- cur.x + sd.proposal * rnorm(2)
	new.f <- mvdnorm(new.x, mu, sigma)
	if(runif(1) < new.f/cur.f){
		n.accepted <- n.accepted + 1
		cur.x <- new.x
		cur.f <- new.f
		}
	x[i,] <- cur.x
	}

#proportion of accepted values
n.accepted/n

#Task 3
#look at sample plots of both variables
par(mfrow=c(2,1))
plot(x[,1], type="l", xlab="t", ylab="X_1", main="Sample path of X_1")
plot(x[,2], type="l", xlab="t", ylab="X_2", main="Sample path of X_2")

#compute cumulative averages
x1_cumulative <- rep(0, times=n)
x2_cumulative <- rep(0, times=n)
for(i in 1:n){
  x1_cumulative[i] <- mean(x[1:i,1])
  x2_cumulative[i] <- mean(x[1:i,2])
}

par(mfrow=c(2,1))
plot(x1_cumulative, type="l", xlab="t", ylab="mean of X_1", main="Empirical mean of X_1")
plot(x2_cumulative, type="l", xlab="t", ylab="mean of X_2", main="Empirical mean of X_2")

#correlations
cor.x1 <- cor(x[-1,1], x[-nrow(x),1])
cor.x2 <- cor(x[-1,2], x[-nrow(x),2])
c(cor.x1, cor.x2)

#effective sample size
ess.x1 <- n * (1-cor.x1) / (1+cor.x1)
ess.x2 <- n * (1-cor.x2) / (1+cor.x2)
c(ess.x1, ess.x2)

#Task 4
#Change the standard deviation of the proposal, and repeat.
sd.proposal <- 0.1
sd.proposal <- 10

#Task 5
#Now set the covarince parameter as follows, and repeat.
sigma <- matrix(c(4,2.8,2.8,2), nrow=2)
