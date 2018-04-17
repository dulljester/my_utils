library(latex2exp)
require(ggplot2)
require(gridExtra)
library(directlabels)
library(extrafont)
png(filename="boxplot2.png")
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
variety <- rep(df$"Algorithm",2)
treatment <- c(rep("rank",nrow(df)),rep("select",nrow(df)))
note <- c(df$V10,df$V11)
data <- data.frame(variety,treatment,note)
new_order <- with(data, reorder(variety,note,mean))
par(mar=c(3,4,3,1))
myplot = boxplot(note ~ treatment*new_order, data=data, bowwex=0.4, ylab="number of calls", main = "Avg. Number of rank/select Calls per Path Median Query", col=c("darkblue","darkred"), xaxt="n")
my_names=sapply(strsplit(myplot$names , '\\.') , function(x) x[[2]] )
my_names=my_names[seq(1 , length(my_names) , 2)]
axis(1, at = seq(1.5 , 6 , 2), labels = my_names , tick=FALSE , cex=0.3)
for(i in seq(0.5 , 20 , 2)){ abline(v=i,lty=1, col="grey")}
# Add a legend
legend("bottomright", legend = c("rank", "select"), col=c("darkblue" , "darkred"),
	          pch = 15, bty = "n", pt.cex = 3, cex = 1.2,  horiz = F, inset = c(0.1, 0.1))
dev.off()
