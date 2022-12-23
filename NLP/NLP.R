library(tidyverse)
library(tidytext)

# setwd("C:/Users/Griffin Ong/Documents/GitHub/Code-Samples/NLP")

sentiment_nrc <-   
  get_sentiments("nrc") %>%
  rename(nrc = sentiment)
sentiment_afinn <- 
  get_sentiments("afinn") %>%
  rename(afinn = value)
sentiment_bing <-  
  get_sentiments("bing") %>%
  rename(bing = sentiment)

# read in file and create dataframe without stop words 
unhcr <- read_file("sample_text.txt")

unhcr_text_df <- tibble(text = unhcr)

unhcr_tokens_df <- unnest_tokens(unhcr_text_df, 
                                 word_tokens, text, token = "words")

unhcr_no_sw <- anti_join(unhcr_tokens_df, 
                         stop_words, by = c("word_tokens" = "word"))

unhcr_no_sw <- unhcr_no_sw %>%
  left_join(sentiment_nrc, by = c("word_tokens" = "word")) %>%
  left_join(sentiment_afinn, by = c("word_tokens" = "word")) %>%
  left_join(sentiment_bing, by = c("word_tokens" = "word"))

# bigrams + double-check for any negation - nothing notable 
unhcr_bigrams <- unnest_tokens(unhcr_text_df, bigrams, text, 
                               token = "ngrams", n = 2) 
unhcr_bigrams_sep <- separate(unhcr_bigrams, bigrams, 
                              c("word1", "word2"), sep = " ")

bigrams_filter <- unhcr_bigrams_sep %>%
  filter(!word1 %in% stop_words$word) %>%
  filter(!word2 %in% stop_words$word)

bigrams_unite <- unite(bigrams_filter, bigram, word1, word2, sep = " ")

# plots - nrc, bing, and afinn libraries 
ggplot(data = filter(unhcr_no_sw, !is.na(nrc))) +
  geom_histogram(aes(nrc), stat = "count") +
  scale_x_discrete(guide = guide_axis(angle = 45))

ggplot(data = filter(unhcr_no_sw, !is.na(bing))) +
  geom_histogram(aes(bing), stat = "count") +
  scale_x_discrete(guide = guide_axis(angle = 45)) 

ggplot(data = filter(unhcr_no_sw, !is.na(afinn))) +
  geom_histogram(aes(afinn), stat = "count") +
  scale_x_continuous(n.breaks = 7) 
