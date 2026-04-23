#!/usr/bin/env bash

# Read-Access-Gated-Public:
# export HF_TOKEN="..." 

# Force only Device 0 (the R9700) to be used
export HIP_VISIBLE_DEVICES=0

CACHE_DIR="/usr/local/share/llm"
MODEL="unsloth/Qwen3.5-122B-A10B-GGUF:Q5_K_M"

# size =  816.00 MiB ( 65536 cells,  12 layers,  1/1 seqs), K (q8_0):  408.00 MiB, V (q8_0):  408.00 MiB
# size = 1632.00 MiB (131072 cells,  12 layers,  1/1 seqs), K (q8_0):  816.00 MiB, V (q8_0):  816.00 MiB

LLAMA_CACHE="${CACHE_DIR}/${MODEL}" llama-server --hf-repo "${MODEL}" \
    --parallel 1 --no-mmap --no-warmup \
    --fit on --fit-target 4096 \
    --ctx-size 131072 --cache-type-k q8_0 --cache-type-v q8_0 \
    --cache-ram 8192 \
    --jinja --image-min-tokens 1024 \
    --reasoning on \
    --flash-attn on \
    --temp 0.6 \
    --top-p 0.95 \
    --top-k 20 \
    --min-p 0.0 \
    --repeat-penalty 1.0 \
    --presence-penalty 0.0 \
    --host :: --port 8080 # --verbose --no-webui
