################################################################################
### AUTHOR: Ryan Taylor
### PURPOSE: Run Simulations for BIOS 731 HW 2
################################################################################

# Note: set parameters and seeds in report file

tic.clear()
tic.clearlog()

tic("Full Scenario")

# Set parameters for this simulation
n_rows <- params$data_n[p]
bet <- params$beta_true[p]
error_spec <- params$error_dist[p]

# Initialize results
results = as.list(rep(NA, nSim))

for(s in 1:nSim){

  if(s %% 25 == 0){ cat("At simulation #", s, "\n") }

  set.seed(seed_list[[p]][[s]][1])

  tic("Simulation")

  # Get data
  sim_data <- get_simdata(n = n_rows,
                          beta_treat = bet,
                          variance = 2,
                          error_dist = error_spec)

  toc(log = T, quiet = T)

  tic("Wald")

  # 1) Fit linear regression with Wald standard error

  # Fit model
  fit_wald <- fit_model_lm(sim_data)

  # Get coefficient and confidence interval results
  res_wald <- get_estimates_lm(fit_wald)

  toc(quiet = T, log = T)

  # 2) Run bootstrap percentile confidence interval

  tic("Bootstrap percentile")

  y_in <- sim_data$y

  x_in <- cbind(1, sim_data$x)

  # Get coefficient from original model as a scalar
  coef_lm <- get_coef_lm(fit_wald)

  # Function combines model fit and
  res_pct <- get_estimates_boot_pct(x_mat = x_in, y_vec = y_in,
                                    n_perm = boot_outer,
                                    seeds = seed_list[[p]][[s]][-1])

  # Add original estimate to make similar to Wald dataset
  res_pct %<>%
    mutate(term = "x",
           beta_hat = coef_lm)

  toc(quiet = T, log = T)

  tic("Bootstrap t")

  # 3) As a separate step (with same seeds), run bootstrap t
  res_t <- get_estimates_boot_t(x_mat = x_in, y_vec = y_in,
                                beta_orig = coef_lm,
                                n_perm_out = boot_outer, n_perm_in = boot_inner,
                                seeds = seed_list[[p]][[s]][-1])

  res_t %<>% mutate(term = "x")

  toc(quiet = T, log = T)

  # Combine these and save
  results[[s]] <- bind_rows(res_wald, res_pct, res_t) %>%
    mutate(sim_num = s, .before = everything())

}

# Save results as a dataset
results_df <- bind_rows(results) %>%
  mutate(scenario = p, .before = everything())

# Make scenario number neat
p_name <- str_pad(p, width = 2, side = "left", pad = "0")

# Save results
save(results_df,
     file = here::here("data", paste0("results_scenario_", p_name, ".rda")))

toc(quiet = T, log = T)

# Save timing
time_log <- tic.log(format = F)

timing <- bind_rows(
  lapply(time_log,
         function(x){
           tibble(step = x$msg,
                  time = x$toc - x$tic)
           }
         )) %>%
  mutate(scenario = p, .before = everything())

save(timing,
     file = here::here("data", paste0("timing_scenario_", p_name, ".rda")))

