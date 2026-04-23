#!/usr/bin/env bash

# Read-Access-Gated-Public:
# export HF_TOKEN="..." 

# Force only Device 0 (the R9700) to be used
export HIP_VISIBLE_DEVICES=-1

CACHE_DIR="/usr/local/share/llm"
MODEL="ggml-org/Qwen3-Reranker-0.6B-Q8_0-GGUF:Q8_0"

LLAMA_CACHE="${CACHE_DIR}/${MODEL}" llama-server --hf-repo "${MODEL}" \
    --parallel 1 --no-mmap --no-warmup \
    --fit off --n-gpu-layers 0 \
    --ctx-size 0 --cache-type-k q8_0 --cache-type-v q8_0 \
    --rerank --reasoning off \
    --host :: --port 8082 # --verbose --no-webui
