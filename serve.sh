#!/usr/bin/env bash

export PROTOC=$(pwd)/.pixi/envs/default/bin/protoc
export PROTOC_INCLUDE=$(pwd)/.pixi/envs/default/include

pixi run uv sync

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
#export CUDA_VISIBLE_DEVICES="4,5,6,7"
export SGLANG_ENABLE_SPEC_V2=1
export SGLANG_USE_CUDA_IPC_TRANSPORT=1
uv run python -m sglang_router.launch_server --sleep-on-idle --enable-memory-saver --enable-weights-cpu-backup \
    --host 0.0.0.0 --port 30000 \
    --model-path Qwen/Qwen3.6-27B \
    --tp 2 \
    --reasoning-parser qwen3 \
    --tool-call-parser qwen3_coder \
    --speculative-algorithm EAGLE \
    --speculative-num-steps 3 \
    --speculative-eagle-topk 1 \
    --speculative-num-draft-tokens 4 \
    --mamba-scheduler-strategy extra_buffer \
    --cuda-graph-max-bs 512 \
    --mem-fraction-static 0.9
