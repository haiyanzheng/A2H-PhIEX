BSA <- c(0.007, 0.016, 0.025, 0.043, 0.050, 0.150, 0.500, 0.250, 0.060, 0.090, 0.600, 0.740, 1.140)
BW <- c(0.02, 0.08, 0.15, 0.30, 0.40, 1.80, 10, 3, 0.35, 0.60, 12, 20, 40)
KM.animal <- BW/BSA
BW.range <- matrix(c(0.011, 0.034,
                     0.047, 0.157,
                     0.080, 0.270,
                     0.160, 0.540,
                     0.208, 0.700,
                     0.900, 3.000,
                     5, 17,
                     1.400, 4.900,
                     0.140, 0.720,
                     0.290, 0.970,
                     7, 23,
                     10, 33,
                     25, 64), ncol = 2, byrow = TRUE)
iKM.animal <- BW.range/BSA


aniKM <- data.frame(medKm = KM.animal, 
                    KmL = iKM.animal[,1],
                    KmU = iKM.animal[,2])



### objective function for optim
coverage <- function(par, ciMat){
  with(ciMat,
       sum(c((plnorm(KmU, meanlog = log(medKm), sdlog = par) - 0.975)^2,
             (plnorm(KmL, meanlog = log(medKm), sdlog = par) - 0.025)^2))
  )
}

#------------------ animal Km ------------------#
stdKm.animal <- sapply(
  seq(1, nrow(aniKM)),
  function(i)  optim(par, coverage, ciMat = aniKM[i,], method = "Brent", lower = 0, upper = 1)$par
)

round(stdKm.animal, 3)

# check
plnorm(aniKM$KmL, meanlog = log(aniKM$medKm), sdlog = round(stdKm.animal, 3))
plnorm(aniKM$KmU, meanlog = log(aniKM$medKm), sdlog = round(stdKm.animal, 3))

#------------------ human Km ------------------#
BSA.human <- 1.62
BW.human <- 60
KM.human <- BW.human/BSA.human
BW.range.human <- c(50, 80)
iKM.human <- BW.range.human/BSA.human

humanKM <- data.frame(medKm = KM.human, 
                      KmL = iKM.human[1],
                      KmU = iKM.human[2])

stdKm.human <- optim(par, coverage, ciMat = humanKM, method = "Brent", lower = 0, upper = 1)$par
  

# check
plnorm(30.8642, meanlog = log(37.037), sdlog = stdKm.human)
plnorm(49.38272, meanlog = log(37.037), sdlog = stdKm.human)


# lambda & gamma for HED in mg/kg
lambda <- log(aniKM$medKm) - log(humanKM$medKm)
gamma <- sqrt(stdKm.animal^2 + stdKm.human^2)

cbind(round(lambda, 3), round(gamma, 3))


# lambda & gamma for HED in mg/m^2
lambda <- log(aniKM$medKm) - log(humanKM$medKm) + log(BW.human) - log(BSA.human)
gamma <- sqrt(stdKm.animal^2)

cbind(round(lambda, 3), round(gamma, 3))


