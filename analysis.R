# analysis.r

library(tidyverse)
library(rtweet)
c
datasets <- read_tsv("data/datasets.tsv")
t <- read_tsv("data/tweets.tsv")
t$status_id <- str_split(t$status_url, "/") %>% 
  map_chr(~ .[[6]])

t <- rtweet::lookup_statuses(t$status_id, token = token)
