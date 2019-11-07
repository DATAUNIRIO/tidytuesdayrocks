# analysis.r

library(tidyverse)
library(rtweet)

# t <- read_tsv("data/tweets.tsv")
# t$status_id <- str_split(t$status_url, "/") %>%
#   map_chr(~ .[[6]])
# 
# s <- lookup_statuses(t$status_id, token = token)
# 
# write_rds(s, "processed-data/processed-data.rds")

d <- read_rds("processed-data/processed-data.rds")

d

d <- flatten(d)

d %>% 
  filter(!is_retweet) %>% 
  count(screen_name) %>% 
  arrange(desc(n))

urls <- d %>% 
  select(urls_expanded_url) %>%
  filter(!is.na(urls_expanded_url))

library(twitteR)
decode_short_url("http://bit.ly/23226se656")

expanded_urls <- twitteR::decode_short_url(urls)

github_urls <- urls %>% 
  filter(str_detect(urls_expanded_url, "git"))

GITHUB_PAT <- '8442580d453cff1213803abdafcc72f9fc147cc3'

gh::gh("/repos/jrosen48/dissertation", token = GITHUB_PAT)

