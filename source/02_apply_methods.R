################################################################################
### AUTHOR: Ryan Taylor
### PURPOSE: Write method for BIOS 731 HW 2 simulation
################################################################################

# Fit linear regression
fit_model_lm <- function(simulated_data,
                         formula = y ~ x){
  lm(formula, data = simulated_data)
}

# Only extract coefficients

fit_model_lm_fit <- function(x_mat, y_vec){
  lm.fit(x = x_mat, y = y_vec)
}
