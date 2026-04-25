#!/usr/bin/env bash

set -euo pipefail

WORKSPACE_DIR="${WORKSPACE:-/workspace}"
MODELS_DIR="${WORKSPACE_DIR}/ComfyUI/models"

log() { printf '[zimage-stock] %s\n' "$*"; }

download() {
  local subdir="$1"
  local url="$2"
  local dst_dir="${MODELS_DIR}/${subdir}"
  local dst_file="${dst_dir}/$(basename "$url")"
  mkdir -p "$dst_dir"
  log "downloading ${url} -> ${dst_file}"
  curl -fL --retry 5 --retry-delay 3 -o "$dst_file" "$url"
}

download "text_encoders" "https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/text_encoders/qwen_3_4b.safetensors"
download "vae" "https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/vae/ae.safetensors"
download "diffusion_models" "https://huggingface.co/Comfy-Org/z_image/resolve/main/split_files/diffusion_models/z_image_bf16.safetensors"
download "diffusion_models" "https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/diffusion_models/z_image_turbo_bf16.safetensors"

log "zimage-stock provisioning complete"
