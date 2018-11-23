GIF Eleganza Extravanganza with RuPaul Drag Race Seaosn 5
================
Robbie Bonelli
23/11/2018

This is a fabulous example on how we can use `gganimate`!
=========================================================

![FAB](https://pixel.nymag.com/imgs/daily/vulture/2017/08/22/22-rupaul-history-1.w700.h700.jpg)

The data used fot this can be found here:

-   [Survival Data](http://badhessian.org/2013/03/lipsyncing-for-your-life-a-survival-analysis-of-rupauls-drag-race/)
-   [Image Data](https://drag-race-api.readme.io/docs)

``` r
knitr::opts_chunk$set(echo = TRUE,cache = T)

# Load the packages

library(gganimate)
library(dplyr)
library(readxl)
library(stringr)
library(png)
library(ggimage)
library(gridGraphics)


# read the data

rm(list=ls())
dat <- read_excel("~/Desktop/learngganimate/RuPaul_excercise/rpdr_data.xlsx")
head(dat)
```

    ## # A tibble: 6 x 15
    ##   Season    ID Name    Age PuertoRico PlusSize Place Start   End   Out
    ##    <dbl> <dbl> <chr> <dbl>      <dbl>    <dbl> <dbl> <dbl> <dbl> <dbl>
    ## 1      1     1 Bebe…    28          0        0     1     0     1     0
    ## 2      1     1 Bebe…    28          0        0     1     1     2     0
    ## 3      1     1 Bebe…    28          0        0     1     2     3     0
    ## 4      1     1 Bebe…    28          0        0     1     3     4     0
    ## 5      1     1 Bebe…    28          0        0     1     4     5     0
    ## 6      1     1 Bebe…    28          0        0     1     5     6     0
    ## # ... with 5 more variables: Wins <dbl>, Highs <dbl>, Lows <dbl>,
    ## #   Lipsyncs <dbl>, Notes <chr>

``` r
dat$Notes <- NULL
dat[is.na(dat)] <- 0
dat$time <- dat$Start


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
d1 <- dat[dat$Season==5,]


# Eleiminate queens that do not have images

d <- unique(d1[,c("Name","pic")])

# Dowload the quee's pictures
#for(i in 11:nrow(d)){
#  download.file(d$pic[i],paste("~/learngganimate/RuPaul_excercise/",d$Name[i],'.jpg',sep = ""), mode = 'wb')
#}


# Change into PNG names
d <- d1[!is.na(d1$pic),]
d$image <- paste("~/Desktop/learngganimate/RuPaul_excercise/",d$Name,'.png',sep = "")


# Read the background image
background <-  jpeg::readJPEG("~/Desktop/learngganimate/RuPaul_excercise/background.jpg")




# Add the actual winners
dat2 <- d[,c("Name","time")]
d2 <-  unique( d[,c("Name")])
d2$time <- -1
dat3 <- rbind(dat2,d2)
d2 <-  data.frame(Name= rep(c("Jinkx Monsoon","Alaska","Roxxxy Andrews"),c(3,2,1)),time=c(13,12,11,12,11,11)  )
dat3 <- rbind(dat3,d2)
dat4 <- merge(dat3,unique(d[,c("Name","image")]) ) 


# Bring the last queen to the centre!
dat5 <- dat4
dat5$x <- as.numeric(as.factor(dat5$Name))
dat5$size=0.1
d5 <- dat5[dat5$Name=="Jinkx Monsoon",][1,]
d5$time <- 14
d5$x <- median(dat5$x)
d5$size <- 1

dat5 <- rbind(dat5,d5)
```

And now the result! 💇 ❤️ 💅
==========================

For a full experience please click the image below first

[![For a full experience please click here](http://img.youtube.com/vi/B4vsWgECZ6s/0.jpg)](http://www.youtube.com/watch?v=B4vsWgECZ6s)

``` r
p <- ggplot(dat5,aes(x=x,y=time,group=Name,color=Name))+annotation_custom(rasterGrob(background,  width = unit(1,"npc"), height = unit(1,"npc")), -Inf, Inf, -Inf, Inf)+ geom_image(aes(image=image,size=size))+scale_size_continuous(range = c(0.1,2))+guides(color=F,size=F)+theme_void()+
  transition_time(time = time)+shadow_wake(wake_length = .3, size =0.01, colour = "white",falloff = "quintic-in"
  )+ enter_grow() + exit_shrink()
animate(p,nframes = 100,detail = 5, type = "cairo",duration = 10)
```

![](making_gganimate_fab_files/figure-markdown_github/rupaulgif-1.gif)
