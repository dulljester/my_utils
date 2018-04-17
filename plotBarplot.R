# https://stackoverflow.com/questions/22305023/how-to-get-a-barplot-with-several-variables-side-by-side-grouped-by-a-factor
# running: r -e plotBarplot.R
df<-read.table("tab.csv",header=T)
means<-aggregate(df,by=list(df$func),mean)
means<-means[,2:length(means)]
library(reshape2)
means.long<-melt(means,id.vars="func")
library(ggplot2)
png('rank_select_calls.png')
ggplot(means.long,aes(x=variable,y=value,fill=factor(func)))+geom_bar(stat="identity",position="dodge")+scale_fill_discrete(name="Primitive",breaks=c(1,2),labels=c("rank","select"))+xlab("method")+ylab("Avg. number of calls")
dev.off()
