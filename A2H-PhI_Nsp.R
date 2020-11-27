rm(list=ls())

set.seed(684324)
library(R2OpenBUGS)


#----------------- dogs data for escalation -------------------#
Nstudy = 7
# historical animal data
NCohort = 11
# Animal data from 2 species, say, rats and dogs
n.sp = 2
# rats and dogs
DosesA  = c(60, 100, 30, 60, 30, 100, 10, 30, 100, 0.6, 1,  4,  8, 0.1, 2, 5, 0.3, 1.5, 3, 6)
# NtoxA  = c( 1,  10,  2,  1,  2,  16,  4,  3,   7, 0,   1,  3,  5, 0,   1, 4, 0,   2,   4, 5)
NtoxA   = c( 1,  10,  2,  1,  2,  16,  4,  5,   7, 0,   1,  4,  5, 1,   3, 4, 0,   2,   5, 6)
NsubA   = c(10,  28, 10, 20, 10,  24, 20, 20,  10, 6,   6,  6,  6, 6,   6, 6, 6,   8,   8, 8)
Study   = c( 1,   1,  2,  2,  3,   3,  4,  4,   4, 5,   5,  5,  5, 6,   6, 6, 7,   7,   7, 7)
Species = c( 1,   1,  1,  1,  1,   1,  1,  1,   1, 2,   2,  2,  2, 2,   2, 2, 2,   2,   2, 2)

Prior.mn.delta = c(1.792, 2.996)
Prior.sd.delta = c(0.337, 0.316)
#-------------------------------------------------------------#

Ndoses = 9
DosesH = c(2, 4, 8, 16, 22, 28, 40, 54, 70)
DoseRef = 28

pTrue = c(0.08, 0.16, 0.25, 0.35, 0.41, 0.45, 0.52, 0.58, 0.63)

NsubH = rep(0, Ndoses)
NtoxH = rep(0, Ndoses)


wMix = c(0, 0.7, 0.3)

Prior.mw = c(-1.099, 0)
Prior.sw = c(2, 1)
Prior.corr = 0

Prior.mt1 = c(-1.099, 1.98)
Prior.mt2 = c(0, 0.99)
Prior.tau.HN = c(0.5, 0.125)
Prior.rho = c(-1, 1)
Prior.sigma.HN = c(1, 0.5)
Prior.kappa = c(-1, 1)

pTox.cut = c(0.16, 0.33)

# Nstudy*(n.sp+1) matrix
PInd = matrix(c(1, 0, 0,
                1, 0, 0,
                1, 0, 0,
                1, 0, 0, 
                0, 1, 0,
                0, 1, 0,
                0, 1, 0),
              ncol=3, byrow = TRUE)


data <- list("n.sp", "Nstudy", "NCohort", "DosesA", "NtoxA", "NsubA", "Study", "Species", "Ndoses", "DosesH",
             "DoseRef", "NtoxH", "NsubH", "Prior.mn.delta", "Prior.sd.delta", "Prior.mw", "Prior.sw", "Prior.corr",
             "Prior.mt1", "Prior.mt2", "Prior.tau.HN", "Prior.rho", "Prior.sigma.HN", "Prior.kappa",
             "wMix", "pTox.cut", "PInd")


inits <- function(){
  list(
    m.ex = c(-0.0142, -0.0919),
    tau = matrix(c(0.5, 0.5), ncol=2),
    sigma = matrix(c(0.5, 0.5), ncol=2)
  )
}

parameters <- c("pToxH", "pCat", "prob.ex", "delta")


MCMCSim <- bugs(data, inits, parameters, "A2HEX_model.txt", codaPkg = F, 
                # OpenBUGS.pgm = "/opt/openbugs/bin/OpenBUGS",
                n.chains = 2, n.burnin = 3000, n.iter = 13000)

MCMCSim$summary

MCMCSim$mean$each

MCMCSim$mean$pToxH
