################################################################################
### AUTHOR: Ryan Taylor
### PURPOSE: Simulate data for BIOS 731 HW 2
################################################################################

get_simdata <- function(n,
                        pct_treat = 0.5,
                        beta0 = 1,
                        beta_treat,
                        variance,
                        error_dist = c("gauss", "t"),
                        error_t_nu = 3){

  # Simulate whether each individual has treatment or not
  x <- rbinom(n, 1, prob = pct_treat)

  # Simulate error
  if(error_dist == "gauss"){
    # If Gaussian errors, draw epsilon from normal distribution
    epsilon <- rnorm(n, 0, sd = sqrt(variance))

  } else if (error_dist == "t"){
    # If t errors, first draw from t dist
    u <- rt(n, df = error_t_nu)

    # Next, calculae variance of t dist
    var_u <- error_t_nu / (error_t_nu - 2)

    # Calculate epsilon with ratio of SDs

    epsilon <- u * sqrt(variance) / sqrt(var_u)
  }

  y <- beta0 + beta_treat * x + epsilon

  return(
    tibble(x = x, y = y)
  )
}
