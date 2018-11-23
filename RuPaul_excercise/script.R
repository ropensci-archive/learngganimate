library(gganimate)
library(dplyr)
library(readxl)
library(stringr)
library(png)
library(ggimage)
library(gridGraphics)



rm(list=ls())
dat <- read_excel("~/Desktop/learngganimate/RuPaul_excercise/rpdr_data.xlsx")
head(dat)
dat$Notes <- NULL
dat[is.na(dat)] <- 0
dat$time <- dat$Start

dat$top <- dat$Wins+dat$Highs


# load the images

images <- read_excel("~/Desktop/learngganimate/RuPaul_excercise/images.xlsx", col_names = FALSE)


images$Name <-str_match(images$X__2, '"(.*?)"')[,2]
images$pic <-str_match(images$X__5, '"(.*?)"')[,2]
images <- images[,c("Name","pic")]
images$Name[images$Name=="Alaska Thunderfuck 5000"] <- "Alaska"
images$Name[images$Name=="Roxxy Andrews"] <- "Roxxxy Andrews"
images$Name[images$Name=="Detox Icunt"] <- "Detox"
images$Name[images$Name=="Vivienne Piney"] <- "Vivienne Pinay"
images$Name[images$Name=="Monica Beverly Hills"] <- "Monica Beverly Hillz"
images$Name[images$Name=="Serena Cha Cha"] <- "Serena ChaCha"
images$Name[images$Name=="Penny Tration"] <- "Penny Traition"

dat <- left_join(dat,images)

dat <- dat[!dat$Name%in%c("Vivienne Pinay","Monica Beverly Hillz"),]

dat <- dat %>% group_by(Season)%>% mutate(add=as.numeric(as.factor(Name))/ (length(unique(Name))+1) )

dat$top <- dat$top +dat$add

dat$add1 <- dat$add

d1 <- dat[dat$Season==5,]


# Eleiminate queens that do not have images

d <- unique(d1[,c("Name","pic")])


#for(i in 11:nrow(d)){
#  download.file(d$pic[i],paste("~/Desktop/workshops/",d$Name[i],'.jpg',sep = ""), mode = 'wb')
#}

d <- d1[!is.na(d1$pic),]
d$image <- paste("~/Desktop/learngganimate/RuPaul_excercise/",d$Name,'.png',sep = "")






background <-  jpeg::readJPEG("~/Desktop/learngganimate/RuPaul_excercise/background.jpg")

p <- ggplot(d,aes(x=time,y=add,group=Name,color=Name))+annotation_custom(rasterGrob(background,  width = unit(1,"npc"), height = unit(1,"npc")), -Inf, Inf, -Inf, Inf)+geom_line()+ geom_image(aes(image=image),size=0.1)+guides(color=F)+theme_void()+
  transition_reveal(Name,time,keep_last = F)
animate(p,nframes = 30)



p <- ggplot(d,aes(x=add,y=time,group=Name,color=Name))+annotation_custom(rasterGrob(background,  width = unit(1,"npc"), height = unit(1,"npc")), -Inf, Inf, -Inf, Inf)+ geom_image(aes(image=image),size=0.1)+guides(color=F)+theme_void()+
  transition_time(time = time)+ enter_grow() + exit_shrink()
animate(p,nframes = 50)









dat2 <- d[,c("Name","time")]
d2 <-  unique( d[,c("Name")])
d2$time <- -1
dat3 <- rbind(dat2,d2)
d2 <-  data.frame(Name= rep(c("Jinkx Monsoon","Alaska","Roxxxy Andrews"),c(3,2,1)),time=c(13,12,11,12,11,11)  )
dat3 <- rbind(dat3,d2)

dat4 <- merge(dat3,unique(d[,c("Name","add","image")]) ) 





p <- ggplot(dat4,aes(x=add,y=time,group=Name,color=Name))+annotation_custom(rasterGrob(background,  width = unit(1,"npc"), height = unit(1,"npc")), -Inf, Inf, -Inf, Inf)+ geom_image(aes(image=image),size=0.1)+guides(color=F)+theme_void()+
  transition_time(time = time)+ enter_grow() + exit_shrink()
animate(p,nframes = 50)







#Try adding the shadow

p <- ggplot(dat4,aes(x=add,y=time,group=Name,color=Name))+annotation_custom(rasterGrob(background,  width = unit(1,"npc"), height = unit(1,"npc")), -Inf, Inf, -Inf, Inf)+ geom_image(aes(image=image),size=0.1)+guides(color=F)+theme_void()+
  transition_time(time = time)+shadow_wake(wake_length = .3, size =0.01, colour = "white",falloff = "quintic-in"
  )+ enter_grow() + exit_shrink()
animate(p,nframes = 25,detail = 5, type = "cairo")



dat5 <- dat4
dat5$x <- as.numeric(as.factor(dat5$Name))
dat5$size=0.1
d5 <- dat5[dat5$Name=="Jinkx Monsoon",][1,]
d5$time <- 14
d5$x <- median(dat5$x)
d5$size <- 1

dat5 <- rbind(dat5,d5)





p <- ggplot(dat5,aes(x=x,y=time,group=Name,color=Name))+annotation_custom(rasterGrob(background,  width = unit(1,"npc"), height = unit(1,"npc")), -Inf, Inf, -Inf, Inf)+ geom_image(aes(image=image,size=size))+scale_size_continuous(range = c(0.1,2))+guides(color=F)+theme_void()+
  transition_time(time = time)+shadow_wake(wake_length = .3, size =0.01, colour = "white",falloff = "quintic-in"
  )+ enter_grow() + exit_shrink()
animate(p,nframes = 50,detail = 5, type = "cairo",duration = 10)




















































