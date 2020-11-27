# A2PhI
OpenBUGS code and R functions to implement the Bayesian hierarchical random-effects model for leveraging animal data from one or multiple species in phase I oncology trials. 

Files contained in this repository can be used to reproduce the numerical results reported in the paper entitled
# H. Zheng., L.V. Hampson., S. Wandel. (2020). A robust Bayesian meta-analytic approach to incorporate animal data into phase I oncology trials. Statistical Methods in Medical Research;29(1):94-110. doi:10.1177/0962280218820040.

The script "ISEX_model_final.txt" gives the model specification in OpenBUGS for implementing the proposed methodology, while the "simPhI_Sc1_Nsp.R" contains R functions calling the OpenBUGS model in R through the R2OpenBUGS package. 

The script "Prior4delta.R" yields the species-specific log-normal prior for \delta_{S_k}, for k = 1, ..., K, as represented in Table 1 of the main paper.
