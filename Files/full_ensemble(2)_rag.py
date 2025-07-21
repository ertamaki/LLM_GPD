"""
PopulismRAG: Multi-Model Ensemble Retrieval-Augmented Generation for Holistic Grading
======================================================================================

RAG implementation for computational analysis of populist rhetoric using ensemble 
embedding models, cross-encoder re-ranking, and score fusion techniques.

MAIN ELEMENTS: 
----------------------------
1. **Multi-Model Ensemble Architecture**: Combines three complementary embedding models to capture
   different semantic dimensions of political rhetoric:
   - Primary: intfloat/e5-large-v2
   - Multilingual: Handles cross-linguistic populist patterns 
   - DistilRoBERTa: Captures syntactic and structural linguistic features

2. **Cross-Encoder Re-ranking**: Implements a two-stage retrieval process where initial candidates
   from vector similarity are re-evaluated by a cross-encoder that can assess contextual relationships
   between query and candidate speeches simultaneously. This is critical for distinguishing
   "elite athletes" from "corrupt elites" - semantically similar but rhetorically distinct.

3. **Score Fusion Strategy**: Rather than simple averaging, employs ranking-based fusion to reduce
   model bias and ensure robust retrieval across different rhetorical patterns. Compensates for
   the limited training data (n=9) inherent in expert-coded populism datasets.

4. **Hybrid Retrieval Framework**: Retrieves both similar and dissimilar examples to provide
   contrastive learning signals, following established principles in human expert training for
   the Holistic Grading method.

TECHNICAL IMPLEMENTATION:
------------------------
- **Incremental FAISS Indexing**: Memory-efficient vector storage and retrieval
- **Embedding Strategy Flexibility**: Supports both "speech_and_thought" and "contextual_enhanced"
  approaches based on Anthropic's contextual retrieval patterns
- **Performance Monitoring**: Built-in tracking for model performance and memory usage
- **Robust Error Handling**: Graceful degradation when individual models fail

----------------
Author: Eduardo Ryo Tamaki
Contact: eduardo@tamaki.ai

External packages (pip install):
- sentence-transformers (SentenceTransformer, CrossEncoder)
- faiss (or faiss-cpu for CPU-only installation)
- numpy
- psutil (memory monitoring)

Python standard library:
- re, json, glob, typing, warnings, gc, os

Last Updated: July 2025
======================================================================================
"""

import re, json
from glob import glob
import numpy as np
import faiss
from sentence_transformers import SentenceTransformer, CrossEncoder
from typing import Dict, List, Optional, Tuple, Union
import warnings
import gc
import psutil
import os


class CleanFullEnsembleRAG:
    """
    Complete RAG with all 5 models using incremental FAISS index building
    """

    def __init__(
        self,
        primary_model: str = "BAAI/bge-base-en-v1.5",
        rerank_model_name: Optional[str] = None,
        embedding_strategy: str = "speech_and_thought",
        use_multiple_embeddings: bool = True,
        enable_performance_tracking: bool = True
    ):
        print("🚀 Initializing Clean Full Ensemble RAG System...")
        
        # Core configuration
        self.embedding_strategy = embedding_strategy
        self.enable_performance_tracking = enable_performance_tracking
        self.performance_logs = [] if enable_performance_tracking else None
        
        # Memory monitoring
        self.process = psutil.Process(os.getpid())
        
        # Initialize primary model
        print(f"📊 Loading primary model: {primary_model}")
        self.primary_model = SentenceTransformer(primary_model, trust_remote_code=True)
        self._log_memory("After primary model")
        
        # Initialize embedding models ensemble
        self.embedding_models = {"primary": self.primary_model}
        self.model_weights = {"primary": 1.5}  # Give primary model higher weight
        
        if use_multiple_embeddings:
            self._initialize_full_ensemble()
        
        # Initialize cross-encoder reranker
        self.reranker = None
        if rerank_model_name:
            try:
                print(f"🔄 Loading reranker: {rerank_model_name}")
                self.reranker = CrossEncoder(rerank_model_name, trust_remote_code=True)
                print("  ✓ Reranker loaded successfully")
                self._log_memory("After reranker")
            except Exception as e:
                print(f"  ✗ Reranker failed to load: {e}")
        
        # Data storage
        self.speeches: List[Dict] = []
        self.indices: Dict[str, faiss.Index] = {}
        
        print(f"✅ Initialized with {len(self.embedding_models)} models, strategy: {embedding_strategy}")

    def _log_memory(self, stage: str):
        """Log current memory usage"""
        memory_info = self.process.memory_info()
        memory_mb = memory_info.rss / 1024 / 1024
        print(f"  💾 Memory usage {stage}: {memory_mb:.1f} MB")

    def _smart_cleanup(self):
        """Smart memory cleanup with error handling"""
        try:
            gc.collect()
            gc.collect()
        except Exception as e:
            print(f"  ⚠️  Cleanup warning: {e}")

    def _initialize_full_ensemble(self):
        """Initialize all 4 additional models for complete ensemble"""
        print("🔧 Loading FULL ensemble models...")
        
        # All ensemble models - load one by one with error handling
        ensemble_models = [
            # ("mpnet", "sentence-transformers/all-mpnet-base-v2"),
            ("multilingual", "sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2"),
            #("qwen3", "Qwen/Qwen3-Embedding-0.6B"),
            ("distilroberta", "sentence-transformers/all-distilroberta-v1"),
        ]
        
        for name, model_path in ensemble_models:
            try:
                print(f"  🔨 Loading {name}...")
                self._log_memory(f"Before {name}")
                
                model = SentenceTransformer(model_path)
                
                # Test the model with a simple encoding to catch issues early
                test_text = "This is a test sentence."
                test_emb = model.encode(test_text, normalize_embeddings=True)
                del test_emb
                
                self.embedding_models[name] = model
                self.model_weights[name] = 1.0
                
                self._log_memory(f"After {name}")
                print(f"  ✓ Loaded and tested {name}")
                
                # Cleanup after each model
                self._smart_cleanup()
                
            except Exception as e:
                print(f"  ✗ Failed to load {name}: {e}")
                print(f"  🔄 Continuing with other models...")
                continue
        
        print(f"🎯 Full ensemble ready with {len(self.embedding_models)} models")
        print(f"📊 Models loaded: {list(self.embedding_models.keys())}")

    def load_speeches(self, pattern: str = "Speech*.md") -> None:
        """Load and parse speech files"""
        print(f"📁 Loading speeches from pattern: {pattern}")
        
        speech_files = glob(pattern)
        if not speech_files:
            raise FileNotFoundError(f"No files found matching pattern: {pattern}")
        
        for fname in speech_files:
            with open(fname, encoding="utf-8") as f:
                content = f.read()

            # Extract metadata
            yaml_match = re.search(r"(?s)^---\n(.*?)\n---", content)
            metadata = {}
            if yaml_match:
                for line in yaml_match.group(1).split("\n"):
                    if ":" in line:
                        k, v = line.split(":", 1)
                        metadata[k.strip()] = v.strip().strip('"')

            speech_data = {
                "file": fname,
                "metadata": metadata,
                "full_text": self._extract_section(content, "## Full Text"),
                "thought_process": self._extract_section(content, "### Thought Process"),
                "grade": self._extract_grade(content),
                "rubric_evidence": self._extract_rubric_evidence(content),
                "text_length": len(self._extract_section(content, "## Full Text")),
                "analysis_length": len(self._extract_section(content, "### Thought Process")),
                "evidence_count": len(self._extract_rubric_evidence(content))
            }
            
            self.speeches.append(speech_data)
        
        print(f"✅ Loaded {len(self.speeches)} speeches")
        self._log_memory("After loading speeches")
        
        if self.speeches:
            avg_score = np.mean([s.get("grade", 0) for s in self.speeches if s.get("grade")])
            print(f"📈 Average populism score: {avg_score:.2f}")

    def _extract_section(self, content: str, header: str) -> str:
        """Extract content section"""
        pattern = rf"{re.escape(header)}\n(.*?)(?=\n##|\n###|\Z)"
        match = re.search(pattern, content, re.DOTALL)
        return match.group(1).strip() if match else ""

    def _extract_grade(self, content: str) -> Optional[float]:
        """Extract numerical grade"""
        patterns = [
            r"Score:\s*(\d+\.?\d*)",
            r"Grade:\s*(\d+\.?\d*)", 
            r"Rating:\s*(\d+\.?\d*)"
        ]
        for pattern in patterns:
            match = re.search(pattern, content)
            if match:
                return float(match.group(1))
        return None

    def _extract_rubric_evidence(self, content: str) -> Dict[str, str]:
        """Extract rubric evidence"""
        evidence = {}
        pattern = r"#### Rubric \d+: (.*?)\n.*?\*\*Evidence\*\*:\n> (.*?)(?=\n####|\n###|\Z)"
        matches = re.findall(pattern, content, re.DOTALL)
        for rubric_name, quotes in matches:
            evidence[rubric_name.strip()] = quotes.strip()
        return evidence
    
    def _get_populism_summary(self, speech: Dict) -> str:
        """Generate theoretically-grounded populism summary using anchor descriptions"""
        grade = speech.get('grade', 0)
        
        if grade < 0.5:  # Use 0.0 description
            return "lacks the required moral opposition between people and elites - may praise 'the people' OR criticize elites, but doesn't pit them against each other as moral enemies"
        
        elif grade < 1.0:  # Use 0.5 description
            return "establishes some moral opposition between people and elites, but the contrast is moderate or inconsistent - both pro-people and anti-elite elements are present and somewhat connected, but the moral binary isn't fully developed"
        
        elif grade < 1.5:  # Use 1.0 description
            return "shows clear moral binary where good people are directly opposed to corrupt/evil elites - both elements are strongly present and explicitly connected in opposition, with the conflict framed as fundamental rather than just political disagreement"
        
        else:  # Use 2.0 description (1.5+)
            return "displays maximum Manichaean intensity with rigid and absolute moral contrast - a cosmic battle between pure good (people) and pure evil (elites) with no middle ground possible"


    def build_indices(self) -> None:
        """
        🔧 INCREMENTAL: Build FAISS indices one speech at a time for all models
        """
        print(f"🏗️  Building indices for FULL ENSEMBLE incrementally")
        print(f"     Strategy: {self.embedding_strategy}")
        print(f"     Models to process: {list(self.embedding_models.keys())}")
        
        if not self.speeches:
            raise ValueError("No speeches loaded. Call load_speeches() first.")
        
        self._log_memory("Before index building")
        
        successful_indices = 0
        total_models = len(self.embedding_models)
        failed_models = []
        
        # Build index for each model with incremental FAISS building
        for i, (model_name, model) in enumerate(self.embedding_models.items()):
            print(f"\n  🔨 Building index for {model_name} ({i+1}/{total_models})...")
            self._log_memory(f"Before {model_name} index")
            
            try:
                # Get the first embedding to determine dimensions
                first_speech = self.speeches[0]
                embedding_text = self._create_embedding_text(first_speech, model_name)
                
                print(f"    🧪 Testing {model_name} with first speech...")
                first_emb = model.encode(embedding_text, normalize_embeddings=True)
                embedding_dim = first_emb.shape[0]
                
                print(f"    📐 Embedding dimension: {embedding_dim}")
                
                # Create empty FAISS index
                index = faiss.IndexFlatIP(embedding_dim)
                
                # Add first embedding
                index.add(np.array([first_emb], dtype=np.float32))
                print(f"    📊 Added speech 1/{len(self.speeches)}")
                
                # Add remaining embeddings one by one with robust error handling
                for j, speech in enumerate(self.speeches[1:], 2):
                    try:
                        embedding_text = self._create_embedding_text(speech, model_name)
                        emb = model.encode(embedding_text, normalize_embeddings=True)
                        
                        # Verify embedding shape matches
                        if emb.shape[0] != embedding_dim:
                            print(f"      ⚠️  Dimension mismatch for speech {j}: expected {embedding_dim}, got {emb.shape[0]}")
                            continue
                        
                        # Add single embedding to index
                        index.add(np.array([emb], dtype=np.float32))
                        print(f"    📊 Added speech {j}/{len(self.speeches)}")
                        
                        # Cleanup after each embedding
                        del emb
                        
                        # Periodic cleanup
                        if j % 3 == 0:  # Every 3 speeches
                            self._smart_cleanup()
                        
                    except Exception as e:
                        print(f"      ⚠️  Failed to embed speech {j} with {model_name}: {e}")
                        # Try fallback to primary model
                        try:
                            fallback_text = f"search_document: {speech['full_text']}"
                            emb = self.primary_model.encode(fallback_text, normalize_embeddings=True)
                            
                            # Check if fallback dimension matches (might not for different models)
                            if emb.shape[0] == embedding_dim:
                                index.add(np.array([emb], dtype=np.float32))
                                print(f"    📊 Added speech {j}/{len(self.speeches)} (fallback)")
                            else:
                                print(f"      ⚠️  Fallback dimension mismatch, skipping speech {j}")
                            
                            del emb
                        except Exception as e2:
                            print(f"      ❌ Fallback also failed for speech {j}: {e2}")
                            continue
                
                # Verify index has correct number of entries
                if index.ntotal < len(self.speeches):
                    print(f"    ⚠️  Index has {index.ntotal}/{len(self.speeches)} speeches (some failed)")
                else:
                    print(f"    ✅ Index complete with {index.ntotal} speeches")
                
                # Store the completed index
                self.indices[model_name] = index
                successful_indices += 1
                
                print(f"    ✅ Index built successfully for {model_name}")
                self._log_memory(f"After {model_name} index")
                
                # Cleanup after each model
                del first_emb
                self._smart_cleanup()
                
                print(f"    🧹 Cleanup completed for {model_name}")
                self._log_memory(f"After cleanup {model_name}")
                
            except Exception as e:
                print(f"    ❌ CRITICAL FAILURE building index for {model_name}: {e}")
                self._log_memory(f"After failure {model_name}")
                failed_models.append(model_name)
                
                # Emergency cleanup
                self._smart_cleanup()
                print(f"    🔄 Continuing with remaining models...")
                continue
        
        # Final status report
        if successful_indices == 0:
            raise RuntimeError("Failed to build any indices!")
        else:
            print(f"\n🎯 Built {successful_indices}/{total_models} indices successfully!")
            print(f"📊 Working models: {list(self.indices.keys())}")
            if failed_models:
                print(f"⚠️  Failed models: {failed_models}")
            self._log_memory("Final memory state")

    def _create_embedding_text(self, speech: Dict, model_name: str = "primary") -> str:
        """Create embedding text based on strategy"""
        
        if self.embedding_strategy == "speech_only":
            return f"search_document: {speech['full_text']}"
            
        elif self.embedding_strategy == "speech_and_thought":
            return f"""search_document: 
    SPEECH CONTENT:
    {speech['full_text']}
    
    RHETORICAL ANALYSIS:
    {speech['thought_process']}
    
    POPULISM SCORE: {speech.get('grade', 'Unknown')}"""
            
        elif self.embedding_strategy == "thought_only":
            return f"search_document: {speech['thought_process']}"
            
        elif self.embedding_strategy == "contextual_enhanced":
            return f"""CONTEXT: POPULISM ANALYSIS: This speech scored {speech.get('grade', 'Unknown')} on a 0-2 scale because it {self._get_populism_summary(speech)} rhetoric patterns.
    SPEECH CONTENT:
    {speech['full_text']}
    DETAILED ANALYSIS:
    {speech['thought_process']}"""
        
        else:
            raise ValueError(f"Unknown embedding strategy: {self.embedding_strategy}")

    def retrieve_similar_speeches(
    self,
    query_text: str,
    query_thought_process: Optional[str] = None,
    top_k: int = 3,
    faiss_k: Optional[int] = None,
    fusion_method: str = "rank_fusion",
    return_diagnostics: bool = False
    ) -> Union[List[Dict], Tuple[List[Dict], Dict]]:
        """Retrieve similar speeches using the full ensemble"""
        
        if not self.indices:
            raise RuntimeError("Indices not built. Call build_indices() first.")
    
        if faiss_k is None or faiss_k < top_k:
            faiss_k = max(top_k, 10)
    
        # Handle single model case
        if len(self.indices) == 1:
            available_model = list(self.indices.keys())[0]
            results = self._retrieve_single_model(
                available_model, query_text, query_thought_process, top_k, faiss_k
            )
            if return_diagnostics:
                return results, {"method": "single_model", "models_used": [available_model]}
            return results
    
        # Multi-model retrieval
        all_model_results = {}
        successful_models = []
        
        for model_name in self.indices.keys():
            if model_name not in self.embedding_models:
                continue
                
            try:
                model = self.embedding_models[model_name]
                query_emb_text = self._create_query_embedding_text(
                    query_text, query_thought_process, model_name
                )
                query_emb = model.encode(query_emb_text, normalize_embeddings=True)
                D, I = self.indices[model_name].search(np.array([query_emb]), faiss_k)
                
                model_candidates = []
                for idx, cos_sim in zip(I[0], D[0]):
                    if idx < len(self.speeches):
                        speech = self.speeches[idx].copy()
                        speech["similarity_score"] = float(cos_sim)
                        speech["speech_idx"] = idx
                        speech["retrieval_model"] = model_name
                        model_candidates.append(speech)
                
                all_model_results[model_name] = model_candidates
                successful_models.append(model_name)
                
            except Exception as e:
                print(f"⚠️  Model {model_name} failed during retrieval: {e}")
                continue
    
        if not successful_models:
            raise RuntimeError("All models failed during retrieval")
    
        # Apply selected fusion method
        if fusion_method == "rank_fusion":
            fused_candidates = self._rank_fusion(all_model_results)
        elif fusion_method == "score_fusion":
            fused_candidates = self._score_fusion(all_model_results)
        elif fusion_method == "weighted_fusion":
            fused_candidates = self._weighted_fusion(all_model_results)
        else:
            raise ValueError(f"Unknown fusion method: {fusion_method}")
    
        # Apply cross-encoder reranking
        if self.reranker and len(fused_candidates) > 1:
            fused_candidates = self._apply_cross_encoder_rerank(query_text, fused_candidates)
    
        final_results = fused_candidates[:top_k]
        
        if return_diagnostics:
            diagnostics = {
                "method": fusion_method,
                "models_used": successful_models,
                "embedding_strategy": self.embedding_strategy,
                "successful_indices": len(successful_models),
                "total_models_attempted": len(self.embedding_models)
            }
            return final_results, diagnostics
    
        return final_results

    def retrieve_dissimilar_speeches(
    self,
    query_text: str,
    query_thought_process: Optional[str] = None,
    top_k: int = 2,
    faiss_k: Optional[int] = None,
    fusion_method: str = "score_fusion",
    exclude_similar_k: int = 0  # Number of most similar speeches to exclude
    ) -> List[Dict]:
        """Retrieve DISSIMILAR speeches by inverting similarity scores"""
        
        if not self.indices:
            raise RuntimeError("Indices not built. Call build_indices() first.")
        
        if faiss_k is None:
            faiss_k = len(self.speeches)  # Search all speeches for dissimilar
        
        all_model_results = {}
        successful_models = []
        
        for model_name in self.indices.keys():
            if model_name not in self.embedding_models:
                continue
                
            try:
                model = self.embedding_models[model_name]
                query_emb_text = self._create_query_embedding_text(
                    query_text, query_thought_process, model_name
                )
                query_emb = model.encode(query_emb_text, normalize_embeddings=True)
                D, I = self.indices[model_name].search(np.array([query_emb]), faiss_k)
                
                model_candidates = []
                for idx, cos_sim in zip(I[0], D[0]):
                    if idx < len(self.speeches):
                        speech = self.speeches[idx].copy()
                        # INVERT the similarity score to get dissimilarity
                        speech["dissimilarity_score"] = 1.0 - float(cos_sim)  
                        speech["original_similarity"] = float(cos_sim)
                        speech["speech_idx"] = idx
                        speech["retrieval_model"] = model_name
                        model_candidates.append(speech)
                
                # Sort by original similarity (to exclude most similar)
                model_candidates.sort(key=lambda x: x["original_similarity"], reverse=True)
                
                # Exclude the most similar speeches
                if exclude_similar_k > 0:
                    model_candidates = model_candidates[exclude_similar_k:]
                    print(f"  🚫 Excluded top {exclude_similar_k} similar speeches for {model_name}")
                
                # Now sort by dissimilarity (highest dissimilarity first)
                model_candidates.sort(key=lambda x: x["dissimilarity_score"], reverse=True)
                
                all_model_results[model_name] = model_candidates
                successful_models.append(model_name)
                
            except Exception as e:
                print(f"⚠️  Model {model_name} failed during dissimilar retrieval: {e}")
                continue
    
        if not successful_models:
            raise RuntimeError("All models failed during dissimilar retrieval")
    
        # Apply fusion to dissimilar results
        fused_candidates = self._score_fusion_dissimilar(all_model_results)
        
        # Apply cross-encoder reranking BUT don't reorder - just add scores for analysis
        if self.reranker and len(fused_candidates) > 1:
            try:
                pairs = [(query_text, speech["full_text"]) for speech in fused_candidates]
                rerank_scores = self.reranker.predict(pairs, convert_to_numpy=True)
                
                for speech, rerank_score in zip(fused_candidates, rerank_scores):
                    speech["rerank_score"] = float(rerank_score)
                
                # DON'T reorder - keep the dissimilarity order!
                print("  📊 Added rerank scores without reordering dissimilar speeches")
                
            except Exception as e:
                print(f"  ⚠️  Reranking failed for dissimilar: {e}")
                for speech in fused_candidates:
                    speech["rerank_score"] = None
    
        return fused_candidates[:top_k]
        
        
    def retrieve_hybrid_speeches(
    self,
    query_text: str,
    query_thought_process: Optional[str] = None,
    similar_k: int = 2,
    dissimilar_k: int = 2,
    faiss_k: Optional[int] = None,
    fusion_method: str = "score_fusion"
) -> Dict[str, List[Dict]]:
        """Retrieve both similar and dissimilar speeches for hybrid RAG"""
        
        print(f"🔄 Hybrid retrieval: {similar_k} similar + {dissimilar_k} dissimilar speeches...")
        
        # Get similar speeches first
        similar_speeches = self.retrieve_similar_speeches(
            query_text=query_text,
            query_thought_process=query_thought_process,
            top_k=similar_k,
            faiss_k=faiss_k,
            fusion_method=fusion_method
        )
        
        # Get dissimilar speeches, excluding the most similar ones
        dissimilar_speeches = self.retrieve_dissimilar_speeches(
            query_text=query_text,
            query_thought_process=query_thought_process,
            top_k=dissimilar_k,
            faiss_k=faiss_k,
            fusion_method=fusion_method,
            exclude_similar_k=similar_k  # Exclude the similar ones we just retrieved
        )
        
        print(f"✅ Retrieved {len(similar_speeches)} similar, {len(dissimilar_speeches)} dissimilar")
        
        # Optional: Add some diagnostics
        if similar_speeches:
            sim_scores = [s.get('grade', 'Unknown') for s in similar_speeches]
            print(f"📊 Similar speech scores: {sim_scores}")
        
        if dissimilar_speeches:
            dissim_scores = [s.get('grade', 'Unknown') for s in dissimilar_speeches]
            print(f"📊 Dissimilar speech scores: {dissim_scores}")
        
        return {
            "similar": similar_speeches,
            "dissimilar": dissimilar_speeches
        }
    
    def _create_query_embedding_text(self, query_text: str, query_thought_process: Optional[str], model_name: str = "primary") -> str:
        """Create query embedding text"""
        if self.embedding_strategy == "speech_only":
            return f"search_query: {query_text}"
        elif self.embedding_strategy == "speech_and_thought":
            if query_thought_process:
                return f"""search_query:
    SPEECH CONTENT:
    {query_text}
    
    RHETORICAL ANALYSIS:
    {query_thought_process}
    
    POPULISM SCORE: [To be determined]"""
            else:
                return f"""search_query:
    SPEECH CONTENT:
    {query_text}
    
    RHETORICAL ANALYSIS:
    [Analyzing for populist rhetoric patterns, us-vs-them framing, and anti-elite sentiment]
    
    POPULISM SCORE: [To be determined]"""
        elif self.embedding_strategy == "thought_only":
            return f"search_query: {query_thought_process or query_text}"
        elif self.embedding_strategy == "contextual_enhanced":
            return f"""CONTEXT: POPULISM ANALYSIS: This query speech will be analyzed for populist rhetoric patterns.
    SPEECH CONTENT:
    {query_text}
    
    DETAILED ANALYSIS:
    [To be determined through populism analysis]"""
        else:
            raise ValueError(f"Unknown embedding strategy: {self.embedding_strategy}")
    
    def _retrieve_single_model(self, model_name: str, query_text: str, query_thought_process: Optional[str], top_k: int, faiss_k: int) -> List[Dict]:
        """Retrieve using single model"""
        model = self.embedding_models[model_name]
        query_emb_text = self._create_query_embedding_text(query_text, query_thought_process, model_name)
        query_emb = model.encode(query_emb_text, normalize_embeddings=True)
        D, I = self.indices[model_name].search(np.array([query_emb]), faiss_k)
        
        candidates = []
        for idx, cos_sim in zip(I[0], D[0]):
            if idx < len(self.speeches):
                speech = self.speeches[idx].copy()
                speech["similarity_score"] = float(cos_sim)
                speech["retrieval_model"] = model_name
                candidates.append(speech)
        
        if self.reranker and len(candidates) > 1:
            candidates = self._apply_cross_encoder_rerank(query_text, candidates)
        
        return candidates[:top_k]

    def _rank_fusion(self, all_model_results: Dict[str, List[Dict]]) -> List[Dict]:
        """Reciprocal rank fusion with model weights"""
        speech_scores = {}
        
        for model_name, candidates in all_model_results.items():
            weight = self.model_weights.get(model_name, 1.0)
            
            for rank, speech in enumerate(candidates):
                idx = speech.get("speech_idx", speech["file"])
                rrf_score = weight / (rank + 60)
                
                if idx not in speech_scores:
                    speech_scores[idx] = {
                        "total_score": 0,
                        "speech": speech,
                        "model_rankings": {},
                        "model_scores": {}
                    }
                
                speech_scores[idx]["total_score"] += rrf_score
                speech_scores[idx]["model_rankings"][model_name] = rank + 1
                speech_scores[idx]["model_scores"][model_name] = speech["similarity_score"]

        sorted_speeches = sorted(speech_scores.values(), key=lambda x: x["total_score"], reverse=True)
        
        results = []
        for item in sorted_speeches:
            speech = item["speech"].copy()
            speech["fusion_score"] = item["total_score"]
            speech["model_rankings"] = item["model_rankings"]
            speech["model_scores"] = item["model_scores"]
            speech["fusion_method"] = "rank_fusion"
            results.append(speech)
        
        return results
    
    def _score_fusion(self, all_model_results: Dict[str, List[Dict]]) -> List[Dict]:
        """Score-based fusion using weighted similarity scores"""
        speech_scores = {}
        
        for model_name, candidates in all_model_results.items():
            weight = self.model_weights.get(model_name, 1.0)
            
            for speech in candidates:
                idx = speech.get("speech_idx", speech["file"])
                weighted_score = weight * speech["similarity_score"]
                
                if idx not in speech_scores:
                    speech_scores[idx] = {
                        "total_score": 0,
                        "speech": speech,
                        "model_rankings": {},
                        "model_scores": {}
                    }
                
                speech_scores[idx]["total_score"] += weighted_score
                speech_scores[idx]["model_scores"][model_name] = speech["similarity_score"]
    
        sorted_speeches = sorted(speech_scores.values(), key=lambda x: x["total_score"], reverse=True)
        
        results = []
        for item in sorted_speeches:
            speech = item["speech"].copy()
            speech["fusion_score"] = item["total_score"]
            speech["model_scores"] = item["model_scores"]
            speech["fusion_method"] = "score_fusion"
            results.append(speech)
        
        return results
    
    
    def _weighted_fusion(self, all_model_results: Dict[str, List[Dict]]) -> List[Dict]:
        """Weighted fusion combining rank and score with model reliability"""
        speech_scores = {}
        
        for model_name, candidates in all_model_results.items():
            weight = self.model_weights.get(model_name, 1.0)
            
            for rank, speech in enumerate(candidates):
                idx = speech.get("speech_idx", speech["file"])
                
                # Combine rank and score
                rank_component = weight / (rank + 60)  # RRF component
                score_component = weight * speech["similarity_score"] * 0.5  # Score component
                combined_score = rank_component + score_component
                
                if idx not in speech_scores:
                    speech_scores[idx] = {
                        "total_score": 0,
                        "speech": speech,
                        "model_rankings": {},
                        "model_scores": {}
                    }
                
                speech_scores[idx]["total_score"] += combined_score
                speech_scores[idx]["model_rankings"][model_name] = rank + 1
                speech_scores[idx]["model_scores"][model_name] = speech["similarity_score"]
    
        sorted_speeches = sorted(speech_scores.values(), key=lambda x: x["total_score"], reverse=True)
        
        results = []
        for item in sorted_speeches:
            speech = item["speech"].copy()
            speech["fusion_score"] = item["total_score"]
            speech["model_rankings"] = item["model_rankings"]
            speech["model_scores"] = item["model_scores"]
            speech["fusion_method"] = "weighted_fusion"
            results.append(speech)
        
        return results

    def _score_fusion_dissimilar(self, all_model_results: Dict[str, List[Dict]]) -> List[Dict]:
        """Score-based fusion for dissimilar speeches using dissimilarity scores"""
        speech_scores = {}
    
        for model_name, candidates in all_model_results.items():
            weight = self.model_weights.get(model_name, 1.0)
        
            for speech in candidates:
                idx = speech.get("speech_idx", speech["file"])
                weighted_score = weight * speech["dissimilarity_score"]
            
                if idx not in speech_scores:
                    speech_scores[idx] = {
                        "total_score": 0,
                        "speech": speech,
                        "model_scores": {}
                    }
            
                speech_scores[idx]["total_score"] += weighted_score
                speech_scores[idx]["model_scores"][model_name] = speech["dissimilarity_score"]

        sorted_speeches = sorted(speech_scores.values(), key=lambda x: x["total_score"], reverse=True)
    
        results = []
        for item in sorted_speeches:
            speech = item["speech"].copy()
            speech["fusion_score"] = item["total_score"]
            speech["model_scores"] = item["model_scores"]
            speech["fusion_method"] = "score_fusion_dissimilar"
            results.append(speech)
        
        return results
    
    def _apply_cross_encoder_rerank(self, query_text: str, candidates: List[Dict]) -> List[Dict]:
        """Apply cross-encoder reranking"""
        try:
            pairs = [(query_text, speech["full_text"]) for speech in candidates]
            rerank_scores = self.reranker.predict(pairs, convert_to_numpy=True)
            
            for speech, rerank_score in zip(candidates, rerank_scores):
                speech["rerank_score"] = float(rerank_score)
            
            candidates.sort(key=lambda s: s["rerank_score"], reverse=True)
            return candidates
            
        except Exception as e:
            print(f"⚠️  Reranking failed: {e}")
            return candidates

    def set_model_weights(self, weights: Dict[str, float]):
        """Set custom weights for ensemble models"""
        self.model_weights.update(weights)
        print(f"🎛️  Updated model weights: {self.model_weights}")

    def get_performance_summary(self) -> Dict:
        """Get performance summary"""
        return {
            "models_loaded": list(self.embedding_models.keys()),
            "indices_built": list(self.indices.keys()),
            "embedding_strategy": self.embedding_strategy,
            "model_weights": self.model_weights
        }

    def format_training_examples(self, speeches: List[Dict]) -> str:
        """Format retrieved speeches for prompt"""
        examples = []
        for sp in speeches:
            speaker = sp['metadata'].get('speaker', 'Unknown')
            grade = sp.get('grade', 'Unknown')
            
            fusion_info = ""
            if 'fusion_method' in sp:
                fusion_info = f" | Fusion: {sp['fusion_method']}"
                if 'model_rankings' in sp:
                    rankings = sp['model_rankings']
                    fusion_info += f" | Models: {list(rankings.keys())}"
            
            example = f"""=== Training Example: {speaker} (Score: {grade}){fusion_info} ===

FULL TEXT: {sp['full_text']}

THOUGHT PROCESS:
{sp['thought_process']}

GRADE: {grade}

KEY EVIDENCE:"""
            
            for rubric, evidence in sp.get("rubric_evidence", {}).items():
                if evidence:
                    example += f"\n{rubric}:\n{evidence[:200]}...\n"
            
            examples.append(example)
        
        return "\n\n".join(examples)
    
    def format_hybrid_training_examples(self, hybrid_results: Dict[str, List[Dict]]) -> str:
        """Format hybrid retrieval results for prompt with clear similar/dissimilar sections"""
        
        similar_speeches = hybrid_results["similar"]
        dissimilar_speeches = hybrid_results["dissimilar"]
        
        # Format similar examples section
        similar_section = "=== SIMILAR SPEECHES (These are rhetorically similar to your target) ===\n\n"
        for i, sp in enumerate(similar_speeches, 1):
            speaker = sp['metadata'].get('speaker', 'Unknown')
            grade = sp.get('grade', 'Unknown')
            
            # Add retrieval diagnostics for transparency
            fusion_info = f"Similarity Score: {sp.get('fusion_score', 'N/A'):.3f}"
            if 'rerank_score' in sp and sp['rerank_score'] is not None:
                fusion_info += f" | Rerank: {sp['rerank_score']:.3f}"
            
            similar_section += f"""--- Similar Example {i}: {speaker} (Populism Score: {grade}) ---
    {fusion_info}
    
    CONTEXTUAL ANALYSIS:
    {self._create_embedding_text(sp, "primary")}

    FULL TEXT:
    {sp['full_text']}
    
    CODING ANALYSIS:
    {sp['thought_process']}
    
    FINAL GRADE: {grade}
    
    """
        
        # Format dissimilar examples section
        dissimilar_section = "\n=== DISSIMILAR SPEECHES (These are very different from your target) ===\n\n"
        for i, sp in enumerate(dissimilar_speeches, 1):
            speaker = sp['metadata'].get('speaker', 'Unknown')
            grade = sp.get('grade', 'Unknown')
            
            # Add dissimilarity diagnostics
            fusion_info = f"Dissimilarity Score: {sp.get('fusion_score', 'N/A'):.3f}"
            
            dissimilar_section += f"""--- Contrasting Example {i}: {speaker} (Populism Score: {grade}) ---
    {fusion_info}
    
    CONTEXTUAL ANALYSIS:
    {self._create_embedding_text(sp, "primary")}
    
    FULL TEXT:
    {sp['full_text']}
    
    CODING ANALYSIS:
    {sp['thought_process']}
    
    FINAL GRADE: {grade}
    
    """
        
        # Add calibration guidance
        calibration_section = """
    === HYBRID RAG CALIBRATION GUIDANCE ===
    
    Your target speech is SIMILAR to the speeches in the first section and DIFFERENT from those in the second section.
    
    Key calibration points:
    1. If your speech lacks the populist elements seen in the SIMILAR examples, score it lower than those examples
    2. If your speech is clearly different from the high-populism DISSIMILAR examples, this supports a lower score
    3. Use the contrast between similar (low populism) and dissimilar (high populism) examples to anchor your judgment
    4. Focus on rhetorical patterns, not just topics - similar topics can have very different populist intensities
    
    Remember: The goal is to score based on populist rhetoric patterns, using these contrasting examples as calibration anchors.
    """
        
        return similar_section + dissimilar_section + calibration_section
