#!/usr/bin/env bash

uv sync

# Set env variable
export CUDA_HOME=$(pwd)/.venv/lib/python3.13/site-packages/nvidia/cu13
export TVM_FFI_CUDA_ARCH_LIST="8.0"
export TVM_FFI_GPU_BACKEND=cuda
export LD_LIBRARY_PATH=""
export LIBRARY_PATH=""

# Patch cuda env
pushd $(pwd)/.venv/lib/python3.13/site-packages/nvidia/cu13/lib
ln -s libcudart.so.13 libcudart.so
pushd $(pwd)/../
ln -s lib lib64
popd
popd

# Serve
export CUDA_VISIBLE_DEVICES="4,5,6,7"
uv run sglang serve --sleep-on-idle --enable-memory-saver --enable-weights-cpu-backup --host 0.0.0.0 \
    --model-path Qwen/Qwen3-Coder-Next --tp 4 \
    --tool-call-parser qwen3_coder   --mamba-scheduler-strategy extra_buffer   --page-size 64

