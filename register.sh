#!/usr/bin/env bash

NAS_IP=$(tailscale --socket="$XDG_RUNTIME_DIR/tailscale/tailscaled.sock" status --json | jq -r '.Peer[] | select(.HostName == "RS3617") | .TailscaleIPs[0]')

MY_IP=$(tailscale --socket="$XDG_RUNTIME_DIR/tailscale/tailscaled.sock" ip -4)

MODEL="Qwen/Qwen3-Coder-Next"

# Build the JSON payload safely using jq
PAYLOAD=$(jq -n \
  --arg url "http://$MY_IP:31000" \
  --arg model "$MODEL" \
  '{url: $url, model_id: $model, labels: {tier: "gold"}}')

echo $PAYLOAD
# Execute curl
curl -X POST "http://$NAS_IP:31000/workers" \
  -H "Content-Type: application/json" \
  -d "$PAYLOAD"
