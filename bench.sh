#!/usr/bin/env bash

for c in 48; do
  echo "=== concurrency $c ==="
  uv run python -m sglang.bench_serving \
    --backend sglang \
    --base-url http://127.0.0.1:31000 \
    --model Qwen/Qwen3.6-27B \
    --dataset-name random \
    --random-input-len 512 \
    --random-output-len 128 \
    --max-concurrency $c \
    --num-prompts $((c * 10))
done

