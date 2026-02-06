################################################################################
### AUTHOR: Ryan Taylor
### PURPOSE: Run Simulations for BIOS 731 HW 2
################################################################################

# Note: set parameters and seeds in report file

for (p in 1:nrow(params)){

  # Set parameters for this simulation
  n_rows <- params$data_n[p]
  bet <- params$beta_true[p]
  error_spec <- params$beta_true[p]

  for(s in 1:nSim){

    set.seed(seed_list[[p]][s])



    # Get data
  }



}
