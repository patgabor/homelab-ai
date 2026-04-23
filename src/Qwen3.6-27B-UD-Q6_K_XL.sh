#!/usr/bin/env bash

# Read-Access-Gated-Public:
# export HF_TOKEN="..." 

# Force only Device 0 (the R9700) to be used
export HIP_VISIBLE_DEVICES=0

CACHE_DIR="/usr/local/share/llm"
MODEL="unsloth/Qwen3.6-27B-GGUF:UD-Q6_K_XL"

# llama_kv_cache: size = 5712.00 MiB (172032 cells,  16 layers,  1/1 seqs), K (q8_0): 2856.00 MiB, V (q8_0): 2856.00 MiB
# llama_kv_cache: size = 6656.00 MiB (262144 cells,  16 layers,  1/1 seqs), K (q8_0): 4352.00 MiB, V (q4_0): 2304.00 MiB

# size = 5712.00 MiB ( 86016 cells,  16 layers,  2/2 seqs), K (q8_0): 2856.00 MiB, V (q8_0): 2856.00 MiB

LLAMA_CACHE="${CACHE_DIR}/${MODEL}" llama-server --hf-repo "${MODEL}" \
    --parallel 2 --no-mmap --no-warmup \
    --fit off -ngl 999 \
    --ctx-size 172032 --cache-type-k q8_0 --cache-type-v q8_0 \
    --cache-ram 16384 \
    --jinja --image-min-tokens 1024 \
    --ctx-checkpoints 128 --spec-type ngram-mod --spec-ngram-size-n 24 --draft-min 48 --draft-max 64 \
    --reasoning on --chat-template-kwargs '{"preserve_thinking": true}' \
    --reasoning-budget 4096 \
    --reasoning-budget-message "Considering the limited time by the user, I have to give the solution based on the thinking directly now." \
    --flash-attn on \
    --temp 0.6 \
    --top-p 0.95 \
    --top-k 20 \
    --min-p 0.0 \
    --repeat-penalty 1.0 \
    --presence-penalty 0.0 \
    --host :: --port 8080 # --verbose --no-webui

# ==========================================================================================
# Recommended Settings
# Maximum context window: 262,144 (can be extended to 1M via YaRN)
# presence_penalty = 0.0 to 2.0 default this is off, but to reduce repetitions, you can use this, 
# however using a higher value may result in slight decrease in performance
# Adequate Output Length: 32,768 tokens for most queries
# If you're getting gibberish, your context length might be set too low. 
# Or try using --cache-type-k bf16 --cache-type-v bf16 which might help.

# --- Reasoning setup ---
# --reasoning-budget 4096 \
# --reasoning-budget-message "Considering the limited time by the user, I have to give the solution based on the thinking directly now." \

# --- Thinking mode for general tasks: ---
# temperature=1.0, top_p=0.95, top_k=20, min_p=0.0, presence_penalty=1.5, repetition_penalty=1.0
# --- Thinking mode for precise coding tasks (e.g., WebDev): ---
# temperature=0.6, top_p=0.95, top_k=20, min_p=0.0, presence_penalty=0.0, repetition_penalty=1.0
# --- Instruct (or non-thinking) mode for general tasks: ---
# temperature=0.7, top_p=0.8, top_k=20, min_p=0.0, presence_penalty=1.5, repetition_penalty=1.0
# --- Instruct (or non-thinking) mode for reasoning tasks: ---
# temperature=1.0, top_p=1.0, top_k=40, min_p=0.0, presence_penalty=2.0, repetition_penalty=1.0
# ==========================================================================================
