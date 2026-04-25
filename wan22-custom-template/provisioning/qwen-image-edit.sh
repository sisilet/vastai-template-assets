#!/usr/bin/env bash

set -euo pipefail

WORKSPACE_DIR="${WORKSPACE:-/workspace}"
MODELS_DIR="${WORKSPACE_DIR}/ComfyUI/models"

log() { printf '[qwen-image-edit] %s\n' "$*"; }

download() {
  local subdir="$1"
  local url="$2"
  local dst_dir="${MODELS_DIR}/${subdir}"
  local dst_file="${dst_dir}/$(basename "$url")"
  mkdir -p "$dst_dir"
  log "downloading ${url} -> ${dst_file}"
  curl -fL --retry 5 --retry-delay 3 -o "$dst_file" "$url"
}

download "text_encoders" "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors"
download "vae" "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/vae/qwen_image_vae.safetensors"
download "loras" "https://huggingface.co/lightx2v/Qwen-Image-Lightning/resolve/main/Qwen-Image-Edit-Lightning-4steps-V1.0-bf16.safetensors"
download "diffusion_models" "https://huggingface.co/Comfy-Org/Qwen-Image-Edit_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_edit_fp8_e4m3fn.safetensors"

log "qwen-image-edit provisioning complete"
