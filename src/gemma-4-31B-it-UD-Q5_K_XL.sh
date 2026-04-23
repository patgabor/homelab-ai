#!/usr/bin/env bash

# Read-Access-Gated-Public:
# export HF_TOKEN="..." 

# Force only Device 0 (the R9700) to be used
export HIP_VISIBLE_DEVICES=0

CACHE_DIR="/usr/local/share/llm"
MODEL="unsloth/gemma-4-31B-it-GGUF:UD-Q5_K_XL" # https://huggingface.co/unsloth/gemma-4-31B-it-GGUF

# size = 10880.00 MiB (262144 cells,  10 layers,  1/1 seqs), K (q8_0): 5440.00 MiB, V (q8_0): 5440.00 MiB
# size = 6130.62 MiB (147712 cells,  10 layers,  1/1 seqs), K (q8_0): 3065.31 MiB, V (q8_0): 3065.31 MiB
# --fit-target 7168
# size = 4026.88 MiB ( 97024 cells,  10 layers,  1/1 seqs), K (q8_0): 2013.44 MiB, V (q8_0): 2013.44 MiB
# --fit-target 5120

LLAMA_CACHE="${CACHE_DIR}/${MODEL}" llama-server --hf-repo "${MODEL}" \
    --parallel 1 --no-mmap --no-warmup \
    --fit on --fit-target 5120 \
    --ctx-size 96856 --cache-type-k q8_0 --cache-type-v q8_0 \
    --cache-ram 16384 \
    --jinja \
    --ctx-checkpoints 128 --spec-type ngram-mod --spec-ngram-size-n 24 --draft-min 48 --draft-max 64 \
    --reasoning on \
    --reasoning-budget 4096 \
    --reasoning-budget-message "Considering the limited time by the user, I have to give the solution based on the thinking directly now." \
    --flash-attn on \
    --temp 1.0 \
    --top-p 0.95 \
    --top-k 64 \
    --host :: --port 8080 # --verbose --no-webui

# use `--cache-ram 0` to disable the prompt cache
# kv cache: k must stay at q8, v may be lower like q4
# --kv-unified for kv in RAM instead of VRAM, but may be slower than using VRAM for v-cache
# --no-mmproj to disable vision