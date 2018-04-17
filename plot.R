## set up some fake test data
sizes <- seq(1,35,5)
queryTime <- c(0.000200,0.000250,0.000300,0.000350,0.000400,0.000450,0.000500,0.000550,0.000600,0.000650,0.000700,
				0.000750,0.000800,0.000850,0.000900)
bitsPerNode <- seq(8.5,35,0.5)

## add extra space to right margin of plot within frame
par(mar=c(5, 4, 4, 6) + 0.1)

## Plot first set of data and draw its axis
plot(time, betagal.abs, pch=16, axes=FALSE, ylim=c(0,1), xlab="", ylab="", 
	    type="b",col="black", main="Mike's test data")
axis(2, ylim=c(0,1),col="black",las=1)  ## las=1 makes horizontal labels
mtext("Avg Query Time (milliseconds)",side=2,line=2.5)
box()

## Allow a second plot on the same graph
par(new=TRUE)

## Plot the second plot and put axis scale on right
plot(time, cell.density, pch=15,  xlab="", ylab="", ylim=c(0,7000), 
	     axes=FALSE, type="b", col="red")
## a little farther out (line=4) to make room for labels
mtext("Bits per Node",side=4,col="red",line=4) 
axis(4, ylim=c(0,7000), col="red",col.axis="red",las=1)

## Draw the time axis
axis(1,pretty(range(time),10))
mtext("|V|",side=1,col="black",line=2.5)  

## Add Legend
legend("topleft",legend=c("Query Time","Bits/Node"),
	     text.col=c("black","red"),pch=c(16,15),col=c2("black","red"))
