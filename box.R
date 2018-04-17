library(latex2exp)
require(ggplot2)
require(gridExtra)
library(directlabels)
library(extrafont)
png(filename="boxplot.png")
df <- read.table("regression_queries.csv")
df$V7 <- with(df,V2-V3)
df$V8 <- with(df,V4-V5)
df$V9 <- with(df,log(V1)/log(2))
df$V10 <- with(df,V7/10240.00)
df$V11 <- with(df,V8/10240.00)
ext <- df[df$V6=="ext",]
ext_mp <- df[df$V6=="ext_mp",]
wt <- df[df$V6=="wt_hpd",]
#g <- ggplot(ext,aes(V9))+ geom_point(aes(y=ext$V10), shape=0) + geom_point(aes(y=ext_mp$V10), shape=1)+ geom_point(aes(y=wt$V10), shape=2) + ylab("nnumber of rank calls")+theme(axis.title.x=element_blank(),
																																												         #axis.text.x=element_blank(),
																																														  #       axis.ticks.x=element_blank())
#b <- ggplot(ext,aes(V9))+ geom_point(aes(y=ext$V11), shape=0) + geom_point(aes(y=ext_mp$V11), shape=1) + geom_point(aes(y=wt$V11), shape=2) +xlab("log(size)") + ylab("nnumber of select calls")
require(stats)
reg_rank <- lm(ext_mp$V10 ~ ext_mp$V9)
coeff <- coefficients(reg_rank)
eq <- paste0(eq = paste0("y = ", round(coeff[2],1), "*x + ", round(coeff[1],1)))
names(df) <- c("V1","V2","V3","V4","V5","Algorithm","V7","V8","V9","V10","V11")
variety <- df$"Algorithm"
note <- df$V10
new_order <- with(df, reorder(variety,note,median))
boxplot(df$V10 ~ new_order)
#ggsave(filename="boxplot.png", width=3.5, height=3.5, dpi=1200)
dev.off()
