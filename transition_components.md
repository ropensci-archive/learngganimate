transition\_components
================
Anna Quaglieri
22/11/2018

-   [How does `transition_components()` work?](#how-does-transition_components-work)
-   [Example with babynames](#example-with-babynames)

``` r
devtools::install_github("hadley/emo")
devtools::install_github("ropenscilabs/icon")
```

``` r
library(gganimate)
library(tidyverse)
library(fivethirtyeight)
```

How does `transition_components()` work?
========================================

> Transition individual components through their own lifecycle
> ------------------------------------------------------------
>
> This transition allows individual visual components to define their own "life-cycle". This means that the final animation will not have any common "state" and "transition" phase as any component can be moving or static at any point in time.

> Usage
> -----
>
> transition\_components(id, time, range = NULL, enter\_length = NULL, exit\_length = NULL)

To understand how `transition_components()` works I will use the `US_births_1994_2003` dataset from the `fivethirtyeight` package. The title of the article where this data was used is *Some People Are Too Superstitious To Have A Baby On Friday The 13th*. Is that true?

``` r
head(US_births_1994_2003)
```

    ## # A tibble: 6 x 6
    ##    year month date_of_month date       day_of_week births
    ##   <int> <int>         <int> <date>     <ord>        <int>
    ## 1  1994     1             1 1994-01-01 Sat           8096
    ## 2  1994     1             2 1994-01-02 Sun           7772
    ## 3  1994     1             3 1994-01-03 Mon          10142
    ## 4  1994     1             4 1994-01-04 Tues         11248
    ## 5  1994     1             5 1994-01-05 Wed          11053
    ## 6  1994     1             6 1994-01-06 Thurs        11406

Some key points to keep in mind:

In `transition_component()` you need and **id** and **time** components. The `transition_components()` function is useful when you have the same identifier (like a plane, a day, a person, a neighborood etc..) with multiple observation over time.

In this example my **id** will be Fridays of the month. For example, one id if **Fri\_1** which is the 1st Friday of a generic month across years. My plan is to compare the number of babies born on the Fridays 13th of different months (**Fri\_13**) with baby born on other Fridays! To speed uo the process I will compare Fridays 13th with Fridays that occurs on the 1st, 2nd, 3rd, 18th and 28th across months and years.

``` r
fridays <- US_births_1994_2003 %>% 
  filter(day_of_week %in% c("Fri") & date_of_month %in% c(1,2,3,13,18,28))

p=ggplot(fridays) + 
  geom_point(aes(x=year,y=births,colour=date_of_month)) +
  facet_wrap(~date_of_month)+
  theme(legend.position = "bottom") +
  transition_components(id=factor(date_of_month),time=date)+
  shadow_trail(distance = 0.01, size = 0.3)

animate(p, nframes = 50, 10,duration=10)
```

![](transition_components_files/figure-markdown_github/unnamed-chunk-3-1.gif)

To me, really, it doesn't seem like parents go out of their way to avoid births on Friday 13th!

Example with babynames
======================

The `babynames` is one of the great packages developed thanks to the effort of another \#OzUnconf18 team <https://github.com/ropenscilabs/ozbabynames>!

Below I am showing another example that uses `transition_components()` in combination with other fun animations like:

-   `shadow_trail()` which allows you to customise the way in which your observations leave a trace of themselves once they move on with their transitions.

-   Within `shadow_trail()`, the argument `distance` let's you specify the distance between each trace left. I noticed that it does not work with a very small distance (0.001 wasn't working). It has something to do with the fact that `distance` is used a denominator at some steps and probably it gets too small.
-   The argument `size` works like in the normal `ggplot()` (e.g. size of dots) and it specify the size of trace left.

``` r
# install_github("ropenscilabs/ozbabynames")
library(ozbabynames)

p=ggplot(ozbabynames[ozbabynames$name %in% c("Michael","James"),]) + 
  geom_point(aes(x=year,y=count,colour=name)) +
  theme_bw() + 
  transition_components(id=name,time=year)+
  shadow_trail(distance = 0.1, size = 2)
p
```

![](transition_components_files/figure-markdown_github/unnamed-chunk-4-1.gif)

-   Let's increase the `distance`

``` r
p=ggplot(ozbabynames[ozbabynames$name %in% c("Michael","James"),]) + 
  geom_point(aes(x=year,y=count,colour=name)) +
  transition_components(id=name,time=year)+
  shadow_trail(distance = 2, size = 2)
p
```

![](transition_components_files/figure-markdown_github/unnamed-chunk-5-1.gif)

-   `distance` to small. The code below will throw the error:

> Error in seq.default(1, params*n**f**r**a**m**e**s*, *b**y* = *p**a**r**a**m**s*distance) : invalid '(to - from)/by'

``` r
p=ggplot(ozbabynames[ozbabynames$name %in% c("Michael","James"),]) + 
  geom_point(aes(x=year,y=count,colour=name)) +
  transition_components(id=name,time=year)+
  shadow_trail(distance = 0.001, size = 2)

p
```
