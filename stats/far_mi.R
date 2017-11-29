library(mice) 
library(Epi)
library(mitools)

# on a simple unimputed model
nhanes$cat_age <- as.factor(nhanes$age)
simple.lm <- lm(bmi ~ cat_age, data = nhanes)
float(simple.lm)

# test data 
imp <- mice(nhanes) # create imputed obect with default settings
fit <- with(imp, lm(chl ~ cat_age)) # run model
imp.lm <- pool(fit) # pool output
float(imp.lm) # cannot calculate FAR on imputed object

# MIcombine stores vcov - use this for now but find method to compute from the imputed datasets
mydata <- imputationList(lapply(1:5, complete, x=imp))
fit <- with(mydata, lm(chl ~ cat_age))
summary(MIcombine(fit))

MIC.fit <- MIcombine(fit)
MIC.fit$xlevels <- list(cat_age = levels(nhanes$cat_age))
MIC.fit$contrasts <- list(cat_age ="contr.treatment")
float(MIC.fit)

# model parameter extraction comparison
summary(simple.lm)$coef[,"Std. Error"] # se
diag(summary(simple.lm)$coef[,"Std. Error"] ** 2)
vcov(simple.lm)

summary(imp.lm)[,"se"] ** 2
vcov(MIC.fit)
