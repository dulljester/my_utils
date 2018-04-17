library(latex2exp)
png(filename="rs_perlca.png")
df <- read.table("regression.csv")
r <- df$V2-df$V3
s <- df$V4-df$V5
tot <- (r+s)/10240.00
logs <- with(df,log(df$V1)/log(2))
plot(logs,tot,main="Avg. Number of rank/select Calls per LCA Query", 
	 xlab=TeX("$\\log(size)$"), 
	 ylab="number of calls")
abline(lm(tot ~ logs))
dev.off()
