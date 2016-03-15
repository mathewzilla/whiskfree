#Hildebrand diagram
rm(list=ls())
setwd("\\\\nask.man.ac.uk\\home$\\Desktop")
mydataset=read.csv("Mouse_data.csv")
attach(mydataset)
"MTH25"<-mydataset[ which(mydataset$ID=='TH26'),]
rm(mydataset)
detach(mydataset)

#plot graph 
attach (MTH25)
"Lick"<-MTH25[ which(MTH25$Protocol=='Lick'),]
"Full"<-MTH25[ which(MTH25$Protocol=='Full'),]
"LR"<-MTH25[ which(MTH25$Protocol=='LR'),]
"gonogo"<-MTH25[ which(MTH25$Protocol=='gonogo'),]

x<-c(Day_t)
y<-c(Performance)
plot(x,y, xlim=c(0,114), ylim=c(0,1), ylab="Performance", xlab="Days trained", pch=16, cex=0.2 )
lines(x,y,col="cornflowerblue")
detach(MTH25)

attach(Lick)
xLick<-c(Day_t)
yLick<-c(Performance)
plot(xLick,yLick, col="firebrick3", xlim=c(0,114), ylim=c(0,1), ylab="Performance", xlab="Days trained", pch=16 )
detach(Lick)

attach(LR)
xLR<-c(Day_t)
yLR<-c(Performance)
points(xLR,yLR, col="goldenrod1", pch=17 )
detach(LR)

attach(Full)
xFull<-c(Day_t)
yFull<-c(Performance)
points(xFull,yFull, col="green3", pch=18 )
detach(Full)

attach(gonogo)
xgonogo<-c(Day_t)
ygonogo<-c(Performance)
points(xgonogo,ygonogo, col="darkorange2", pch=15 )
lines(x,y,col="cornflowerblue")
detach(gonogo)

lines(y=c(0.7,0.7),x=c(0,114),lty = 2, col="darkgray")
text(114,0.9, labels="TH26")
detach(MTH25)







# #plot graph 
# attach (M37)
# "Lick"<-M37[ which(M37$Protocol=='Lick'),]
# "Full"<-M37[ which(M37$Protocol=='Full'),]
# "LR"<-M37[ which(M37$Protocol=='LR'),]
# "gonogo"<-M37[ which(M37$Protocol=='gonogo'),]
# attach(Lick)
# x<-c(Day_t)
# y<-c(Performance)
# points(x,y, col="indianred1", pch=16 )
# lines(x,y,col="indianred3")
# rm(Lick)
# attach(LR)
# x<-c(Day_t)
# y<-c(Performance)
# points(x,y, col="indianred3", pch=17 )
# lines(x,y,col="indianred3")
# rm(LR)
# attach(Full)
# x<-c(Day_t)
# y<-c(Performance)
# points(x,y, col="indianred4", pch=18 )
# lines(x,y,col="indianred3")
# rm(Full)
# attach(gonogo)
# x<-c(Day_t)
# y<-c(Performance)
# points(x,y, col="indianred3", pch=15 )
# lines(x,y,col="indianred3")
# rm(gonogo)
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# attach(gonogo)
# x<-c(Day_t)
# y<-c(Performance)
# points(x,y, col="orange", pch=15 )
# lines(x,y)
# rm(gonogo)

