#!/usr/bin/env bash

set -euo pipefail

WORKSPACE_DIR="${WORKSPACE:-/workspace}"
MODELS_DIR="${WORKSPACE_DIR}/ComfyUI/models"

log() { printf '[moody-zib-zit] %s\n' "$*"; }

download() {
  local subdir="$1"
  local url="$2"
  local filename="${3:-$(basename "$url") }"
  filename="${filename// /}"
  local dst_dir="${MODELS_DIR}/${subdir}"
  local dst_file="${dst_dir}/${filename}"
  mkdir -p "$dst_dir"
  log "downloading ${url} -> ${dst_file}"
  curl -fL --retry 5 --retry-delay 3 -o "$dst_file" "$url"
}

# Publicly resolvable dependencies.
download "text_encoders" "https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/text_encoders/qwen_3_4b.safetensors"
download "vae" "https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/vae/ae.safetensors"

# Exact Moody workflow weights require direct file URLs from the user.
if [ -z "${ZIMAGE_ZIB_MODEL_URL:-}" ] || [ -z "${ZIMAGE_ZIT_MODEL_URL:-}" ]; then
  log "missing required env vars: ZIMAGE_ZIB_MODEL_URL and/or ZIMAGE_ZIT_MODEL_URL"
  log "set them to direct downloadable file URLs for the exact Moody models"
  log "expected filenames: moodyWildMix_v20BASE45STEPS.safetensors and moodyPornMix_zitV10DPO.safetensors"
  exit 1
fi

download "diffusion_models" "$ZIMAGE_ZIB_MODEL_URL" "moodyWildMix_v20BASE45STEPS.safetensors"
download "diffusion_models" "$ZIMAGE_ZIT_MODEL_URL" "moodyPornMix_zitV10DPO.safetensors"

log "optional extras not installed by default: SAM, SeedVR2, upscalers"
log "moody-zib-zit provisioning complete"
