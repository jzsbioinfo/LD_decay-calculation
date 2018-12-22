#plot simple ld decay
ld=read.table("4kin_yunandel5.ld.sort.cp")


head(ld)

x=ld[,1]
y=ld[,2]
x=log(x,10)

plot(x,y,xlim=c(1.5,6),ylim=c(0,1),xlab = ("log_distance"),ylab = ("r2"),
     pch=20,
     col="black",
     cex=0.8)