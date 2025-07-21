# Global Populism Database (GPD) – Multi-Model RAG Replication

This repository replicates Team Populism's Global Populism Database (GPD) holistic grading method using a multi-model Retrieval-Augmented Generation (RAG) system. We reproduce the original holistic-grading training process—complete with theoretical primers, detailed rubric, and anchor speeches—and implement it with ensemble embedding models, cross-encoder re-ranking, and score fusion techniques to address systematic bias issues common in AI-based political discourse analysis.

---

## What This Project Does

1. **Multi-Model Embedding Ensemble**: Uses 3 complementary embedding models (primary: intfloat/e5-large-v2, multilingual: paraphrase-multilingual-MiniLM-L12-v2, distilroberta: all-distilroberta-v1) to capture different semantic dimensions of political rhetoric
2. **FAISS Indexing**: Stores embeddings in efficient cosine-similarity indices for fast retrieval across small training sets
3. **Cross-Encoder Re-ranking**: Distinguishes rhetorical structure patterns from topical similarity using ms-marco-MiniLM-L-12-v2
4. **Score Fusion**: Combines rankings from multiple models to reduce individual embedding bias - critical for small training datasets
5. **Hybrid Retrieval**: Retrieves both similar AND dissimilar training examples for calibration, addressing systematic upward bias in populism scoring
6. **LLM Inference**: Prompts local Ollama-hosted LLMs with comprehensive training context to produce:
   * 0.0–2.0 populism scores (rounded down to tenths)
   * Supporting quotes from 6 populist and 6 pluralist categories  
   * Detailed holistic reasoning anchored to retrieved examples

---

## Key Features

- **Ensemble Approach**: Multiple embedding models compensate for small training set (n=9) and capture different aspects of populist rhetoric
- **Contrastive Retrieval**: Adapts established hard negative sampling techniques to provide both positive and negative calibration anchors
- **Flexible Fusion Methods**: Choose from `score_fusion`, `rank_fusion`, or `weighted_fusion` to combine model outputs
- **Context-Enhanced Embeddings**: Incorporates expert analytical reasoning alongside speech content for better pattern matching
- **Systematic Bias Mitigation**: Addresses common upward bias in AI populism scoring through dissimilar example retrieval

---

## Repository Contents

| File | Role |
|------|------|
| `full_ensemble(2)_rag.py` | Python RAG system with multi-model ensemble and cross-encoder re-ranking |
| `01 main.R` | R driver script integrating RAG with Ollama server and AskOllama package |
| `p_prompts.R` | Complete Chain-of-Thought prompt based on human populism training |
| `Speech_01.md` – `Speech_09.md` | Expert-coded training speeches (scores: 0.0, 0.0, 0.3, 0.5, 0.9, 1.0, 1.5, 1.7, 2.0) |

---

## Quick Start

### Prerequisites
- R with `reticulate` package
- Python environment with required packages (handled via reticulate)
- Local Ollama server with language models (tested with qwen2.5:7b, qwen2.5:14b)
- AskOllama R package: `devtools::install_github("ertamaki/AskOllama")`

### Usage
1. **Clone** this repository to your local machine
2. **Set up Ollama** server with your preferred model
3. **Open** `01 main.R` in R
4. **Configure your target speech**:
   ```r
   new_speech <- "Your speech text here..."
   ```
5. **Run the script** – it will:
   - Initialize the multi-model RAG system
   - Build FAISS indices for all embedding models
   - Retrieve similar and dissimilar training examples
   - Generate comprehensive populism analysis via your local LLM

### Configuration Options

```r
# A. Embedding Strategy: Speech and Thought
setup_advanced_rag <- function() {
  rag <- CleanFullEnsembleRAG(
    primary_model = "intfloat/e5-large-v2",                       
    rerank_model_name = "cross-encoder/ms-marco-MiniLM-L-12-v2",  
    embedding_strategy = "speech_and_thought",                    # Options: "speech_and_thought", "contextual_enhanced" 
    use_multiple_embeddings = TRUE,                               
    enable_performance_tracking = TRUE                            
  )
  
  rag$load_speeches()
  rag$build_indices()
  return(rag)
}

# Hybrid retrieval configuration
hybrid_speeches <- rag$retrieve_hybrid_speeches(
  query_text = new_speech, 
  similar_k = 1L,                     # Number of similar examples for guidance
  dissimilar_k = 2L,                  # Number of dissimilar examples for calibration
  faiss_k = 9L,                       # Search space (all 9 training speeches)
  fusion_method = "score_fusion"      # Options: "score_fusion", "rank_fusion", "weighted_fusion"
)
```

---

## Technical Architecture

### Multi-Model Pipeline
- **Primary Model**: intfloat/e5-large-v2 (strong semantic similarity performance)
- **Multilingual Model**: paraphrase-multilingual-MiniLM-L12-v2 (cross-linguistic patterns)
- **DistilRoBERTa Model**: all-distilroberta-v1 (alternative semantic dimensions)
- **Cross-Encoder**: ms-marco-MiniLM-L-12-v2 (contextual relevance scoring)

### Embedding Strategies
- **Speech and Thought**: Combines speech content with expert analytical reasoning
- **Contextual Enhanced**: Adds (to speech_and_thought) theoretical populism context before embedding (inspired by Anthropic's Contextual Retrieval)

### Score Fusion Methods
- **Score Fusion**: Weighted combination of similarity scores from all models
- **Rank Fusion**: Reciprocal rank fusion (RRF) with model-specific weights
- **Weighted Fusion**: Hybrid approach combining rank positions and similarity scores

### Addressing Key Challenges
This system specifically addresses several challenges in AI-based populism measurement:
- **Limited Training Data**: Only 9 expert-coded speeches available
- **Skewed Score Distribution**: Original training heavily weighted toward high-populism examples (1.0-2.0)
- **Systematic Upward Bias**: LLMs tend to inflate populism scores for genuinely low-populism speeches
- **Topic vs. Rhetorical Confusion**: Standard retrieval matches topics rather than rhetorical patterns

---

## Performance Notes

- **Training Set**: 9 expert-coded speeches with holistic grading scores
- **Score Range**: 0.0-2.0 (rounded down to tenths), with anchor points at 0.0, 1.0, and 2.0
- **Validation**: Designed for comparison against human expert coding using the same holistic grading framework
- **Computational Requirements**: Moderate - embedding models run efficiently on modern hardware

---

## License
MIT License

---

## Contact
Eduardo Tamaki · eduardo@tamaki.ai  
