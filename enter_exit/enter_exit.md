enter\_exit
================
Robbie Bonelli
22/11/2018

What does `transition_time()` do?
=================================

> The purpose of enter\_*() and exit\_*() is to control what happens with data that does not persist during a tween.

In simple words it controls how data that either appear and or disapper in the plot because of the animation will enter or exit the plot.

To understand better:

Create fake data
----------------

``` r
dat <- data.frame(id=c(rep("robbie",4),rep("saskia",5),rep("anna",7)),time=c(1:4,2:6,4:10))
dat$money <- rnorm(nrow(dat))*dat$time

ggplot(dat)+geom_line(aes(x=time,y=money,group=id,color=id),size=2)
```

![](enter_exit_files/figure-markdown_github/unnamed-chunk-1-1.png)

This dataset contains time data for three people and how much money they have. Note that each person enters the total time frame for a limited amount of time. This means that if we animate around time, some people should disappers and appers depending on the time point we are visualising.

These parameters let you control that!

Simple sudden apper
===================

``` r
p <- ggplot(dat, aes(x=time,group=id))+ geom_label(aes(y=money,label=id,color=id),size=10) +  transition_time(time=time)+enter_appear()+exit_disappear()
animate(p)
```

![](enter_exit_files/figure-markdown_github/unnamed-chunk-2-1.gif)

Growing and Shrinking
---------------------

``` r
p <- ggplot(dat, aes(x=time,group=id))+ geom_label(aes(y=money,label=id,color=id),size=10) +  transition_time(time=time)+enter_grow()+exit_shrink()
animate(p)
```

![](enter_exit_files/figure-markdown_github/unnamed-chunk-3-1.gif)

Fading
------

``` r
p <- ggplot(dat, aes(x=time,group=id))+ geom_label(aes(y=money,label=id,color=id),size=10) +  transition_time(time=time)+enter_fade()+exit_fade()
animate(p)
```

![](enter_exit_files/figure-markdown_github/unnamed-chunk-4-1.gif)

Enter or Exit need the grouping factor!
=======================================

Let's try to take off the grouping

``` r
p <- ggplot(dat, aes(x=time))+ geom_label(aes(y=money,label=id),size=10) +  transition_time(time=time)+enter_appear()+exit_disappear()
animate(p)
```

![](enter_exit_files/figure-markdown_github/unnamed-chunk-5-1.gif)

As we see this not work properly!
