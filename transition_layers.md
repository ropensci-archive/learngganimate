transistion\_layers
================
Adam Gruer
22/11/2018

# transistion\_layers()

## what do I think it will do?

I think it will add a frame for each geom\_ I add to the plot.

# What does the help say

``` r
?transition_layers
```

> ## Build up a plot, layer by layer
> 
> This transition gradually adds layers to the plot in the order they
> have been defined. By default prior layers are kept for the remainder
> of the animation, but they can also be set to be removed as the next
> layer enters.

> ## Usage

> transition\_layers(layer\_length, transition\_length, keep\_layers =
> TRUE, from\_blank = TRUE, layer\_names = NULL)

# First attempt

add three layers geom\_point and geom\_histogram and a geom\_bar It did
do as I expected.

I still struggle to understand the layer\_length and transition\_length
beyond them being relative times

``` r
 ggplot(mtcars ) + 
  geom_point(aes(disp, mpg), colour = "purple", size = 3)  +
  geom_histogram(aes(disp)) +
  geom_bar(aes(cyl))+
  transition_layers(layer_length = 1, transition_length = 1, keep_layers = TRUE)
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](transition_layers_files/figure-gfm/first%20attempt-1.gif)<!-- -->

It is very literal. `ggplot(mtcars)` is a layer albeit an uninteresting
one. However one of the arguments `from_blank` which defaults to TRUE
can be changed to FALSE so as to not show this first layer.

Here i show the effect of not showing the first ‘blank’ layer.

``` r
 ggplot(mtcars ) + 
  geom_point(aes(disp, mpg), colour = "purple", size = 3)  +
  geom_histogram(aes(disp)) +
    geom_bar(aes(cyl))+
  transition_layers(layer_length = 1, transition_length = 1, keep_layers = TRUE, from_blank =  FALSE ) 
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](transition_layers_files/figure-gfm/hid%20blank%20layer-1.gif)<!-- -->

I can choose not to keep each layer as I animate by setting `keep_layers
= FALSE`

``` r
 ggplot(mtcars ) + 
  geom_point(aes(disp, mpg), colour = "purple", size = 3)  +
  geom_histogram(aes(disp)) +
    geom_bar(aes(cyl))+
  transition_layers(layer_length = 1, transition_length = 1, keep_layers = FALSE, from_blank =  FALSE ) 
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](transition_layers_files/figure-gfm/dont%20keep%20layers-1.gif)<!-- -->

I can supply layer names to be used as label literals

``` r
ggplot(mtcars ) + 
  geom_point(aes(disp, mpg), colour = "purple", size = 3)  +
  geom_histogram(aes(disp)) +
    geom_bar(aes(cyl)) +
  labs(title = "{closest_layer}") +
  transition_layers(layer_length = 1, transition_length = 1, keep_layers = FALSE, from_blank =  FALSE, layer_names  = c("geom_point(disp,mpg)",
                                                                                                                        "geom_histogram(disp)",
                                              "geom_bar(cyl)")
                    ) 
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](transition_layers_files/figure-gfm/supply%20label%20literals-1.gif)<!-- -->
