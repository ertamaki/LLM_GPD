#     ,---.  ,--.         ,----.   ,------. ,------.  
#    /  O  \ |  |        '  .-./   |  .--. '|  .-.  \ 
#   |  .-.  ||  |        |  | .---.|  '--' ||  |  \  :
#   |  | |  ||  |        '  '--'  ||  | --' |  '--'  /
#   `--' `--'`--'         `------' `--'     `-------'  
# |--------------------- AI GPD ---------------------|
# <---------------- CoT + RAG Script ---------------->
# Chain-of-Thought Multimodel RAG pipeline for populism scoring (Team Populism's GPD)
# + Cross-encoder Re-ranking with Score Rank Fusion
# ---------------------------------------------------------------------------- #
# Author: Eduardo Tamaki (eduardo@tamaki.ai) & Yujin Jung (yujinjuliajung@gmail.com)
# Date: July 17, 2025
#
# This script encapsulates the full retrieval-augmented populism scoring pipeline
# designed by Team Populism's AI research team. It combines a few-shot, holistic
# grading framework with a multimodal retrieval system and local LLM inference.
# ---------------------------------------------------------------------------- #

# PREAMBLE ---------------------------------------------------------------------

# Loading up packages
install.packages("pacman") 

# Installing AskOllama to access Monster
## ! Remember to connect to server using ZeroTier
### 1) Ensure {devtools} is available to install GitHub packages if needed
if (!requireNamespace("devtools", quietly = TRUE)) install.packages("devtools")

### 2) If you have installed it already, reinstall the development version of 
###    AskOllama (might have an update).
###    Use `force = TRUE` to ensure updates always overwrite older versions 
devtools::install_github("ertamaki/AskOllama", force = TRUE)

# Loading packages with `pacman::p_load()`
pacman::p_load(reticulate, # v1.42.0
               AskOllama,  # v2.0.03 
               here,       # v1.0.1
               tidyverse   # v2.0.0
               )

# Cleaning the environment
rm(list = ls())

# Loading Extras: 
## 1) Prompt: RAG and CoT prompts
source(here("p_prompts.R"))

## 2) Speeches: speeches we want to score 
##              !!! REPLACE THIS WITH THE SPEECHES YOU WANT TO CODE !!!
source(here("uk_speeches.R"))
##              >>> A different way to approach this would be to use something 
##              >>> like readr::read_delim().

## 3) Functions for Bootstrap CI, OpenAI call, and some other things
source(here("f_extra.R"))

# Setting up OpenAI's API:
# API for o4: 
GPT_api_key <- "YOUR KEY"

# API for 4o - o4's API belongs to our GFDD group. 
#              However, tier limitations make it difficult to use it for 4o.
#              So, we use the API for our (Levi and Eduardo) project. 
# GPT_api_key <- "YOUR KEY"


# 1) Grading (CoT) -------------------------------------------------------------

## A. CAMPAIGN SPEECH ----------------------------------------------------------
# +-----------------------------+------------------+----------------------------------------+
# | Model                       |  Type            | API Version                            | 
# +-----------------------------+------------------+----------------------------------------+
# | Proprietary Models                                                                      |
# | o4-mini (high)              | reasoning (high) | o4-mini-2025-04-16                     |
# | 4o                          | vanilla          | gpt-4o-2024-08-06                      |
# |-----------------------------+------------------+----------------------------------------|
# | Open-weight Models                                                                      |
# | Qwen3 235B                  | reasoning MoE    | qwen3:235b                             |
# | Qwen3 235B (reasoning off)  | MoE              | qwen3:235b                             |
# | Mistral Large               | vanilla          | mistral-large:123b-instruct-2411-q8_0  |     
# +-----------------------------+------------------+----------------------------------------+

### Model:
### o4-mini --------------------------------------------------------------------
CoT.messages.GPT <- build_CoT_prompt.GPT(new_speech)

uk_camp_GPT_CoT <- vector("list", 5)
for(i in seq_len(5)) {
  uk_camp_GPT_CoT[i] <- make_openai_call(model = "o4-mini",
                                         reasoning = "high",
                                         user_content = CoT.messages.GPT)
}

# save(uk_camp_GPT_CoT, file = "uk_camp_GPT_CoT.RData")

### Model:
### 4o -------------------------------------------------------------------------
CoT.messages.GPT <- build_CoT_prompt_components(new_speech)

uk_camp_GPT4o_CoT <- vector("list", 5)
for(i in seq_len(5)) {
  uk_camp_GPT4o_CoT[i] <- make_openai_call(
    model = "gpt-4o",
    system_content = CoT.messages.GPT$system_content,
    user_content = CoT.messages.GPT$user_content,
    few_shot_examples = CoT.messages.GPT$few_shot_examples
  )
  # Sys.sleep(60)
}

# save(uk_camp_GPT4o_CoT, file = "uk_camp_GPT4o_CoT.RData")


## B. FAMOUS SPEECH ------------------------------------------------------------
### Model:
### o4-mini --------------------------------------------------------------------
CoT.messages.GPT <- build_CoT_prompt.GPT(new_speech_famous)

uk_famous_GPT_CoT <- vector("list", 5)
for(i in seq_len(5)) {
  uk_famous_GPT_CoT[i] <- make_openai_call(model = "o4-mini",
                                           reasoning = "high",
                                           user_content = CoT.messages.GPT)
}

# save(uk_famous_GPT_CoT, file = "uk_famous_GPT_CoT.RData")

### 4o -------------------------------------------------------------------------
CoT.messages.GPT <- build_CoT_prompt_components(new_speech_famous)

uk_famous_GPT4o_CoT <- vector("list", 5)
for(i in seq_len(5)) {
  uk_famous_GPT4o_CoT[i] <- make_openai_call(
    model = "gpt-4o",
    system_content = CoT.messages.GPT$system_content,
    user_content = CoT.messages.GPT$user_content,
    few_shot_examples = CoT.messages.GPT$few_shot_examples
  )
  # Sys.sleep(60)
}

# save(uk_famous_GPT4o_CoT, file = "uk_famous_GPT4o_CoT.RData")

## C. INTERNATIONAL SPEECH -----------------------------------------------------
### Model:
### o4-mini --------------------------------------------------------------------
CoT.messages.GPT <- build_CoT_prompt.GPT(new_speech_int)

uk_int_GPT_CoT <- vector("list", 5)
for(i in seq_len(5)) {
  uk_int_GPT_CoT[i] <- make_openai_call(model = "o4-mini",
                                        reasoning = "high",
                                        user_content = CoT.messages.GPT)
}

# save(uk_int_GPT_CoT, file = "uk_int_GPT_CoT.RData")

### Model:
### 4o -------------------------------------------------------------------------
CoT.messages.GPT <- build_CoT_prompt_components(new_speech_int)

uk_int_GPT4o_CoT <- vector("list", 5)
for(i in seq_len(5)) {
  uk_int_GPT4o_CoT[i] <- make_openai_call(
    model = "gpt-4o",
    system_content = CoT.messages.GPT$system_content,
    user_content = CoT.messages.GPT$user_content,
    few_shot_examples = CoT.messages.GPT$few_shot_examples
  )
  # Sys.sleep(60)
}

# save(uk_int_GPT4o_CoT, file = "uk_int_GPT4o_CoT.RData")

## D. RIBBON-CUTTING SPEECH ----------------------------------------------------
### Model:
### o4-mini --------------------------------------------------------------------
CoT.messages.GPT <- build_CoT_prompt.GPT(new_speech_rc)

uk_rc_GPT_CoT <- vector("list", 5)
for(i in seq_len(5)) {
  uk_rc_GPT_CoT[i] <- make_openai_call(model = "o4-mini",
                                        reasoning = "high",
                                        user_content = CoT.messages.GPT)
}

# save(uk_rc_GPT_CoT, file = "uk_rc_GPT_CoT.RData")

### Model:
### 4o -------------------------------------------------------------------------
CoT.messages.GPT <- build_CoT_prompt_components(new_speech_rc)

uk_rc_GPT4o_CoT <- vector("list", 5)
for(i in seq_len(5)) {
  uk_rc_GPT4o_CoT[i] <- make_openai_call(
    model = "gpt-4o",
    system_content = CoT.messages.GPT$system_content,
    user_content = CoT.messages.GPT$user_content,
    few_shot_examples = CoT.messages.GPT$few_shot_examples
  )
  # Sys.sleep(60)
}

# save(uk_rc_GPT4o_CoT, file = "uk_rc_GPT4o_CoT.RData")

## E. Open-weight Models -------------------------------------------------------
### Model:
### Qwen 3 235B ----------------------------------------------------------------
# Models
all_models <- c("qwen3:235b", "mistral-large:123b-instruct-2411-q8_0")

all_speeches <- list(new_speech, new_speech_famous, new_speech_int, new_speech_rc)
# Categories:
speech_names <- c("campaign", "famous", "international", "ribbon_cutting")

# Initialize empty list to store responses
response_qwen <- vector("list", length(all_speeches))
names(response_qwen) <- speech_names

# Loop over each speech
for (i in seq_along(all_speeches)) {
  response_qwen[[i]] <- vector("list", 5)  # 각 연설당 5회 반복
  
  for (j in 1:5) {
    cat(sprintf("Processing speech %d, repetition %d\n - qwen3", i, j))
    
    final_prompt <- paste0(all_speeches[[i]], final_prompt_intro)
    CoT_prompt <- build_CoT_prompt(all_speeches[[i]])
    
    response_qwen[[i]][[j]] <- AskOllama::ask_ollama(
      messages = CoT_prompt,
      model = "qwen3:235b"
    )
  }
}

# save(response_qwen, file = "response_qwen.RData")

### Model:
### Qwen 3 235B (reasoning off) ------------------------------------------------
# Initialize empty list to store responses
response_qwen.nt <- vector("list", length(all_speeches))
names(response_qwen.nt) <- speech_names

# Loop over each speech
for (i in seq_along(all_speeches)) {
  response_qwen.nt[[i]] <- vector("list", 5)  # 각 연설당 5회 반복
  
  for (j in 1:5) {
    cat(sprintf("Processing speech %d, repetition %d\n - qwen3 /no_think ", i, j))
    
    final_prompt <- paste0(all_speeches[[i]], final_prompt_intro)
    CoT_prompt <- build_CoT_prompt_nt(all_speeches[[i]])
    
    response_qwen.nt[[i]][[j]] <- AskOllama::ask_ollama(
      messages = CoT_prompt,
      model = "qwen3:235b"
    )
  }
}

# save(response_qwen.nt, file = "response_qwen.nt.RData")

### Model:
### Mistral Large --------------------------------------------------------------
# Initialize empty list to store responses
response_mistral <- vector("list", length(all_speeches))
names(response_mistral) <- speech_names

# Loop over each speech
for (i in seq_along(all_speeches)) {
  response_mistral[[i]] <- vector("list", 5)  # 각 연설당 5회 반복
  
  for (j in 1:5) {
    cat(sprintf("Processing speech %d, repetition %d\n - mistral large", i, j))
    
    final_prompt <- paste0(all_speeches[[i]], final_prompt_intro)
    CoT_prompt <- build_CoT_prompt(all_speeches[[i]])
    
    response_mistral[[i]][[j]] <- AskOllama::ask_ollama(
      messages = CoT_prompt,
      model = "mistral-large:123b-instruct-2411-q8_0"
    )
  }
}

# save(response_mistral, file = "response_mistral.RData")

# 3) Grading (RAG) -------------------------------------------------------------

## 0. RAG ----------------------------------------------------------------------
# Loading our source python code (RAG):

## ========================================================================== ##
#                                !!! CAUTION !!!                               #
# Right now, there's a memory leak in the python file. 
# I HAVEN'T FIXED IT YET - NOR DO I PLAN ON FIXING IT IN THE NEXT COUPLE OF WEEKS.
# So, be careful! Always close your section after finishing the script,
# or try to always restart it.
# If you don't, your RStudio **WILL** crash :) 
## ========================================================================== ##

source_python("full_ensemble(2)_rag.py")

## A. Embedding Strategy: Speech and Thought
setup_advanced_rag <- function() {
  cat("🚀 Setting up Advanced PopulismRAG with ensemble models...\n")
  
  rag <- CleanFullEnsembleRAG(
    primary_model = "intfloat/e5-large-v2",                       # Primary model: e5-large
    rerank_model_name = "cross-encoder/ms-marco-MiniLM-L-12-v2",  # reranker: MS-Marco (MiniLM)
    embedding_strategy = "speech_and_thought",                    # Recommended for our case 
    use_multiple_embeddings = TRUE,                               # Enable (multimodel) ensemble
    enable_performance_tracking = TRUE                            # Research validation (dev, ;D)
  )
  
  # Set custom weights based on performance 
  # (You can adjust these based on your validation results)
  # We're not using any weights right now...
  # rag$set_model_weights(list(
  #   "primary"       = 1.5,  # BAAI model gets highest weight
  #   "multilingual"  = 1.0,  # Multilingual gets the lowest
  #   "distilroberta" = 1.3   # RoBERTa gets mid
  # ))
  
  rag$load_speeches()
  rag$build_indices()
  
  cat("✅ Advanced RAG system ready!\n")
  cat("📊 Models loaded:", length(rag$embedding_models), "\n")
  
  return(rag)
}

rag_SaT <- setup_advanced_rag()

## B. Embedding Strategy: Context Enhanced (based on Anthropic's Contextual Retrieval RAG)
setup_advanced_rag <- function() {
  cat("🚀 Setting up Advanced PopulismRAG with ensemble models...\n")
  
  rag <- CleanFullEnsembleRAG(
    primary_model = "intfloat/e5-large-v2",                       # Primary model: e5-large
    rerank_model_name = "cross-encoder/ms-marco-MiniLM-L-12-v2",  # reranker: MS-Marco (MiniLM)    
    embedding_strategy = "contextual_enhanced",                   # Recommended for our case (2)  
    use_multiple_embeddings = TRUE,                               # Enable (multimodel) ensemble
    enable_performance_tracking = TRUE                            # Research validation (dev, ;D)          
  ) 
  
  # Set custom weights based on performance 
  # (You can adjust these based on your validation results)
  # We're not using any weights right now...
  # rag$set_model_weights(list(
  #   "primary"       = 1.5,  # BAAI model gets highest weight
  #   "multilingual"  = 1.0,  # Multilingual gets the lowest
  #   "distilroberta" = 1.3   #
  # ))
  
  rag$load_speeches()
  rag$build_indices()
  
  cat("✅ Advanced RAG system ready!\n")
  cat("📊 Models loaded:", length(rag$embedding_models), "\n")
  
  return(rag)
}

rag_ContEnh <- setup_advanced_rag()

# +-----------------------------+------------------+----------------------------------------+---------------------------+
# | Model                       |  Type            | API Version                            | RAG Embedding Strat.      |
# +-----------------------------+------------------+----------------------------------------+---------------------------+
# | Proprietary Models                                                                                                  | 
# | o4-mini (high)              | reasoning (high) | o4-mini-2025-04-16                     | Speech and Thought (SaT)  |
# | o4-mini (high)              | reasoning (high) | o4-mini-2025-04-16                     | Context Enhanced (ContEnh)|
# | 4o                          | vanilla          | gpt-4o-2024-08-06                      | Speech and Thought (SaT)  |
# | 4o                          | vanilla          | gpt-4o-2024-08-06                      | Context Enhanced (ContEnh)|
# |-----------------------------+------------------+----------------------------------------+---------------------------|
# | Open-weight Models                                                                                                  | 
# | Qwen3 235B                  | reasoning MoE    | qwen3:235b                             | Speech and Thought (SaT)  |
# | Qwen3 235B                  | reasoning MoE    | qwen3:235b                             | Context Enhanced (ContEnh)|
# | Qwen3 235B (reasoning off)  | MoE              | qwen3:235b                             | Speech and Thought (SaT)  | 
# | Qwen3 235B (reasoning off)  | MoE              | qwen3:235b                             | Context Enhanced (ContEnh)|
# | Mistral Large               | vanilla          | mistral-large:123b-instruct-2411-q8_0  | Speech and Thought (SaT)  |    
# | Mistral Large               | vanilla          | mistral-large:123b-instruct-2411-q8_0  | Context Enhanced (ContEnh)|     
# +-----------------------------+------------------+----------------------------------------+---------------------------+
# Open-weight models ran on a different script (used for parallelization) 
# Check the scripts: `01 RAG OpenWeight.R` & `01 CoT OpenWeight.R`

## A. CAMPAIGN SPEECH ----------------------------------------------------------

# Setting up RAG SaT:
SaT.hybrid_speeches_all <- rag_SaT$retrieve_hybrid_speeches(
  query_text = new_speech, 
  similar_k = 1L,
  dissimilar_k = 2L,
  faiss_k = 9L, 
  fusion_method = "score_fusion"
)

SaT.formatted_hybrid <- rag_SaT$format_hybrid_training_examples(SaT.hybrid_speeches_all)

# For Open-weight Models
SaT.messages <- build_rag_prompt(new_speech, SaT.formatted_hybrid) 

# For GPT
SaT.messages.GPT <- build_rag_prompt.GPT(new_speech, # Speech we want to Code
                                         SaT.formatted_hybrid # RAG + Cross-encoder Re-rank + Rank Fusion
)


# Setting up RAG ContEnh:
ContEnh.hybrid_speeches_all <- rag_ContEnh$retrieve_hybrid_speeches(
  query_text = new_speech, 
  similar_k = 1L,
  dissimilar_k = 2L,
  faiss_k = 9L, 
  fusion_method = "score_fusion"
)

ContEnh.formatted_hybrid <- rag_ContEnh$format_hybrid_training_examples(ContEnh.hybrid_speeches_all)

# For Open-weight Models
ContEnh.messages <- build_rag_prompt(new_speech, ContEnh.formatted_hybrid)

# FOr GPT
ContEnh.messages.GPT <- build_rag_prompt.GPT(new_speech, # Speech we want to Code
                                             ContEnh.formatted_hybrid # RAG + Cross-encoder Re-rank + Rank Fusion
)


### Model:
### Qwen 3 / Qwen 3 reasoning off / Mistral Large ------------------------------

#### RAG
#### SaT RAG -------------------------------------------------------------------
uk_camp_qwen_rag_SaT <- vector("list", 5)
for (i in seq_len(5)) {
  uk_camp_qwen_rag_SaT[[i]] <- AskOllama::ask_ollama(
    messages = SaT.messages,
    model    = "qwen3:235b"
  )}

uk_camp_qwen_rag_SaT.noThought <- vector("list", 5)
for (i in seq_len(5)) {
  uk_camp_qwen_rag_SaT.noThought[[i]] <- AskOllama::ask_ollama(
    messages = build_rag_prompt_noThought(new_speech, SaT.formatted_hybrid),
    model    = "qwen3:235b"
  )}

uk_camp_mistral_rag_SaT <- vector("list", 5)
for (i in seq_len(5)) {
  uk_camp_mistral_rag_SaT[[i]] <- AskOllama::ask_ollama(
    messages = SaT.messages,
    model    = "mistral-large:123b-instruct-2411-q8_0"
  )}


#### RAG
#### ContEnh RAG ---------------------------------------------------------------
uk_camp_qwen_rag_ContEnh <- vector("list", 5)
for (i in seq_len(5)) {
  uk_camp_qwen_rag_ContEnh[[i]] <- AskOllama::ask_ollama(
    messages = ContEnh.messages,
    model    = "qwen3:235b"
  )}

uk_camp_qwen_rag_ContEnh.noThought <- vector("list", 5)
for (i in seq_len(5)) {
  uk_camp_qwen_rag_ContEnh.noThought[[i]] <- AskOllama::ask_ollama(
    messages = build_rag_prompt_noThought(new_speech, ContEnh.formatted_hybrid),
    model    = "qwen3:235b"
  )}

uk_camp_mistral_rag_ContEnh <- vector("list", 5)
for (i in seq_len(5)) {
  uk_camp_mistral_rag_ContEnh[[i]] <- AskOllama::ask_ollama(
    messages = ContEnh.messages,
    model    = "mistral-large:123b-instruct-2411-q8_0"
  )}


### Model:
### o4-mini --------------------------------------------------------------------

#### RAG
#### SaT RAG -------------------------------------------------------------------
uk_camp_GPT_rag_SaT <- vector("list", 5)
for(i in seq_len(5)) {
  uk_camp_GPT_rag_SaT[i] <- make_openai_call(model = "o4-mini",
                                             reasoning = "high",
                                             user_content = SaT.messages.GPT)
  
}

# save(uk_camp_GPT_rag_SaT, file = "uk_camp_GPT_rag_SaT.RData")

#### RAG
#### ContEnh RAG ---------------------------------------------------------------
uk_camp_GPT_rag_ContEnh <- vector("list", 5)
for(i in seq_len(5)) {
  uk_camp_GPT_rag_ContEnh[i] <- make_openai_call(model = "o4-mini",
                                                 reasoning = "high",
                                                 user_content = messages.GPT)
  
}


# save(uk_camp_GPT_rag_ContEnh, file = "uk_camp_GPT_rag_ContEnh.RData")

### Model:
### 4o -------------------------------------------------------------------------

#### RAG:
#### SaT RAG -------------------------------------------------------------------
SaT.message.GPT4o <- build_rag_prompt_components(new_speech, SaT.formatted_hybrid)

uk_camp_GPT4o_rag_SaT <- vector("list", 5)
for(i in seq_len(5)) {
  uk_camp_GPT4o_rag_SaT[i] <- make_openai_call(
    model = "gpt-4o",
    system_content = SaT.message.GPT4o$system_content,
    user_content = SaT.message.GPT4o$user_content,
    few_shot_examples = SaT.message.GPT4o$few_shot_examples
  )
  # Sys.sleep(60)
}

# save(uk_camp_GPT4o_rag_SaT, file = "uk_camp_GPT4o_rag_SaT.RData")

#### RAG:
#### ContEnh RAG ---------------------------------------------------------------
ContEnh.message.GPT4o <- build_rag_prompt_components(new_speech, ContEnh.formatted_hybrid)

uk_camp_GPT4o_rag_ContEnh <- vector("list", 5)
for(i in seq_len(5)) {
  uk_camp_GPT4o_rag_ContEnh[i] <- make_openai_call(
    model = "gpt-4o",
    system_content = ContEnh.message.GPT4o$system_content,
    user_content = ContEnh.message.GPT4o$user_content,
    few_shot_examples = ContEnh.message.GPT4o$few_shot_examples
  )
  # Sys.sleep(60)
}

# save(uk_camp_GPT4o_rag_ContEnh, file = "uk_camp_GPT4o_rag_ContEnh.RData")


## B. FAMOUS SPEECH ------------------------------------------------------------
# RAG SaT
SaT.hybrid_speeches_all.famous <- rag_SaT$retrieve_hybrid_speeches(
  query_text = new_speech_famous, 
  similar_k = 1L,
  dissimilar_k = 2L,
  faiss_k = 9L, 
  fusion_method = "score_fusion"
)

SaT.formatted_hybrid.famous <- rag_SaT$format_hybrid_training_examples(SaT.hybrid_speeches_all.famous)

# For Open Models
SaT.messages_famous <- build_rag_prompt(new_speech_famous, SaT.formatted_hybrid.famous)


# For GPT
SaT.messages.GPT_famous <- build_rag_prompt.GPT(new_speech_famous, # Speech we want to Code
                                                SaT.formatted_hybrid.famous # RAG + Cross-encoder Re-rank + Rank Fusion
)

# RAG ContEnh:
ContEnh.hybrid_speeches_all.famous <- rag_ContEnh$retrieve_hybrid_speeches(
  query_text = new_speech_famous, 
  similar_k = 1L,
  dissimilar_k = 2L,
  faiss_k = 9L, 
  fusion_method = "score_fusion"
)

ContEnh.formatted_hybrid.famous <- rag_ContEnh$format_hybrid_training_examples(ContEnh.hybrid_speeches_all.famous)

# For Open Models
ContEnh.messages_famous <- build_rag_prompt(new_speech_famous, ContEnh.formatted_hybrid.famous)


# For GPT
ContEnh.messages.GPT_famous <- build_rag_prompt.GPT(new_speech_famous, # Speech we want to Code
                                                    ContEnh.formatted_hybrid.famous # RAG + Cross-encoder Re-rank + Rank Fusion
)

### Model:
### Qwen 3 / Qwen 3 reasoning off / Mistral Large ------------------------------

#### RAG
#### SaT RAG -------------------------------------------------------------------
uk_famous_qwen_rag_SaT <- vector("list", 5)
for (i in seq_len(5)) {
  uk_famous_qwen_rag_SaT[[i]] <- AskOllama::ask_ollama(
    messages = SaT.messages_famous,
    model    = "qwen3:235b"
  )}

uk_famous_qwen_rag_SaT.noThought <- vector("list", 5)
for (i in seq_len(5)) {
  uk_famous_qwen_rag_SaT.noThought[[i]] <- AskOllama::ask_ollama(
    messages = build_rag_prompt_noThought(new_speech_famous, SaT.formatted_hybrid.famous),
    model    = "qwen3:235b"
  )}

uk_famous_mistral_rag_SaT <- vector("list", 5)
for (i in seq_len(5)) {
  uk_famous_mistral_rag_SaT[[i]] <- AskOllama::ask_ollama(
    messages = SaT.messages_famous,
    model    = "mistral-large:123b-instruct-2411-q8_0"
  )}


#### RAG:
#### ContEnh RAG ---------------------------------------------------------------
uk_famous_qwen_rag_ContEnh <- vector("list", 5)
for (i in seq_len(5)) {
  uk_famous_qwen_rag_ContEnh[[i]] <- AskOllama::ask_ollama(
    messages = ContEnh.messages_famous,
    model    = "qwen3:235b"
  )}

uk_famous_qwen_rag_ContEnh.noThought <- vector("list", 5)
for (i in seq_len(5)) {
  uk_famous_qwen_rag_ContEnh.noThought[[i]] <- AskOllama::ask_ollama(
    messages = build_rag_prompt_noThought(new_speech_famous, ContEnh.formatted_hybrid.famous),
    model    = "qwen3:235b"
  )}

uk_famous_mistral_rag_ContEnh <- vector("list", 5)
for (i in seq_len(5)) {
  uk_famous_mistral_rag_ContEnh[[i]] <- AskOllama::ask_ollama(
    messages = ContEnh.messages_famous,
    model    = "mistral-large:123b-instruct-2411-q8_0"
  )}


### Model:
### o4-mini --------------------------------------------------------------------

#### RAG:
#### SaT RAG -------------------------------------------------------------------
uk_famous_GPT_rag_SaT <- vector("list", 5)
for(i in seq_len(5)) {
  uk_famous_GPT_rag_SaT[i] <- make_openai_call(model = "o4-mini",
                                               reasoning = "high",
                                               user_content = SaT.messages.GPT_famous)
  
}

# save(uk_famous_GPT_rag_SaT, file = "uk_famous_GPT_rag_SaT.RData")

#### RAG:
#### ContEnh RAG ---------------------------------------------------------------
uk_famous_GPT_rag_ContEnh <- vector("list", 5)
for(i in seq_len(5)) {
  uk_famous_GPT_rag_ContEnh[i] <- make_openai_call(model = "o4-mini",
                                                   reasoning = "high",
                                                   user_content = ContEnh.messages.GPT_famous)
  
}

# save(uk_famous_GPT_rag_ContEnh, file = "uk_famous_GPT_rag_ContEnh.RData")

### Model:
### 4o -------------------------------------------------------------------------

#### RAG:
#### SaT RAG -------------------------------------------------------------------
SaT.message.GPT4o_famous <- build_rag_prompt_components(new_speech_famous, SaT.formatted_hybrid.famous)

uk_famous_GPT4o_rag_SaT <- vector("list", 5)
for(i in seq_len(5)) {
  uk_famous_GPT4o_rag_SaT[i] <- make_openai_call(
    model = "gpt-4o",
    system_content = SaT.message.GPT4o_famous$system_content,
    user_content = SaT.message.GPT4o_famous$user_content,
    few_shot_examples = SaT.message.GPT4o_famous$few_shot_examples
  )
  # Sys.sleep(60)
}

# save(uk_famous_GPT4o_rag_SaT, file = "uk_famous_GPT4o_rag_SaT.RData")

#### RAG:
#### ContEnh RAG ---------------------------------------------------------------
ContEnh.message.GPT4o_famous <- build_rag_prompt_components(new_speech_famous, ContEnh.formatted_hybrid.famous)

uk_famous_GPT4o_rag_ContEnh <- vector("list", 5)
for(i in seq_len(5)) {
  uk_famous_GPT4o_rag_ContEnh[i] <- make_openai_call(
    model = "gpt-4o",
    system_content = ContEnh.message.GPT4o_famous$system_content,
    user_content = ContEnh.message.GPT4o_famous$user_content,
    few_shot_examples = ContEnh.message.GPT4o_famous$few_shot_examples
  )
  # Sys.sleep(60)
}

# save(uk_famous_GPT4o_rag_ContEnh, file = "uk_famous_GPT4o_rag_ContEnh.RData")


## C. INTERNATIONAL SPEECH -----------------------------------------------------
# RAG SaT
SaT.hybrid_speeches_all.int <- rag_SaT$retrieve_hybrid_speeches(
  query_text = new_speech_int, 
  similar_k = 1L,
  dissimilar_k = 2L,
  faiss_k = 9L, 
  fusion_method = "score_fusion"
)

SaT.formatted_hybrid.int <- rag_SaT$format_hybrid_training_examples(SaT.hybrid_speeches_all.int)

# For Open Models
SaT.messages_int <- build_rag_prompt(new_speech_int, SaT.formatted_hybrid.int)

# For GPT
SaT.messages.GPT_int <- build_rag_prompt.GPT(new_speech_int, # Speech we want to Code
                                             SaT.formatted_hybrid.int # RAG + Cross-encoder Re-rank + Rank Fusion
)

# RAG ContEnh
ContEnh.hybrid_speeches_all.int <- rag_ContEnh$retrieve_hybrid_speeches(
  query_text = new_speech_int, 
  similar_k = 1L,
  dissimilar_k = 2L,
  faiss_k = 9L, 
  fusion_method = "score_fusion"
)

ContEnh.formatted_hybrid.int <- rag_ContEnh$format_hybrid_training_examples(ContEnh.hybrid_speeches_all.int)

# For Open Models
ContEnh.messages_int <- build_rag_prompt(new_speech_int, ContEnh.formatted_hybrid.int)


# For GPT
ContEnh.messages.GPT_int <- build_rag_prompt.GPT(new_speech_int, # Speech we want to Code
                                                 ContEnh.formatted_hybrid.int # RAG + Cross-encoder Re-rank + Rank Fusion
)

### Model:
### Qwen 3 / Qwen 3 reasoning off / Mistral Large ------------------------------

#### RAG
#### SaT RAG -------------------------------------------------------------------
uk_int_qwen_rag_SaT <- vector("list", 5)
for (i in seq_len(5)) {
  uk_int_qwen_rag_SaT[[i]] <- AskOllama::ask_ollama(
    messages = SaT.messages_int,
    model    = "qwen3:235b"
  )}

uk_int_qwen_rag_SaT.noThought <- vector("list", 5)
for (i in seq_len(5)) {
  uk_int_qwen_rag_SaT.noThought[[i]] <- AskOllama::ask_ollama(
    messages = build_rag_prompt_noThought(new_speech_int, SaT.formatted_hybrid.int),
    model    = "qwen3:235b"
  )}

uk_int_mistral_rag_SaT <- vector("list", 5)
for (i in seq_len(5)) {
  uk_int_mistral_rag_SaT[[i]] <- AskOllama::ask_ollama(
    messages = SaT.messages_int,
    model    = "mistral-large:123b-instruct-2411-q8_0"
  )}

#### RAG:
#### ContEnh RAG ---------------------------------------------------------------
uk_int_qwen_rag_ContEnh <- vector("list", 5)
for (i in seq_len(5)) {
  uk_int_qwen_rag_ContEnh[[i]] <- AskOllama::ask_ollama(
    messages = ContEnh.messages_int,
    model    = "qwen3:235b"
  )}

uk_int_qwen_rag_ContEnh.noThought <- vector("list", 5)
for (i in seq_len(5)) {
  uk_int_qwen_rag_ContEnh.noThought[[i]] <- AskOllama::ask_ollama(
    messages = build_rag_prompt_noThought(new_speech_int, ContEnh.formatted_hybrid.int),
    model    = "qwen3:235b"
  )}

uk_int_mistral_rag_ContEnh <- vector("list", 5)
for (i in seq_len(5)) {
  uk_int_mistral_rag_ContEnh[[i]] <- AskOllama::ask_ollama(
    messages = ContEnh.messages_int,
    model    = "mistral-large:123b-instruct-2411-q8_0"
  )}


### Model:
### o4-mini --------------------------------------------------------------------

#### RAG:
#### SaT RAG -------------------------------------------------------------------
uk_int_GPT_rag_SaT <- vector("list", 5)
for(i in seq_len(5)) {
  uk_int_GPT_rag_SaT[i] <- make_openai_call(model = "o4-mini",
                                            reasoning = "high",
                                            user_content = SaT.messages.GPT_int)
  
}

# save(uk_int_GPT_rag_SaT, file = "uk_int_GPT_rag_SaT.RData")

#### RAG:
#### ContEnh RAG ---------------------------------------------------------------
uk_int_GPT_rag_ContEnh <- vector("list", 5)
for(i in seq_len(5)) {
  uk_int_GPT_rag_ContEnh[i] <- make_openai_call(model = "o4-mini",
                                                reasoning = "high",
                                                user_content = ContEnh.messages.GPT_int)
  
}

# save(uk_int_GPT_rag_ContEnh, file = "uk_int_GPT_rag_ContEnh.RData")

### Model:
### 4o -------------------------------------------------------------------------

#### RAG: 
#### SaT RAG -------------------------------------------------------------------
SaT.message.GPT4o_int <- build_rag_prompt_components(new_speech_int, SaT.formatted_hybrid.int)

uk_int_GPT4o_rag_SaT <- vector("list", 5)
for(i in seq_len(5)) {
  uk_int_GPT4o_rag_SaT[i] <- make_openai_call(
    model = "gpt-4o",
    system_content = SaT.message.GPT4o_int$system_content,
    user_content = SaT.message.GPT4o_int$user_content,
    few_shot_examples = SaT.message.GPT4o_int$few_shot_examples
  )
  # Sys.sleep(60)
}

# save(uk_int_GPT4o_rag_SaT, file = "uk_int_GPT4o_rag_SaT.RData")

#### RAG:
#### ContEnh RAG ---------------------------------------------------------------
ContEnh.message.GPT4o_int <- build_rag_prompt_components(new_speech_int, ContEnh.formatted_hybrid.int)

uk_int_GPT4o_rag_ContEnh <- vector("list", 5)
for(i in seq_len(5)) {
  uk_int_GPT4o_rag_ContEnh[i] <- make_openai_call(
    model = "gpt-4o",
    system_content = ContEnh.message.GPT4o_int$system_content,
    user_content = ContEnh.message.GPT4o_int$user_content,
    few_shot_examples = ContEnh.message.GPT4o_int$few_shot_examples
  )
  # Sys.sleep(60)
}

# save(uk_int_GPT4o_rag_ContEnh, file = "uk_int_GPT4o_rag_ContEnh.RData")

## D. RIBBON CUTTING SPEECH ----------------------------------------------------
# RAG SaT
SaT.hybrid_speeches_all.rc <- rag_SaT$retrieve_hybrid_speeches(
  query_text = new_speech_rc, 
  similar_k = 1L,
  dissimilar_k = 2L,
  faiss_k = 9L, 
  fusion_method = "score_fusion"
)

SaT.formatted_hybrid.rc <- rag_SaT$format_hybrid_training_examples(SaT.hybrid_speeches_all.rc)

# For Open Models
SaT.messages_rc <- build_rag_prompt(new_speech_rc, SaT.formatted_hybrid.rc)

# For GPT
SaT.messages.GPT_rc <- build_rag_prompt.GPT(new_speech_rc, # Speech we want to Code
                                            SaT.formatted_hybrid.rc # RAG + Cross-encoder Re-rank + Rank Fusion
)

# RAG ContEnh
ContEnh.hybrid_speeches_all.rc <- rag_ContEnh$retrieve_hybrid_speeches(
  query_text = new_speech_rc, 
  similar_k = 1L,
  dissimilar_k = 2L,
  faiss_k = 9L, 
  fusion_method = "score_fusion"
)

ContEnh.formatted_hybrid.rc <- rag_ContEnh$format_hybrid_training_examples(ContEnh.hybrid_speeches_all.rc)

# For Open Models
ContEnh.messages_rc <- build_rag_prompt(new_speech_rc, ContEnh.formatted_hybrid.rc)

# For GPT
ContEnh.messages.GPT_rc <- build_rag_prompt.GPT(new_speech_rc, # Speech we want to Code
                                                ContEnh.formatted_hybrid.rc # RAG + Cross-encoder Re-rank + Rank Fusion
)


### Model:
### Qwen 3 / Qwen 3 reasoning off / Mistral Large ------------------------------

#### RAG:
#### SaT RAG -------------------------------------------------------------------
uk_rc_qwen_rag_SaT <- vector("list", 5)
for (i in seq_len(5)) {
  uk_rc_qwen_rag_SaT[[i]] <- AskOllama::ask_ollama(
    messages = SaT.messages_rc,
    model    = "qwen3:235b"
  )}

uk_rc_qwen_rag_SaT.noThought <- vector("list", 5)
for (i in seq_len(5)) {
  uk_rc_qwen_rag_SaT.noThought[[i]] <- AskOllama::ask_ollama(
    messages = build_rag_prompt_noThought(new_speech_rc, SaT.formatted_hybrid.rc),
    model    = "qwen3:235b"
  )}

uk_rc_mistral_rag_SaT <- vector("list", 5)
for (i in seq_len(5)) {
  uk_rc_mistral_rag_SaT[[i]] <- AskOllama::ask_ollama(
    messages = SaT.messages_rc,
    model    = "mistral-large:123b-instruct-2411-q8_0"
  )}


#### RAG:
#### ContEnh RAG ---------------------------------------------------------------
uk_rc_qwen_rag_ContEnh <- vector("list", 5)
for (i in seq_len(5)) {
  uk_rc_qwen_rag_ContEnh[[i]] <- AskOllama::ask_ollama(
    messages = ContEnh.messages_rc,
    model    = "qwen3:235b"
  )}

uk_rc_qwen_rag_ContEnh.noThought <- vector("list", 5)
for (i in seq_len(5)) {
  uk_rc_qwen_rag_ContEnh.noThought[[i]] <- AskOllama::ask_ollama(
    messages = build_rag_prompt_noThought(new_speech_rc, ContEnh.formatted_hybrid.rc),
    model    = "qwen3:235b"
  )}

uk_rc_mistral_rag_ContEnh <- vector("list", 5)
for (i in seq_len(5)) {
  uk_rc_mistral_rag_ContEnh[[i]] <- AskOllama::ask_ollama(
    messages = ContEnh.messages_rc,
    model    = "mistral-large:123b-instruct-2411-q8_0"
  )}


### Model:
### o4-mini --------------------------------------------------------------------

#### RAG:
#### SaT RAG -------------------------------------------------------------------
uk_rc_GPT_rag_SaT <- vector("list", 5)
for(i in seq_len(5)) {
  uk_rc_GPT_rag_SaT[i] <- make_openai_call(model = "o4-mini",
                                           reasoning = "high",
                                           user_content = SaT.messages.GPT_rc)
  
}

# save(uk_rc_GPT_rag_SaT, file = "uk_rc_GPT_rag_SaT.RData")

#### RAG:
#### ContEnh RAG ---------------------------------------------------------------
uk_rc_GPT_rag_ContEnh <- vector("list", 5)
for(i in seq_len(5)) {
  uk_rc_GPT_rag_ContEnh[i] <- make_openai_call(model = "o4-mini",
                                               reasoning = "high",
                                               user_content = ContEnh.messages.GPT_rc)
  
}

# save(uk_rc_GPT_rag_ContEnh, file = "uk_rc_GPT_rag_ContEnh.RData")

### Model:
### 4o -------------------------------------------------------------------------

#### RAG:
#### SaT RAG -------------------------------------------------------------------
SaT.message.GPT4o_rc <- build_rag_prompt_components(new_speech_rc, SaT.formatted_hybrid.rc)

uk_rc_GPT4o_rag_SaT <- vector("list", 5)
for(i in seq_len(5)) {
  uk_rc_GPT4o_rag_SaT[i] <- make_openai_call(
    model = "gpt-4o",
    system_content = SaT.message.GPT4o_rc$system_content,
    user_content = SaT.message.GPT4o_rc$user_content,
    few_shot_examples = SaT.message.GPT4o_rc$few_shot_examples
  )
  # Sys.sleep(60)
}

# save(uk_rc_GPT4o_rag_SaT, file = "uk_rc_GPT4o_rag_SaT.RData")

#### RAG:
#### ContEnh RAG ---------------------------------------------------------------
ContEnh.message.GPT4o_rc <- build_rag_prompt_components(new_speech_rc, ContEnh.formatted_hybrid.rc)

uk_rc_GPT4o_rag_ContEnh <- vector("list", 5)
for(i in seq_len(5)) {
  uk_rc_GPT4o_rag_ContEnh[i] <- make_openai_call(
    model = "gpt-4o",
    system_content = ContEnh.message.GPT4o_rc$system_content,
    user_content = ContEnh.message.GPT4o_rc$user_content,
    few_shot_examples = ContEnh.message.GPT4o_rc$few_shot_examples
  )
  # Sys.sleep(60)
}

# save(uk_rc_GPT4o_rag_ContEnh, file = "uk_rc_GPT4o_rag_ContEnh.RData")


