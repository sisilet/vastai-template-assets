#!/usr/bin/env bash

set -euo pipefail

BASE_DIR="${1:-${WORKSPACE:-/workspace}/ComfyUI/models}"

download() {
  local subdir="$1"
  local url="$2"
  local dst_dir="${BASE_DIR}/${subdir}"
  local dst_file="${dst_dir}/$(basename "$url")"

  mkdir -p "$dst_dir"
  printf '[download-models] %s -> %s\n' "$url" "$dst_file"
  curl -fL --retry 5 --retry-delay 3 -o "$dst_file" "$url"
}

# Qwen Image Edit
download "text_encoders" "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors"
download "vae" "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/vae/qwen_image_vae.safetensors"
download "loras" "https://huggingface.co/lightx2v/Qwen-Image-Lightning/resolve/main/Qwen-Image-Edit-Lightning-4steps-V1.0-bf16.safetensors"
download "diffusion_models" "https://huggingface.co/Comfy-Org/Qwen-Image-Edit_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_edit_fp8_e4m3fn.safetensors"

# Moody / ZIB / ZIT
download "text_encoders" "https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/text_encoders/qwen_3_4b.safetensors"
download "vae" "https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/vae/ae.safetensors"
download "sams" "https://dl.fbaipublicfiles.com/segment_anything/sam_vit_b_01ec64.pth"
download "seedvr2" "https://huggingface.co/ByteDance-Seed/SeedVR2-7B/resolve/main/ema_vae.pth"
download "seedvr2" "https://huggingface.co/ByteDance-Seed/SeedVR2-7B/resolve/main/seedvr2_ema_7b_sharp.pth"

# LTX core encoders and vaes
download "text_encoders" "https://huggingface.co/Comfy-Org/ltx-2/resolve/main/split_files/text_encoders/gemma_3_12B_it_fp4_mixed.safetensors"
download "text_encoders" "https://huggingface.co/Comfy-Org/ltx-2/resolve/main/split_files/text_encoders/gemma_3_12B_it_fpmixed.safetensors"
download "text_encoders" "https://huggingface.co/GitMylo/LTX-2-comfy_gemma_fp8_e4m3fn/resolve/main/gemma_3_12B_it_fp8_e4m3fn.safetensors"
download "text_encoders" "https://huggingface.co/bartowski/google_gemma-3-12b-it-qat-GGUF/resolve/main/google_gemma-3-12b-it-qat-Q6_K.gguf"
download "text_encoders" "https://huggingface.co/mradermacher/gemma-3-12b-it-heretic-GGUF/resolve/main/gemma-3-12b-it-heretic.Q8_0.gguf"
download "text_encoders" "https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/text_encoders/ltx-2.3_text_projection_bf16.safetensors"
download "text_encoders" "https://huggingface.co/Kijai/LTXV2_comfy/resolve/main/text_encoders/ltx-2-19b-embeddings_connector_dev_bf16.safetensors"
download "text_encoders" "https://huggingface.co/Kijai/LTXV2_comfy/resolve/main/text_encoders/ltx-2-19b-embeddings_connector_distill_bf16.safetensors"
download "vae" "https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/vae/LTX23_video_vae_bf16.safetensors"
download "vae" "https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/vae/LTX23_audio_vae_bf16.safetensors"
download "VAE" "https://huggingface.co/Kijai/LTXV2_comfy/resolve/main/VAE/LTX2_video_vae_bf16.safetensors"
download "VAE" "https://huggingface.co/Kijai/LTXV2_comfy/resolve/main/VAE/LTX2_audio_vae_bf16.safetensors"
download "vae" "https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/vae/taeltx2_3.safetensors"

# LTX diffusion, GGUF, LoRAs, upscalers, audio helpers
download "checkpoints" "https://huggingface.co/Lightricks/LTX-2.3-fp8/resolve/main/ltx-2.3-22b-dev-fp8.safetensors"
download "diffusion_models" "https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/diffusion_models/ltx-2.3-22b-dev_transformer_only_bf16.safetensors"
download "diffusion_models" "https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/diffusion_models/ltx-2-3-22b-dev_transformer_only_fp8_input_scaled.safetensors"
download "diffusion_models" "https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/diffusion_models/ltx-2.3-22b-distilled_transformer_only_fp8_input_scaled.safetensors"
download "diffusion_models" "https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/diffusion_models/ltx-2.3-22b-distilled_transformer_only_fp8_input_scaled_v3.safetensors"
download "diffusion_models" "https://huggingface.co/Kijai/LTXV2_comfy/resolve/main/diffusion_models/ltx-2-19b-dev-fp8_transformer_only.safetensors"
download "diffusion_models" "https://huggingface.co/unsloth/LTX-2.3-GGUF/resolve/main/ltx-2.3-22b-dev-Q4_K_M.gguf"
download "diffusion_models" "https://huggingface.co/unsloth/LTX-2.3-GGUF/resolve/main/distilled/ltx-2.3-22b-distilled-Q6_K.gguf"
download "diffusion_models" "https://huggingface.co/QuantStack/LTX-2.3-GGUF/resolve/main/LTX-2.3-distilled/LTX-2.3-distilled-Q4_K_S.gguf"
download "diffusion_models" "https://huggingface.co/QuantStack/LTX-2.3-GGUF/resolve/main/LTX-2.3-distilled/LTX-2.3-distilled-Q4_K_M.gguf"
download "loras" "https://huggingface.co/MachineDelusions/LTX-2_Image2Video_Adapter_LoRa/resolve/main/LTX-2-Image2Vid-Adapter.safetensors"
download "loras" "https://huggingface.co/Lightricks/LTX-2-19b-IC-LoRA-Detailer/resolve/main/ltx-2-19b-ic-lora-detailer.safetensors"
download "loras" "https://huggingface.co/Lightricks/LTX-2-19b-IC-LoRA-Pose-Control/resolve/main/ltx-2-19b-ic-lora-pose-control.safetensors"
download "loras" "https://huggingface.co/Lightricks/LTX-2-19b-LoRA-Camera-Control-Static/resolve/main/ltx-2-19b-lora-camera-control-static.safetensors"
download "loras" "https://huggingface.co/FastVideo/LTX2-Distilled-LoRA/resolve/main/ltx-2-19b-distilled-lora-384.safetensors"
download "upscale_models" "https://huggingface.co/Lightricks/LTX-2.3/resolve/main/ltx-2.3-spatial-upscaler-x2-1.0.safetensors"
download "upscale_models" "https://huggingface.co/Lightricks/LTX-2.3/resolve/main/ltx-2.3-spatial-upscaler-x2-1.1.safetensors"
download "upscale_models" "https://huggingface.co/Lightricks/LTX-2.3/resolve/main/ltx-2.3-temporal-upscaler-x2-1.0.safetensors"
download "audio_models/MelBandRoFormer_comfy" "https://huggingface.co/Kijai/MelBandRoFormer_comfy/resolve/main/MelBandRoformer_fp16.safetensors"

printf '\nUnresolved files not included in this script:\n'
printf '  - moodyWildMix_v20BASE45STEPS.safetensors\n'
printf '  - moodyPornMix_zitV10DPO.safetensors\n'
printf '  - ltx-2-19b-dev-fp8.safetensors\n'
printf '  - ltx-2.3-22b-distilled-lora-dynamic_fro09_avg_rank_105_bf16.safetensors\n'
printf '  - ltx-2-19b-distilled-lora_resized_dynamic_fro09_avg_rank_175_bf16.safetensors\n'
printf '  - ltx-av-step-1751000_vocoder_24K.safetensors\n'
