#!/usr/bin/env bash

set -euo pipefail

WORKSPACE_DIR="${WORKSPACE:-/workspace}"
MODELS_DIR="${WORKSPACE_DIR}/ComfyUI/models"

log() { printf '[wan22-14b-i2v] %s\n' "$*"; }

download() {
  local subdir="$1"
  local url="$2"
  local dst_dir="${MODELS_DIR}/${subdir}"
  local dst_file="${dst_dir}/$(basename "$url")"
  mkdir -p "$dst_dir"
  log "downloading ${url} -> ${dst_file}"
  curl -fL --retry 5 --retry-delay 3 -o "$dst_file" "$url"
}

download "diffusion_models" "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/diffusion_models/wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors"
download "diffusion_models" "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/diffusion_models/wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors"
download "loras" "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/loras/wan2.2_i2v_lightx2v_4steps_lora_v1_high_noise.safetensors"
download "loras" "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/loras/wan2.2_i2v_lightx2v_4steps_lora_v1_low_noise.safetensors"
download "text_encoders" "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors"
download "vae" "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors"

log "wan22-14b-i2v provisioning complete"
