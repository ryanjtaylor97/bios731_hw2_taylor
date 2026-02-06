################################################################################
### AUTHOR: Ryan Taylor
### PURPOSE: Write method for BIOS 731 HW 2 simulation
################################################################################

# Fit linear regression
fit_model <- function(simulated_data,
                      formula = y ~ x){
  lm(formula, data = simulated_data)
}
