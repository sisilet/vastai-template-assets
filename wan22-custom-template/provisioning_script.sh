#!/usr/bin/env bash

set -euo pipefail

# Starter provisioning script for a custom Vast.ai serverless ComfyUI Wan 2.2 template.
#
# Configure behavior with template environment variables:
# - WORKFLOW_NAME                (exact workflow selector; installs only that workflow's assets)
# - WORKFLOW_MODEL_PACK          (none|moody-zib-zit|ltx) broader fallback if WORKFLOW_NAME is unset
# - CUSTOM_MODEL_URL
# - CUSTOM_MODEL_NAME
# - CUSTOM_MODEL_SUBDIR            (default: diffusion_models)
# - CUSTOM_MODEL_EXTRA_URLS        (space-separated URLs for the primary subdir)
# - CUSTOM_MODEL_EXTRA_SPECS       (space-separated entries in the form subdir|url)
# - CUSTOM_NODE_REPOS              (space-separated git clone URLs)
# - CUSTOM_NODES_REF_<repo_name>   (optional git ref per repo)
#
# Example:
# WORKFLOW_NAME=ltx23-gguf-t2v
# WORKFLOW_MODEL_PACK=ltx
# CUSTOM_MODEL_URL=https://example.com/my-model.safetensors
# CUSTOM_MODEL_NAME=my-model.safetensors
# CUSTOM_MODEL_SUBDIR=diffusion_models
# CUSTOM_MODEL_EXTRA_SPECS="loras|https://example.com/foo.safetensors vae|https://example.com/bar.safetensors"
# CUSTOM_NODE_REPOS="https://github.com/ltdrdata/ComfyUI-Manager.git https://github.com/user/MyNode.git"

WORKSPACE_DIR="${WORKSPACE:-/workspace}"
COMFY_DIR="${WORKSPACE_DIR}/ComfyUI"
MODELS_DIR="${COMFY_DIR}/models"
NODES_DIR="${COMFY_DIR}/custom_nodes"

log() {
  printf '[wan22-provision] %s\n' "$*"
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    log "missing required command: $1"
    exit 1
  }
}

download_to() {
  local url="$1"
  local dst="$2"
  mkdir -p "$(dirname "$dst")"
  log "downloading ${url} -> ${dst}"
  curl -fL --retry 5 --retry-delay 3 -o "$dst" "$url"
}

install_spec_line() {
  local spec="$1"
  local local_subdir="${spec%%|*}"
  local url="${spec#*|}"

  if [ -z "$local_subdir" ] || [ "$local_subdir" = "$url" ]; then
    log "invalid spec entry: ${spec}"
    exit 1
  fi

  download_to "$url" "${MODELS_DIR}/${local_subdir}/$(basename "$url")"
}

install_specs_block() {
  local block="$1"
  while IFS= read -r spec; do
    [ -n "$spec" ] || continue
    install_spec_line "$spec"
  done <<< "$block"
}

get_model_pack_specs() {
  local pack="$1"

  case "$pack" in
    none|"")
      return 0
      ;;
    moody-zib-zit)
      cat <<'EOF'
text_encoders|https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/text_encoders/qwen_3_4b.safetensors
vae|https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/vae/ae.safetensors
sams|https://dl.fbaipublicfiles.com/segment_anything/sam_vit_b_01ec64.pth
seedvr2|https://huggingface.co/ByteDance-Seed/SeedVR2-7B/resolve/main/ema_vae.pth
seedvr2|https://huggingface.co/ByteDance-Seed/SeedVR2-7B/resolve/main/seedvr2_ema_7b_sharp.pth
EOF
      ;;
    ltx)
      cat <<'EOF'
text_encoders|https://huggingface.co/Comfy-Org/ltx-2/resolve/main/split_files/text_encoders/gemma_3_12B_it_fp4_mixed.safetensors
text_encoders|https://huggingface.co/Comfy-Org/ltx-2/resolve/main/split_files/text_encoders/gemma_3_12B_it_fpmixed.safetensors
text_encoders|https://huggingface.co/GitMylo/LTX-2-comfy_gemma_fp8_e4m3fn/resolve/main/gemma_3_12B_it_fp8_e4m3fn.safetensors
text_encoders|https://huggingface.co/bartowski/google_gemma-3-12b-it-qat-GGUF/resolve/main/google_gemma-3-12b-it-qat-Q6_K.gguf
text_encoders|https://huggingface.co/mradermacher/gemma-3-12b-it-heretic-GGUF/resolve/main/gemma-3-12b-it-heretic.Q8_0.gguf
text_encoders|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/text_encoders/ltx-2.3_text_projection_bf16.safetensors
text_encoders|https://huggingface.co/Kijai/LTXV2_comfy/resolve/main/text_encoders/ltx-2-19b-embeddings_connector_dev_bf16.safetensors
text_encoders|https://huggingface.co/Kijai/LTXV2_comfy/resolve/main/text_encoders/ltx-2-19b-embeddings_connector_distill_bf16.safetensors
vae|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/vae/LTX23_video_vae_bf16.safetensors
vae|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/vae/LTX23_audio_vae_bf16.safetensors
VAE|https://huggingface.co/Kijai/LTXV2_comfy/resolve/main/VAE/LTX2_video_vae_bf16.safetensors
VAE|https://huggingface.co/Kijai/LTXV2_comfy/resolve/main/VAE/LTX2_audio_vae_bf16.safetensors
vae|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/vae/taeltx2_3.safetensors
checkpoints|https://huggingface.co/Lightricks/LTX-2.3-fp8/resolve/main/ltx-2.3-22b-dev-fp8.safetensors
diffusion_models|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/diffusion_models/ltx-2.3-22b-dev_transformer_only_bf16.safetensors
diffusion_models|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/diffusion_models/ltx-2-3-22b-dev_transformer_only_fp8_input_scaled.safetensors
diffusion_models|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/diffusion_models/ltx-2.3-22b-distilled_transformer_only_fp8_input_scaled.safetensors
diffusion_models|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/diffusion_models/ltx-2.3-22b-distilled_transformer_only_fp8_input_scaled_v3.safetensors
diffusion_models|https://huggingface.co/Kijai/LTXV2_comfy/resolve/main/diffusion_models/ltx-2-19b-dev-fp8_transformer_only.safetensors
diffusion_models|https://huggingface.co/unsloth/LTX-2.3-GGUF/resolve/main/ltx-2.3-22b-dev-Q4_K_M.gguf
diffusion_models|https://huggingface.co/unsloth/LTX-2.3-GGUF/resolve/main/distilled/ltx-2.3-22b-distilled-Q6_K.gguf
diffusion_models|https://huggingface.co/QuantStack/LTX-2.3-GGUF/resolve/main/LTX-2.3-distilled/LTX-2.3-distilled-Q4_K_S.gguf
diffusion_models|https://huggingface.co/QuantStack/LTX-2.3-GGUF/resolve/main/LTX-2.3-distilled/LTX-2.3-distilled-Q4_K_M.gguf
loras|https://huggingface.co/MachineDelusions/LTX-2_Image2Video_Adapter_LoRa/resolve/main/LTX-2-Image2Vid-Adapter.safetensors
loras|https://huggingface.co/Lightricks/LTX-2-19b-IC-LoRA-Detailer/resolve/main/ltx-2-19b-ic-lora-detailer.safetensors
loras|https://huggingface.co/Lightricks/LTX-2-19b-IC-LoRA-Pose-Control/resolve/main/ltx-2-19b-ic-lora-pose-control.safetensors
loras|https://huggingface.co/Lightricks/LTX-2-19b-LoRA-Camera-Control-Static/resolve/main/ltx-2-19b-lora-camera-control-static.safetensors
loras|https://huggingface.co/FastVideo/LTX2-Distilled-LoRA/resolve/main/ltx-2-19b-distilled-lora-384.safetensors
upscale_models|https://huggingface.co/Lightricks/LTX-2.3/resolve/main/ltx-2.3-spatial-upscaler-x2-1.0.safetensors
upscale_models|https://huggingface.co/Lightricks/LTX-2.3/resolve/main/ltx-2.3-spatial-upscaler-x2-1.1.safetensors
upscale_models|https://huggingface.co/Lightricks/LTX-2.3/resolve/main/ltx-2.3-temporal-upscaler-x2-1.0.safetensors
audio_models/MelBandRoFormer_comfy|https://huggingface.co/Kijai/MelBandRoFormer_comfy/resolve/main/MelBandRoformer_fp16.safetensors
EOF
      ;;
    *)
      log "unsupported WORKFLOW_MODEL_PACK: ${pack}"
      log "supported values: none, moody-zib-zit, ltx"
      exit 1
      ;;
  esac
}

get_workflow_specs() {
  local workflow="$1"

  case "$workflow" in
    none|"")
      return 0
      ;;
    qwen-image-edit)
      cat <<'EOF'
text_encoders|https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors
vae|https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/vae/qwen_image_vae.safetensors
loras|https://huggingface.co/lightx2v/Qwen-Image-Lightning/resolve/main/Qwen-Image-Edit-Lightning-4steps-V1.0-bf16.safetensors
diffusion_models|https://huggingface.co/Comfy-Org/Qwen-Image-Edit_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_edit_fp8_e4m3fn.safetensors
EOF
      ;;
    ltx23-gguf-t2v)
      cat <<'EOF'
text_encoders|https://huggingface.co/Comfy-Org/ltx-2/resolve/main/split_files/text_encoders/gemma_3_12B_it_fp4_mixed.safetensors
text_encoders|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/text_encoders/ltx-2.3_text_projection_bf16.safetensors
vae|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/vae/LTX23_video_vae_bf16.safetensors
vae|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/vae/LTX23_audio_vae_bf16.safetensors
diffusion_models|https://huggingface.co/unsloth/LTX-2.3-GGUF/resolve/main/ltx-2.3-22b-dev-Q4_K_M.gguf
upscale_models|https://huggingface.co/Lightricks/LTX-2.3/resolve/main/ltx-2.3-spatial-upscaler-x2-1.0.safetensors
loras|https://huggingface.co/Lightricks/LTX-2-19b-IC-LoRA-Detailer/resolve/main/ltx-2-19b-ic-lora-detailer.safetensors
EOF
      ;;
    ltx23-gguf-i2v)
      cat <<'EOF'
text_encoders|https://huggingface.co/Comfy-Org/ltx-2/resolve/main/split_files/text_encoders/gemma_3_12B_it_fp4_mixed.safetensors
text_encoders|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/text_encoders/ltx-2.3_text_projection_bf16.safetensors
vae|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/vae/LTX23_video_vae_bf16.safetensors
vae|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/vae/LTX23_audio_vae_bf16.safetensors
diffusion_models|https://huggingface.co/unsloth/LTX-2.3-GGUF/resolve/main/ltx-2.3-22b-dev-Q4_K_M.gguf
upscale_models|https://huggingface.co/Lightricks/LTX-2.3/resolve/main/ltx-2.3-spatial-upscaler-x2-1.0.safetensors
loras|https://huggingface.co/MachineDelusions/LTX-2_Image2Video_Adapter_LoRa/resolve/main/LTX-2-Image2Vid-Adapter.safetensors
EOF
      ;;
    ltx23-gguf-v2v)
      cat <<'EOF'
text_encoders|https://huggingface.co/Comfy-Org/ltx-2/resolve/main/split_files/text_encoders/gemma_3_12B_it_fp4_mixed.safetensors
text_encoders|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/text_encoders/ltx-2.3_text_projection_bf16.safetensors
vae|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/vae/LTX23_video_vae_bf16.safetensors
vae|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/vae/LTX23_audio_vae_bf16.safetensors
diffusion_models|https://huggingface.co/unsloth/LTX-2.3-GGUF/resolve/main/ltx-2.3-22b-dev-Q4_K_M.gguf
upscale_models|https://huggingface.co/Lightricks/LTX-2.3/resolve/main/ltx-2.3-spatial-upscaler-x2-1.0.safetensors
loras|https://huggingface.co/Lightricks/LTX-2-19b-LoRA-Camera-Control-Static/resolve/main/ltx-2-19b-lora-camera-control-static.safetensors
EOF
      ;;
    ltx23-audio-t2v)
      cat <<'EOF'
text_encoders|https://huggingface.co/Comfy-Org/ltx-2/resolve/main/split_files/text_encoders/gemma_3_12B_it_fp4_mixed.safetensors
text_encoders|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/text_encoders/ltx-2.3_text_projection_bf16.safetensors
vae|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/vae/LTX23_video_vae_bf16.safetensors
vae|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/vae/LTX23_audio_vae_bf16.safetensors
diffusion_models|https://huggingface.co/unsloth/LTX-2.3-GGUF/resolve/main/ltx-2.3-22b-dev-Q4_K_M.gguf
upscale_models|https://huggingface.co/Lightricks/LTX-2.3/resolve/main/ltx-2.3-spatial-upscaler-x2-1.0.safetensors
loras|https://huggingface.co/Lightricks/LTX-2-19b-IC-LoRA-Detailer/resolve/main/ltx-2-19b-ic-lora-detailer.safetensors
EOF
      ;;
    ltx23-audio-i2v)
      cat <<'EOF'
text_encoders|https://huggingface.co/Comfy-Org/ltx-2/resolve/main/split_files/text_encoders/gemma_3_12B_it_fp4_mixed.safetensors
text_encoders|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/text_encoders/ltx-2.3_text_projection_bf16.safetensors
vae|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/vae/LTX23_video_vae_bf16.safetensors
vae|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/vae/LTX23_audio_vae_bf16.safetensors
diffusion_models|https://huggingface.co/unsloth/LTX-2.3-GGUF/resolve/main/ltx-2.3-22b-dev-Q4_K_M.gguf
upscale_models|https://huggingface.co/Lightricks/LTX-2.3/resolve/main/ltx-2.3-spatial-upscaler-x2-1.0.safetensors
loras|https://huggingface.co/MachineDelusions/LTX-2_Image2Video_Adapter_LoRa/resolve/main/LTX-2-Image2Vid-Adapter.safetensors
EOF
      ;;
    ltx23-ti2v)
      cat <<'EOF'
text_encoders|https://huggingface.co/bartowski/google_gemma-3-12b-it-qat-GGUF/resolve/main/google_gemma-3-12b-it-qat-Q6_K.gguf
text_encoders|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/text_encoders/ltx-2.3_text_projection_bf16.safetensors
vae|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/vae/LTX23_video_vae_bf16.safetensors
vae|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/vae/LTX23_audio_vae_bf16.safetensors
diffusion_models|https://huggingface.co/QuantStack/LTX-2.3-GGUF/resolve/main/LTX-2.3-distilled/LTX-2.3-distilled-Q4_K_S.gguf
upscale_models|https://huggingface.co/Lightricks/LTX-2.3/resolve/main/ltx-2.3-spatial-upscaler-x2-1.0.safetensors
loras|https://huggingface.co/Lightricks/LTX-2-19b-IC-LoRA-Detailer/resolve/main/ltx-2-19b-ic-lora-detailer.safetensors
EOF
      ;;
    ltx23-ti2v-expert)
      cat <<'EOF'
text_encoders|https://huggingface.co/bartowski/google_gemma-3-12b-it-qat-GGUF/resolve/main/google_gemma-3-12b-it-qat-Q6_K.gguf
text_encoders|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/text_encoders/ltx-2.3_text_projection_bf16.safetensors
vae|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/vae/LTX23_video_vae_bf16.safetensors
vae|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/vae/LTX23_audio_vae_bf16.safetensors
diffusion_models|https://huggingface.co/QuantStack/LTX-2.3-GGUF/resolve/main/LTX-2.3-distilled/LTX-2.3-distilled-Q4_K_S.gguf
upscale_models|https://huggingface.co/Lightricks/LTX-2.3/resolve/main/ltx-2.3-spatial-upscaler-x2-1.0.safetensors
upscale_models|https://huggingface.co/Lightricks/LTX-2.3/resolve/main/ltx-2.3-temporal-upscaler-x2-1.0.safetensors
loras|https://huggingface.co/Lightricks/LTX-2-19b-IC-LoRA-Detailer/resolve/main/ltx-2-19b-ic-lora-detailer.safetensors
loras|https://huggingface.co/Lightricks/LTX-2-19b-IC-LoRA-Pose-Control/resolve/main/ltx-2-19b-ic-lora-pose-control.safetensors
EOF
      ;;
    ltx23-ti2v-expert-q6k)
      cat <<'EOF'
text_encoders|https://huggingface.co/bartowski/google_gemma-3-12b-it-qat-GGUF/resolve/main/google_gemma-3-12b-it-qat-Q6_K.gguf
text_encoders|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/text_encoders/ltx-2.3_text_projection_bf16.safetensors
vae|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/vae/LTX23_video_vae_bf16.safetensors
vae|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/vae/LTX23_audio_vae_bf16.safetensors
diffusion_models|https://huggingface.co/unsloth/LTX-2.3-GGUF/resolve/main/distilled/ltx-2.3-22b-distilled-Q6_K.gguf
upscale_models|https://huggingface.co/Lightricks/LTX-2.3/resolve/main/ltx-2.3-spatial-upscaler-x2-1.0.safetensors
upscale_models|https://huggingface.co/Lightricks/LTX-2.3/resolve/main/ltx-2.3-temporal-upscaler-x2-1.0.safetensors
loras|https://huggingface.co/Lightricks/LTX-2-19b-IC-LoRA-Detailer/resolve/main/ltx-2-19b-ic-lora-detailer.safetensors
loras|https://huggingface.co/Lightricks/LTX-2-19b-IC-LoRA-Pose-Control/resolve/main/ltx-2-19b-ic-lora-pose-control.safetensors
EOF
      ;;
    ltx2-s2v)
      cat <<'EOF'
text_encoders|https://huggingface.co/GitMylo/LTX-2-comfy_gemma_fp8_e4m3fn/resolve/main/gemma_3_12B_it_fp8_e4m3fn.safetensors
text_encoders|https://huggingface.co/Kijai/LTXV2_comfy/resolve/main/text_encoders/ltx-2-19b-embeddings_connector_distill_bf16.safetensors
VAE|https://huggingface.co/Kijai/LTXV2_comfy/resolve/main/VAE/LTX2_video_vae_bf16.safetensors
VAE|https://huggingface.co/Kijai/LTXV2_comfy/resolve/main/VAE/LTX2_audio_vae_bf16.safetensors
diffusion_models|https://huggingface.co/Kijai/LTXV2_comfy/resolve/main/diffusion_models/ltx-2-19b-dev-fp8_transformer_only.safetensors
EOF
      ;;
    ltxv2-frame-injection)
      cat <<'EOF'
text_encoders|https://huggingface.co/GitMylo/LTX-2-comfy_gemma_fp8_e4m3fn/resolve/main/gemma_3_12B_it_fp8_e4m3fn.safetensors
text_encoders|https://huggingface.co/Kijai/LTXV2_comfy/resolve/main/text_encoders/ltx-2-19b-embeddings_connector_dev_bf16.safetensors
loras|https://huggingface.co/FastVideo/LTX2-Distilled-LoRA/resolve/main/ltx-2-19b-distilled-lora-384.safetensors
EOF
      ;;
    ltx23-multi-transformer)
      cat <<'EOF'
text_encoders|https://huggingface.co/Comfy-Org/ltx-2/resolve/main/split_files/text_encoders/gemma_3_12B_it_fpmixed.safetensors
text_encoders|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/text_encoders/ltx-2.3_text_projection_bf16.safetensors
vae_ltx|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/vae/LTX23_video_vae_bf16.safetensors
vae_ltx|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/vae/LTX23_audio_vae_bf16.safetensors
vae|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/vae/taeltx2_3.safetensors
diffusion_models|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/diffusion_models/ltx-2.3-22b-dev_transformer_only_bf16.safetensors
upscale_models|https://huggingface.co/Lightricks/LTX-2.3/resolve/main/ltx-2.3-spatial-upscaler-x2-1.1.safetensors
loras|https://huggingface.co/FastVideo/LTX2-Distilled-LoRA/resolve/main/ltx-2-19b-distilled-lora-384.safetensors
EOF
      ;;
    ltx23-latent-workflows)
      cat <<'EOF'
text_encoders|https://huggingface.co/GitMylo/LTX-2-comfy_gemma_fp8_e4m3fn/resolve/main/gemma_3_12B_it_fp8_e4m3fn.safetensors
text_encoders|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/text_encoders/ltx-2.3_text_projection_bf16.safetensors
vae|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/vae/LTX23_video_vae_bf16.safetensors
vae|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/vae/LTX23_audio_vae_bf16.safetensors
diffusion_models|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/diffusion_models/ltx-2.3-22b-distilled_transformer_only_fp8_input_scaled.safetensors
upscale_models|https://huggingface.co/Lightricks/LTX-2.3/resolve/main/ltx-2.3-spatial-upscaler-x2-1.0.safetensors
EOF
      ;;
    ltx23-i2v-native)
      cat <<'EOF'
text_encoders|https://huggingface.co/GitMylo/LTX-2-comfy_gemma_fp8_e4m3fn/resolve/main/gemma_3_12B_it_fp8_e4m3fn.safetensors
text_encoders|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/text_encoders/ltx-2.3_text_projection_bf16.safetensors
checkpoints|https://huggingface.co/Lightricks/LTX-2.3-fp8/resolve/main/ltx-2.3-22b-dev-fp8.safetensors
upscale_models|https://huggingface.co/Lightricks/LTX-2.3/resolve/main/ltx-2.3-spatial-upscaler-x2-1.0.safetensors
loras|https://huggingface.co/FastVideo/LTX2-Distilled-LoRA/resolve/main/ltx-2-19b-distilled-lora-384.safetensors
EOF
      ;;
    ltx23-i2v-gguf)
      cat <<'EOF'
text_encoders|https://huggingface.co/mradermacher/gemma-3-12b-it-heretic-GGUF/resolve/main/gemma-3-12b-it-heretic.Q8_0.gguf
text_encoders|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/text_encoders/ltx-2.3_text_projection_bf16.safetensors
vae|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/vae/LTX23_video_vae_bf16.safetensors
VAE|https://huggingface.co/Kijai/LTXV2_comfy/resolve/main/VAE/LTX2_audio_vae_bf16.safetensors
diffusion_models|https://huggingface.co/QuantStack/LTX-2.3-GGUF/resolve/main/LTX-2.3-distilled/LTX-2.3-distilled-Q4_K_M.gguf
upscale_models|https://huggingface.co/Lightricks/LTX-2.3/resolve/main/ltx-2.3-spatial-upscaler-x2-1.0.safetensors
EOF
      ;;
    ltx23-i2v-kijai)
      cat <<'EOF'
text_encoders|https://huggingface.co/GitMylo/LTX-2-comfy_gemma_fp8_e4m3fn/resolve/main/gemma_3_12B_it_fp8_e4m3fn.safetensors
text_encoders|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/text_encoders/ltx-2.3_text_projection_bf16.safetensors
vae|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/vae/LTX23_video_vae_bf16.safetensors
vae|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/vae/LTX23_audio_vae_bf16.safetensors
diffusion_models|https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/diffusion_models/ltx-2.3-22b-distilled_transformer_only_fp8_input_scaled.safetensors
upscale_models|https://huggingface.co/Lightricks/LTX-2.3/resolve/main/ltx-2.3-spatial-upscaler-x2-1.0.safetensors
EOF
      ;;
    *)
      log "unsupported WORKFLOW_NAME: ${workflow}"
      log "supported values: qwen-image-edit, ltx23-gguf-t2v, ltx23-gguf-i2v, ltx23-gguf-v2v, ltx23-audio-t2v, ltx23-audio-i2v, ltx23-ti2v, ltx23-ti2v-expert, ltx23-ti2v-expert-q6k, ltx2-s2v, ltxv2-frame-injection, ltx23-multi-transformer, ltx23-latent-workflows, ltx23-i2v-native, ltx23-i2v-gguf, ltx23-i2v-kijai"
      exit 1
      ;;
  esac
}

clone_or_update_repo() {
  local repo_url="$1"
  local repo_name
  repo_name="$(basename "$repo_url" .git)"
  local dst="${NODES_DIR}/${repo_name}"
  local ref_var="CUSTOM_NODES_REF_${repo_name//[^A-Za-z0-9_]/_}"
  local ref="${!ref_var:-}"

  if [ -d "$dst/.git" ]; then
    log "updating custom node repo ${repo_name}"
    git -C "$dst" fetch --all --tags
  else
    log "cloning custom node repo ${repo_name}"
    git clone "$repo_url" "$dst"
  fi

  if [ -n "$ref" ]; then
    log "checking out ${repo_name} ref ${ref}"
    git -C "$dst" checkout "$ref"
  fi
}

main() {
  require_cmd curl
  require_cmd git

  mkdir -p "$MODELS_DIR" "$NODES_DIR"

  workflow_name="${WORKFLOW_NAME:-none}"
  workflow_model_pack="${WORKFLOW_MODEL_PACK:-none}"
  log "selected WORKFLOW_NAME=${workflow_name}"
  log "selected WORKFLOW_MODEL_PACK=${workflow_model_pack}"

  if [ "$workflow_name" != "none" ]; then
    log "installing workflow-specific model set ${workflow_name}"
    install_specs_block "$(get_workflow_specs "$workflow_name")"
  elif [ "$workflow_model_pack" != "none" ]; then
    log "installing built-in model pack ${workflow_model_pack}"
    install_specs_block "$(get_model_pack_specs "$workflow_model_pack")"
  fi

  if [ -n "${CUSTOM_MODEL_URL:-}" ]; then
    model_subdir="${CUSTOM_MODEL_SUBDIR:-diffusion_models}"
    model_name="${CUSTOM_MODEL_NAME:-$(basename "${CUSTOM_MODEL_URL}")}"
    model_name="${model_name// /}"
    download_to "$CUSTOM_MODEL_URL" "${MODELS_DIR}/${model_subdir}/${model_name}"
  else
    log "CUSTOM_MODEL_URL not set; skipping primary custom model download"
  fi

  if [ -n "${CUSTOM_MODEL_EXTRA_URLS:-}" ]; then
    model_subdir="${CUSTOM_MODEL_SUBDIR:-diffusion_models}"
    for url in ${CUSTOM_MODEL_EXTRA_URLS}; do
      download_to "$url" "${MODELS_DIR}/${model_subdir}/$(basename "$url")"
    done
  fi

  if [ -n "${CUSTOM_MODEL_EXTRA_SPECS:-}" ]; then
    for spec in ${CUSTOM_MODEL_EXTRA_SPECS}; do
      install_spec_line "$spec"
    done
  fi

  if [ -n "${CUSTOM_NODE_REPOS:-}" ]; then
    for repo in ${CUSTOM_NODE_REPOS}; do
      clone_or_update_repo "$repo"
    done
  else
    log "CUSTOM_NODE_REPOS not set; skipping custom node install"
  fi

  log "custom provisioning complete"
}

main "$@"
