# Metropolis Hasting Algorithm

# Calc the probability of x in model
  # input:
    # x: RV of length n
    # mu, sigma: Determine a norm distribution model
  # output:
    # probability of x
norm.probability <- function(x, mu, sigma){
  n = length(x)
  x.minus.mu <- x - mu
  sigma.inverse <- solve(sigma)
  exp.arg <- -1/2 * t(x.minus.mu) %*% sigma.inverse %*% x.minus.mu
  
  norm.probability <- 1 / sqrt( (2*pi)^n *det(sigma) ) * exp(exp.arg)
  return(norm.probability)
}

# To test the best sd.T to match accepting rate=0.234 due to Roberts et al's work on 1995
  # input:
    # sd.T: jumping distance
    # plot.or.not: 1 to plot, 0 not
  # output:
    # a list: [accepting.rate, pearson.correlation]
test.sd.T <- function(sd.T, plot.or.not) {
  
  # Setup some arg
  set.seed(50)
  mu = c(5,10)
  sigma = matrix(c(1,1,1,4), nrow=2, ncol=2, byrow = TRUE)
  real_corr = sqrt( (sigma[1,2]*sigma[2,1])/(sigma[1,1]*sigma[2,2]) ) # Theoretical corelation
  sd.T = sd.T # Set the standard deviation of the proposal
  
  # required sample num
  sample.num = 10000;
  random.matrix = matrix(nrow=sample.num, ncol=2)
  
  # Starting value
  cur.x <- c(5,10)
  cur.f <- norm.probability(cur.x, mu, sigma)
  accept.num <- 0
  # Main Algorithm
  for(i in 1:sample.num){
    new.x <- cur.x + sd.T * rnorm(2) 
    # Generate a new x with norm(mean=cur.x, sd=given.by.me)
    new.f <- norm.probability(new.x, mu, sigma) 
    if ( runif(1) < min(1,new.f/cur.f) ) { # transfer to another value
      if (i > sample.num/2) {
        accept.num <- accept.num + 1
      }
      cur.x <- new.x
      cur.f <- new.f
    } else { # retain the original value
      cur.x <- cur.x
      cur.f <- cur.f
    }
    random.matrix[i,] <- cur.x
  }
  
  accepting.rate <- accept.num/sample.num*2
  pearson.correlation <- cor.test(
    random.matrix[(sample.num/2):sample.num,1], 
    random.matrix[(sample.num/2):sample.num,2])$estimate
  
  # plot, output results
  if (plot.or.not==1) {
    ## Show result
    # We want the accepting rate to be 0.234 based on Roberts et al's work on 1995
    cat( paste("Accepting Rate:", accepting.rate, '\n') )
    cat( paste("Theoretically correlation:", real_corr, '\n' ) )
    cat( paste("Real correlation:", pearson.correlation, '\n') )
    # Plot
    plot(random.matrix[(sample.num/2):sample.num,], 
         xlab = expression(x["1"]), ylab = expression(x["2"]), 
         col = 'blue', cex.main = 0.75)
  }
  
  return(list(accepting.rate, pearson.correlation))
  
}

# Test best sd.T: jumping distance
test.range <- seq(1.5, 5, 0.1)
acc.rate.vec = vector(length = length(test.range))
cor.vec = vector(length = length(test.range))
for (i in c(1:length(test.range))) {
  ans_list <- test.sd.T(test.range[i],0)
  acc.rate.vec[i] <- ans_list[[1]]
  cor.vec[i] <- ans_list[[2]]
  cat(i, test.range[i], '\n')
}

# Plot Accepting Rate - sd.T
plot(test.range, acc.rate.vec,
     type="l", # main = 'Accepting Rate - sd.T',
     xlab = 'sd.T', ylab = 'Accepting Rate',
     cex.main = 0.75, cex.axis=1)
lines(test.range, rep(0.234,time=length(test.range)), col = "red")
text(4.2, 0.25, "Acc.rate = 0.234", cex = 0.8, col="red")
text(4.2, 0.22, "sd.T = 3.0", cex = 0.8, col="red")

# # Use sd.T = 3.0
# set.seed(233312)
# sd.T = 3.0
# ans_list <- test.sd.T(sd.T, 1)
# acc.rate <- ans_list[[1]]
# cor <- ans_list[[2]]
# cat(acc.rate, cor, '\n')


# plot(test.range, cor.vec, 
#      type="l", # main = 'Pearson Correlation - sd.T', 
#      xlab = 'sd.T', ylab = 'Pearson Correlation',
#      cex.main = 0.75, cex.axis=1)
# lines(test.range, rep(0.50,time=length(test.range)), col = "red")
# text(4.6, 0.495, "Cor = 0.50", cex = 0.8, col="red")


