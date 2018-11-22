library(gganimate)
library(tidyverse)
library(okcupiddata)
library(icon)

data(profiles)
profiles_red <- profiles %>% select(pets, sex, status, sign)

profiles_red <- profiles_red %>% mutate(sign = str_extract(sign, "[a-z']+[[:space:]]"))
profiles_red <- profiles_red %>% 
  mutate(pets_dislike = case_when(
    str_detect(pets, "dislikes dogs and dislikes cats") ~ "dogs/cats",
    str_detect(pets, "dislikes dogs") ~ "dogs", 
    str_detect(pets, "dislikes cats") ~ "cats"))
profiles_red <- profiles_red %>% mutate(sign = gsub(" ", "", sign))
profiles_red <- profiles_red %>% 
  mutate(pets_like = case_when(
    str_detect(pets, "likes dogs and likes cats") ~ "dogs/cats",
    str_detect(pets, "likes dogs") ~ "dogs", 
    str_detect(pets, "likes cats") ~ "cats"))
profiles_red <- profiles_red %>% 
  mutate(pets_has = case_when(
    str_detect(pets, "has dogs and has cats") ~ "dogs/cats",
    str_detect(pets, "has dogs") ~ "dogs", 
    str_detect(pets, "has cats") ~ "cats"))

# define factor
profiles_red <- profiles_red %>% filter(!is.na(sign))
profiles_red <- profiles_red %>% 
  mutate(sign = factor(sign, levels=c("aries", "taurus", "gemini", "cancer",
                                      "leo", "virgo", "libra", "scorpio",
                                      "sagittarius", "capricorn", "aquarius",
                                      "pisces"))) 

# start with easy ggplot
ggplot(profiles_red, aes(x =pets_dislike)) + geom_bar() + facet_grid(~ sign)
ggplot(profiles_red, aes(x =pets_like)) + geom_bar() + facet_grid(~ sign)
ggplot(profiles_red, aes(x =pets_has)) + geom_bar() + facet_grid(~ sign)

dislike_plot <- ggplot(profiles_red, aes(x =pets_dislike)) + geom_bar() 
dislike_plot + transition_manual(sign)

like_plot <- ggplot(profiles_red, aes(x =pets_like)) + geom_bar() 
like_plot + transition_manual(sign) + labs(title="{current_frame}")

has_plot <- ggplot(profiles_red, aes(x =pets_has)) + geom_bar() 
has_plot + transition_manual(sign) + labs(title="{current_frame}")
