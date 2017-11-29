rm(list=ls())

library(data.table)
library(GenABEL)
library(ggplot2)
library(scales)

# get data
data(srdta)
s <- data.table(summary(gtdata(srdta)))
s[,hwe_p := -log10(Pexact)]
s[, rs := paste0("rs", rownames(s))]
#s$gwas_p <- sample(df(seq(1e-3, 5, len = nrow(s)),1,5), size = nrow(s))

s[, MAF := min(
    (2*P.11 + P.12) /(2 * sum(P.11,P.12,P.22)),
    (2*P.22 + P.12) /(2 * sum(P.11,P.12,P.22))
              ), by = rs]
s2 <- NULL
for(i in 1:22){
s2 <- rbindlist(list(s2, s))
}

s2$Chromosome <- as.numeric(rep(1:22, each = nrow(s)))

# plot data
gp <- ggplot(s2, aes(x = Position)) + 
  geom_point(aes(y = hwe_p, colour = MAF)) +
  scale_y_continuous(name = expression(paste(-log[10], " HWE"))) + 
  scale_x_continuous(labels = scientific) 

gp + 
  geom_line(aes(y = max(layer_scales(gp)$y$range$range) * CallRate), col = "red") +
  annotate("text", x = mean(layer_scales(gp)$x$range$range),  y = 12, label = "Call Rate") +
  facet_wrap(~ Chromosome, ncol = 3, scales = "free") # 15 x 20

  