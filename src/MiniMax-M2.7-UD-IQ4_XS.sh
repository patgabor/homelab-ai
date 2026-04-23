#!/usr/bin/env bash

# Read-Access-Gated-Public:
# export HF_TOKEN="..." 

# Force only Device 0 (the R9700) to be used
export HIP_VISIBLE_DEVICES=0

CACHE_DIR="/usr/local/share/llm"
MODEL="unsloth/MiniMax-M2.7-GGUF:UD-IQ4_XS"

LLAMA_CACHE="${CACHE_DIR}/${MODEL}" llama-server --hf-repo "${MODEL}" \
    --parallel 2 --no-mmap --no-warmup \
    --fit off -ngl 999 -ot "exps=CPU" \
    --threads 12 \
    --ctx-size 163840 --cache-type-k q8_0 --cache-type-v q8_0 \
    --cache-ram 12288 \
    -b 4096 -ub 4096 \
    --ctx-checkpoints 128 --spec-type ngram-mod --spec-ngram-size-n 24 --draft-min 48 --draft-max 64 \
    --jinja \
    --reasoning on \
    --reasoning-budget 4096 \
    --reasoning-budget-message "Considering the limited time by the user, I have to give the solution based on the thinking directly now." \
    --flash-attn on \
    --temp 1.0 \
    --top-p 0.95 \
    --top-k 40 \
    --host :: --port 8080 # --verbose --no-webui

# Optimize performance: 
# https://gist.github.com/DocShotgun/a02a4c0c0a57e43ff4f038b46ca66ae0

# size = 8432.00 MiB ( 65536 cells,  62 layers,  1/1 seqs), K (q8_0): 4216.00 MiB, V (q8_0): 4216.00 MiB
# size = 6448.00 MiB ( 65536 cells,  62 layers,  1/1 seqs), K (q8_0): 4216.00 MiB, V (q4_0): 2232.00 MiB
# size = 19344.00 MiB (196608 cells,  62 layers,  1/1 seqs), K (q8_0): 12648.00 MiB, V (q4_0): 6696.00 MiB
# size = 4464.00 MiB ( 65536 cells,  62 layers,  1/1 seqs), K (q4_0): 2232.00 MiB, V (q4_0): 2232.00 MiB
# size = 8432.00 MiB ( 65536 cells,  62 layers,  1/1 seqs), K (q8_0): 4216.00 MiB, V (q8_0): 4216.00 MiB
# size = 16864.00 MiB (131072 cells,  62 layers,  1/1 seqs), K (q8_0): 8432.00 MiB, V (q8_0): 8432.00 MiB

# use `--cache-ram 0` to disable the prompt cache
# kv cache: k must stay at q8, v may be lower like q4
# `--kv-unified` for kv in RAM instead of VRAM, but may be slower than using VRAM for v-cache

# lscpu | grep -E 'Core|Thread'
# Model name:                              AMD Ryzen 9 9900X3D 12-Core Processor
# Thread(s) per core:                      2
# Core(s) per socket:                      12
# --threads 12

# ==========================================================================================
# MiniMax recommends using the following parameters for best performance: 
# temperature=1.0, top_p = 0.95, top_k = 40.
# ==========================================================================================
