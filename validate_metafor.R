# CRES v4.0 — Cross-validation against R metafor
# Validates DL tau2, pooled HR, I2, and REML tau2
library(metafor)

# Trial data extracted from CONFIG.trials (HR estimand only)
# Composite outcome
comp <- data.frame(
  trial = c("FIDELIO-DKD","FIGARO-DKD","TOPCAT","EMPHASIS-HF",
            "EMPEROR-Reduced","EMPEROR-Preserved","DELIVER","DAPA-HF","DECLARE-TIMI 58"),
  class = c("Finerenone","Finerenone","Steroidal MRA","Steroidal MRA",
            "SGLT2i","SGLT2i","SGLT2i","SGLT2i","SGLT2i"),
  hr = c(0.86, 0.87, 0.89, 0.63, 0.75, 0.79, 0.82, 0.74, 0.83),
  lower = c(0.75, 0.76, 0.77, 0.54, 0.65, 0.69, 0.73, 0.65, 0.73),
  upper = c(0.99, 0.98, 1.04, 0.74, 0.86, 0.90, 0.92, 0.85, 0.95)
)
comp$yi <- log(comp$hr)
comp$sei <- (log(comp$upper) - log(comp$lower)) / (2 * qnorm(0.975))

cat("=== COMPOSITE OUTCOME ===\n")
# DL with class moderator (one-hot, no intercept)
dl_comp <- rma(yi, sei=sei, mods = ~ factor(class) - 1, method="DL", data=comp)
cat("DL tau2:", dl_comp$tau2, "\n")
cat("DL I2:", dl_comp$I2, "%\n")
cat("DL Q:", dl_comp$QE, " p=", dl_comp$QEp, "\n")
cat("DL class effects (logHR):\n")
print(coef(summary(dl_comp)))

# REML
reml_comp <- rma(yi, sei=sei, mods = ~ factor(class) - 1, method="REML", data=comp)
cat("\nREML tau2:", reml_comp$tau2, "\n")
cat("REML class effects (logHR):\n")
print(coef(summary(reml_comp)))

# HKSJ
hksj_comp <- rma(yi, sei=sei, mods = ~ factor(class) - 1, method="REML", test="knha", data=comp)
cat("\nREML+HKSJ class effects:\n")
print(coef(summary(hksj_comp)))

# Renal outcome
renal <- data.frame(
  trial = c("FIDELIO-DKD","FIGARO-DKD","DAPA-CKD","EMPA-KIDNEY","CREDENCE"),
  class = c("Finerenone","Finerenone","SGLT2i","SGLT2i","SGLT2i"),
  hr = c(0.82, 0.87, 0.61, 0.72, 0.70),
  lower = c(0.73, 0.76, 0.51, 0.64, 0.59),
  upper = c(0.93, 1.01, 0.72, 0.82, 0.82)
)
renal$yi <- log(renal$hr)
renal$sei <- (log(renal$upper) - log(renal$lower)) / (2 * qnorm(0.975))

cat("\n=== RENAL OUTCOME ===\n")
dl_renal <- rma(yi, sei=sei, mods = ~ factor(class) - 1, method="DL", data=renal)
cat("DL tau2:", dl_renal$tau2, "\n")
cat("DL I2:", dl_renal$I2, "%\n")
cat("DL class effects (logHR):\n")
print(coef(summary(dl_renal)))

reml_renal <- rma(yi, sei=sei, mods = ~ factor(class) - 1, method="REML", data=renal)
cat("\nREML tau2:", reml_renal$tau2, "\n")

# Mortality outcome
mort <- data.frame(
  trial = c("RALES","EPHESUS","DAPA-CKD","DAPA-HF","EMPA-REG OUTCOME",
            "DECLARE-TIMI 58","CANVAS Program","VERTIS-CV","EMPEROR-Reduced"),
  class = c("Steroidal MRA","Steroidal MRA","SGLT2i","SGLT2i","SGLT2i",
            "SGLT2i","SGLT2i","SGLT2i","SGLT2i"),
  hr = c(0.70, 0.85, 0.69, 0.83, 0.68, 0.93, 0.87, 0.93, 0.92),
  lower = c(0.60, 0.75, 0.53, 0.71, 0.57, 0.82, 0.74, 0.80, 0.77),
  upper = c(0.82, 0.96, 0.88, 0.97, 0.82, 1.04, 1.01, 1.08, 1.10)
)
mort$yi <- log(mort$hr)
mort$sei <- (log(mort$upper) - log(mort$lower)) / (2 * qnorm(0.975))

cat("\n=== MORTALITY OUTCOME ===\n")
dl_mort <- rma(yi, sei=sei, mods = ~ factor(class) - 1, method="DL", data=mort)
cat("DL tau2:", dl_mort$tau2, "\n")
cat("DL I2:", dl_mort$I2, "%\n")
cat("DL class effects (logHR):\n")
print(coef(summary(dl_mort)))

reml_mort <- rma(yi, sei=sei, mods = ~ factor(class) - 1, method="REML", data=mort)
cat("\nREML tau2:", reml_mort$tau2, "\n")

cat("\n=== SUMMARY TABLE ===\n")
cat(sprintf("%-12s %-8s %-10s %-10s %-10s %-10s\n", "Outcome", "Class", "DL_tau2", "REML_tau2", "HR(DL)", "I2"))
# Composite
for (i in 1:length(dl_comp$b)) {
  cls <- gsub("factor\(class\)", "", rownames(coef(summary(dl_comp)))[i])
  cat(sprintf("%-12s %-8s %-10.6f %-10.6f %-10.4f %-10.1f\n",
    ifelse(i==1,"composite",""), cls, dl_comp$tau2, reml_comp$tau2,
    exp(dl_comp$b[i]), dl_comp$I2))
}
for (i in 1:length(dl_renal$b)) {
  cls <- gsub("factor\(class\)", "", rownames(coef(summary(dl_renal)))[i])
  cat(sprintf("%-12s %-8s %-10.6f %-10.6f %-10.4f %-10.1f\n",
    ifelse(i==1,"renal",""), cls, dl_renal$tau2, reml_renal$tau2,
    exp(dl_renal$b[i]), dl_renal$I2))
}
for (i in 1:length(dl_mort$b)) {
  cls <- gsub("factor\(class\)", "", rownames(coef(summary(dl_mort)))[i])
  cat(sprintf("%-12s %-8s %-10.6f %-10.6f %-10.4f %-10.1f\n",
    ifelse(i==1,"mortality",""), cls, dl_mort$tau2, reml_mort$tau2,
    exp(dl_mort$b[i]), dl_mort$I2))
}
