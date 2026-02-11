# bios731_hw2_taylor

## BIOS 731 Homework 2 Project Directory

This project is set up as a reproducible workflow for BIOS 731 Homework 2. 

The analysis runs a simulation study to test the bias of a linear regression estimate of a binary treatment under several scenarios.
In addition, three methods for constructing a 95\% confidence interval are compared based on real coverage and computational efficiency.

## Reproducing This Analysis

This analysis is most easily run using the R project file `bios731_hw2_taylor.Rproj`. 

In the repository, create a new "data" folder to save simulation results.

Open the file *simulations_report.qmd*.
Change the last line in the "setup" chunk (line 48) from 
`DO_SIMULATIONS <- F` to `DO_SIMULATIONS <- T`.

Run the entirety of the *simulations_report.qmd* script.

*Note*: if parts of this analyis need to be run after simulation results files have already been saved in the "data" folder,
switch this line back to `DO_SIMULATIONS <- F` to use the intermediate files instead of rerunning the simulations.


Our R session uses the following R version and package versions:

```
R version 4.5.1 (2025-06-13)
Platform: aarch64-apple-darwin20
Running under: macOS Sequoia 15.7.3

Matrix products: default
BLAS:   /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/libBLAS.dylib 
LAPACK: /Library/Frameworks/R.framework/Versions/4.5-arm64/Resources/lib/libRlapack.dylib;  LAPACK version 3.12.1

locale:
[1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8

time zone: America/New_York
tzcode source: internal

attached base packages:
[1] parallel  stats     graphics  grDevices utils     datasets  methods  
[8] base     

other attached packages:
 [1] broom_1.0.9       kableExtra_1.4.0  knitr_1.50        magrittr_2.0.3   
 [5] lubridate_1.9.4   forcats_1.0.0     stringr_1.5.1     dplyr_1.1.4      
 [9] purrr_1.1.0       readr_2.1.5       tidyr_1.3.1       tibble_3.3.0     
[13] ggplot2_4.0.0     tidyverse_2.0.0   doParallel_1.0.17 iterators_1.0.14 
[17] foreach_1.5.2     tictoc_1.2.1      gtools_3.9.5      pacman_0.5.1     
[21] here_1.0.1       

loaded via a namespace (and not attached):
 [1] gtable_0.3.6         bslib_0.9.0          xfun_0.52           
 [4] lattice_0.22-7       tzdb_0.5.0           vctrs_0.6.5         
 [7] tools_4.5.1          generics_0.1.4       sandwich_3.1-1      
[10] pkgconfig_2.0.3      Matrix_1.7-3         RColorBrewer_1.1-3  
[13] S7_0.2.0             lifecycle_1.0.4      compiler_4.5.1      
[16] farver_2.1.2         textshaping_1.0.1    microbenchmark_1.5.0
[19] codetools_0.2-20     sass_0.4.10          htmltools_0.5.8.1   
[22] jquerylib_0.1.4      pillar_1.11.0        MASS_7.3-65         
[25] cachem_1.1.0         multcomp_1.4-28      tidyselect_1.2.1    
[28] digest_0.6.37        mvtnorm_1.3-3        stringi_1.8.7       
[31] labeling_0.4.3       splines_4.5.1        rprojroot_2.1.1     
[34] fastmap_1.2.0        grid_4.5.1           cli_3.6.5           
[37] survival_3.8-3       TH.data_1.1-3        withr_3.0.2         
[40] scales_1.4.0         backports_1.5.0      timechange_0.3.0    
[43] rmarkdown_2.29       zoo_1.8-14           hms_1.1.3           
[46] evaluate_1.0.4       viridisLite_0.4.2    rlang_1.1.6         
[49] glue_1.8.0           xml2_1.3.8           jsonlite_2.0.0      
[52] svglite_2.2.1        rstudioapi_0.17.1    R6_2.6.1            
[55] systemfonts_1.2.3
```


## Structure

* `analysis/` contains the R Markdown file that run and report the analyses for the project.
* `data/` is a subdirectory containing the intermediate results from each scenario's simulations.
* `results/` contains figures exported by the analysis files.
* `simulations/` contains code to run a simulation under one scenario.
* `source/` contains bare scripts that perform the analysis, but do not report results.

## Key Files and Folders

### Source Folder
* `01_simulate_data.R`: function to simulate data under a given scenario.
* `02_apply_methods.R`: functions to estimate a treatment effect from simulated data.
* `03_extract_estimates.R`: functions to estimate a confidence interval and save simulation results.

### Simulations Folder
* `run_simulations.R`: function to run a simulation under one scenario of parameters.

### Data Folder:
* *Results files*: contain estimates for all simulations under one scenario.
* *Timing files*: contain logs of elapsed time for all steps of the simulation, generated using the package `tictoc`.
* `combined_scenario_output.rda`: contains a nested list of all results and timing files.

### Analysis Folder
* `simulations_report.qmd`: code to run all simulations and generate a report summarizing the results.
* `simulations_report.pdf`: a report summarizing the results of the simulations.
