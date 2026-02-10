################################################################################
### AUTHOR: Ryan Taylor
### PURPOSE: Extract coverage estimates for BIOS 731 HW 2 simulation
################################################################################

# Get estimate and Wald confidence interval
get_estimates_lm <- function(model_fit){

  tidy(model_fit, conf.int = TRUE) %>%
    filter(term == "x") %>%
    rename(beta_hat = estimate) %>%
    mutate(method = "Wald") %>%
    select(method, term, beta_hat, std.error, conf.low, conf.high)

}

# Extract only x coefficient from a model
get_coef_lm <- function(model_fit){
  coef(model_fit)[2]
}

# Get bootstrap percentile CI
get_estimates_boot_pct <- function(x_mat, y_vec,
                                   n_perm, seeds){

  # Initialize beta list
  beta_hats <- rep(NA, n_perm)

  # Fit model on bootstrap samples
  for(b in 1:n_perm){

    # Set seed for this iteration
    set.seed(seeds[b])

    # Sample row indices
    sample_b <- sample.int(nrow(x_mat), replace = T)

    # Define new x based on these indices
    x_b <- x_mat[sample_b,]

    # Define new y based on these indices
    y_b <- y_vec[sample_b]

    # Fit new model with this permutation x and y
    b_fit <- fit_model_lm_fit(x_b, y_b)

    # Save x coefficient to vector
    beta_hats[b] <- get_coef_lm(b_fit)

  }

  # Return tibble of confidence interval
  tibble(
    method = "Boot Pct",
    std.error = sd(beta_hats, na.rm = T),
    conf.low = quantile(beta_hats, 0.025, na.rm = T),
    conf.high = quantile(beta_hats, 0.975, na.rm = T),
    n_boot_est = sum(!is.na(beta_hats))
    )
}

# Get bootstrap t CI
get_estimates_boot_t <- function(x_mat, y_vec, beta_orig,
                                 n_perm_out, n_perm_in,
                                 seeds){

  # Initialize beta list
  beta_hats <- rep(NA, n_perm_out)
  t_vec <- rep(NA, n_perm_out)

  # Initialize beta std. error list
  beta_sds <- rep(NA, n_perm_out)

  # Fit model on bootstrap samples
  for(b in 1:n_perm_out){

    # Set seed for this iteration
    set.seed(seeds[b])

    # Sample row indices
    sample_b <- sample.int(nrow(x_mat), replace = T)

    # Define new x based on these indices
    x_b <- x_mat[sample_b,]

    # Define new y based on these indices
    y_b <- y_vec[sample_b]

    # Fit new model with this permutation x and y
    b_fit <- fit_model_lm_fit(x_b, y_b)

    # Isolate x coefficient
    beta_hat_b <- get_coef_lm(b_fit)

    if(is.na(beta_hat_b)){ next }

    # Save x coefficient to vector
    beta_hats[b] <- beta_hat_b

    # Initialize vector of interior estimates
    beta_hats_inner <- rep(NA, n_perm_in)

    for(k in 1:n_perm_in){

      # Sample row indices
      sample_k <- sample(sample_b, size = length(sample_b), replace = T)

      # Define new x based on these indices
      x_k <- x_b[sample_k,]

      # Define new y based on these indices
      y_k <- y_b[sample_k]

      # Fit new model with this permutation x and y
      k_fit <- fit_model_lm_fit(x_k, y_k)

      # Isolate x coefficient
      beta_hat_k <- get_coef_lm(k_fit)

      # Save x coefficient to vector
      beta_hats_inner[k] <- beta_hat_k
    }

    # Estimate standard error
    beta_sds[b] <- sd(beta_hats_inner, na.rm = T)
  }

  # Calculate t statistics
  t_vec <- (beta_hats - beta_orig) / beta_sds

  # Calculate standard error of all beta hats
  se_boot <- sd(beta_hats, na.rm = T)

  # Return tibble of confidence interval
  tibble(
    method = "Boot t",
    beta_hat = beta_orig,
    conf.low = beta_orig - se_boot * quantile(t_vec, 0.975, na.rm = T),
    conf.high = beta_orig - se_boot * quantile(t_vec, 0.025, na.rm = T),
    std.error = se_boot,
    n_boot_est = sum(!is.na(t_vec))
  )
}
