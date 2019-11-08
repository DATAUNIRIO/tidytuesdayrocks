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

urls <- d %>% 
  select(urls_expanded_url) %>%
  filter(!is.na(urls_expanded_url))

urls$domains <- urltools::domain(urls$urls_expanded_url) 

library(longurl)
shorteners <- c("bit.ly", "ow.ly", "buff.ly", "goo.gl", "ln.is", "tinyurl.com", "share.es", "ht.ly", "fb.me", "wp.me", "ift.tt")

to_expand <- urls %>% 
  filter(domains %in% shorteners)

expanded <- expand_urls(to_expand$urls_expanded_url)

urls <- d %>% 
  select(urls_expanded_url) %>%
  filter(!is.na(urls_expanded_url)) %>% 
  pull(urls_expanded_url)

all_urls <- c(urls, expanded$expanded_url)
urltools::domain(all_urls)

url_d <- tibble(url = all_urls,
                domain = urltools::domain(url)) %>%
  filter(domain == "github.com" | domain == "gist.github.com") %>% 
  select(-domain)

write_csv(url_d, "all-urls.csv")

github_urls <- all_urls %>% 
  filter(str_detect(urls_expanded_url, "git"))

GITHUB_PAT <- '8442580d453cff1213803abdafcc72f9fc147cc3'

gh::gh("/repos/jrosen48/dissertation", token = GITHUB_PAT)

