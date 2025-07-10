# Global Populism Database (GPD) – Multi-Model RAG Replication

This repository recreates Team Populism's Global Populism Database (GPD) using a state-of-the-art multi-model Retrieval-Augmented Generation (RAG) system. We fully reproduce the original holistic-grading training process—complete with theoretical primers, detailed rubric, and anchor speeches—and enhance it with an ensemble embedding approach, cross-encoder re-ranking, and score fusion techniques.

---

## What This Project Does

1. **Multi-Model Embedding**: Uses an ensemble of 3 semantic models (primary: BAAI/bge-base-en-v1.5, multilingual: paraphrase-multilingual-MiniLM-L12-v2, distilroberta: all-distilroberta-v1) to capture diverse rhetorical dimensions
2. **FAISS Indexing**: Stores embeddings in efficient cosine-similarity indices for fast retrieval
3. **Cross-Encoder Re-ranking**: Prioritizes rhetorical structure similarity over mere topic similarity using a dedicated re-ranking model
4. **Score Fusion**: Combines rankings from multiple models to reduce individual embedding bias and improve retrieval quality
5. **LLM Inference**: Prompts local Ollama-hosted LLMs with comprehensive training context to produce:
   * 0.0–2.0 populism scores (rounded down to tenths)
   * Supporting quotes from 6 populist and 6 pluralist categories  
   * Detailed holistic reasoning anchored to retrieved examples

---

## Key Innovations

- **Ensemble Approach**: Multiple embedding models capture different semantic aspects of political rhetoric
- **Rhetorical vs Topic Similarity**: Cross-encoder distinguishes between speeches that share rhetorical patterns vs those that merely discuss similar topics
- **Score Fusion Methods**: Choose from `score_fusion`, `rank_fusion`, or `weighted_fusion` to combine model outputs
- **Example-Grounded Scoring**: Retrieved training examples ensure consistent, comparative scoring across speeches

---

## Repository Contents

| File | Role |
|------|------|
| `full_ensemble(2)_rag.py` | Advanced Python RAG system with multi-model ensemble and cross-encoder re-ranking |
| `RAG_GPD.R` | R driver script with complete Chain-of-Thought prompt and Ollama integration |
| `Speech_01.md` – `Speech_09.md` | Expert-coded training speeches with full analysis and scores |
| `rubrics-definition.yaml` | Structured YAML version of the populism rubric |

---

## Quick Start

### Prerequisites
- R with `reticulate` and `devtools` packages
- Python environment with required packages (automatically handled)
- Local Ollama server with language models (e.g., `qwen3:235b`)

### Usage
1. **Clone** this repository to your local machine
2. **Open R** and navigate to the project directory
3. **Open** `RAG_GPD.R` in your preferred IDE
4. **Add your target speech** to the `new_speech` variable:
   ```r
   new_speech <- "Your speech text here..."
   ```
5. Run the script – it will:
- Initialize the multi-model RAG system
- Build FAISS indices for all embedding models
- Retrieve and re-rank similar training examples
- Generate a comprehensive populism analysis

### Configuration Options
```r
# Adjust retrieval parameters
similar_speeches_all <- rag$retrieve_similar_speeches(
  query_text = new_speech, 
  top_k = 3L,                          # Number of examples to retrieve
  faiss_k = 9L,                        # Search space (max 9 training speeches)
  fusion_method = "score_fusion"       # Options: "score_fusion", "rank_fusion", "weighted_fusion"
)
```

### Technical Details
Multi-Model Architecture: 
- Primary Model: BAAI/bge-base-en-v1.5 (optimized for political texts)
- Multilingual Model: paraphrase-multilingual-MiniLM-L12-v2 (rhetorical patterns)
- DistilRoBERTa Model: all-distilroberta-v1 (semantic understanding)
- Cross-Encoder: ms-marco-MiniLM-L-12-v2 (rhetorical similarity ranking)

### Embedding Strategy
The system embeds both speech content and expert reasoning (speech_and_thought strategy) to capture:
- Actual rhetorical content
- Scoring rationale

### Score Fusion Methods
- Score Fusion: Weighted combination of similarity scores
- Rank Fusion: Reciprocal rank fusion with model weights
- Weighted Fusion: Hybrid approach combining rank and score components

### Validation & Performance
The system is designed for research validation with:
- Performance tracking and diagnostics
- Comparison against human expert scores (n=9 training speeches)
- Ablation studies across different fusion methods (TBD)
- Cross-validation capabilities (TBD)


### License
MIT License

### Contact
Eduardo Tamaki · eduardo@tamaki.ai
