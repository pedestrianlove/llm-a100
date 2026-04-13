#!/usr/bin/env bash

# Set env variable
export CUDA_HOME=$(pwd)/.venv/lib/python3.13/site-packages/nvidia/cu13

# Patch cuda env
pushd $(pwd)/.venv/lib/python3.13/site-packages/nvidia/cu13
ln -s lib lib64
ln -s lib/libcudart.so.13 lib/libcudart.so

# Serve
uv run sglang serve --model-path Qwen/Qwen3-Coder-Next --tp 4  --dp 2 \
    --tool-call-parser qwen3_coder   --mamba-scheduler-strategy extra_buffer   --page-size 64
