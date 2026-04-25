# Workflow Model Download Links

This file maps model files referenced by the current workflow JSON files in `workflows/` to public download URLs.

Notes:
- These are based on the actual selected workflow values, not every dropdown option embedded in ComfyUI JSON.
- Some files have only a closest upstream match rather than an exact filename match.
- Some models could not be resolved to a trustworthy direct file URL.

## Qwen Image Edit

| Filename | Target folder | URL | Host | Note |
| --- | --- | --- | --- | --- |
| `qwen_2.5_vl_7b_fp8_scaled.safetensors` | `text_encoders/` | `https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors` | Hugging Face | Exact match |
| `qwen_image_vae.safetensors` | `vae/` | `https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/vae/qwen_image_vae.safetensors` | Hugging Face | Exact match |
| `Qwen-Image-Edit-Lightning-4steps-V1.0-bf16.safetensors` | `loras/` | `https://huggingface.co/lightx2v/Qwen-Image-Lightning/resolve/main/Qwen-Image-Edit-Lightning-4steps-V1.0-bf16.safetensors` | Hugging Face | Exact match |
| `qwen_image_edit_fp8_e4m3fn.safetensors` | `diffusion_models/` | `https://huggingface.co/Comfy-Org/Qwen-Image-Edit_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_edit_fp8_e4m3fn.safetensors` | Hugging Face | Exact match |

## Moody / ZIB / ZIT

| Filename | Target folder | URL | Host | Note |
| --- | --- | --- | --- | --- |
| `qwen_3_4b.safetensors` | `text_encoders/` | `https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/text_encoders/qwen_3_4b.safetensors` | Hugging Face | Exact match |
| `ae.safetensors` | `vae/` | `https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/vae/ae.safetensors` | Hugging Face | Exact match |
| `sam_vit_b_01ec64.pth` | `sams/` | `https://dl.fbaipublicfiles.com/segment_anything/sam_vit_b_01ec64.pth` | Meta | Exact match |
| `ema_vae_fp16.safetensors` | `seedvr2/` | `https://huggingface.co/ByteDance-Seed/SeedVR2-7B/resolve/main/ema_vae.pth` | Hugging Face | Closest upstream match; filename differs |
| `seedvr2_ema_7b_sharp_fp16.safetensors` | `seedvr2/` | `https://huggingface.co/ByteDance-Seed/SeedVR2-7B/resolve/main/seedvr2_ema_7b_sharp.pth` | Hugging Face | Closest upstream match; filename differs |
| `4x-UltraSharp.pth` | `upscale_models/` | `https://mega.nz/folder/qZRBmaIY#nIG8KyWFcGNTuMX_XNbJ_g` | Mega | Public page, not a raw single-file URL |
| `1xSkinContrast-High-SuperUltraCompact.pth` | `upscale_models/` | `https://www.mediafire.com/file/hnvatglitgayunh/1xSkinContrast-SuperUltraCompact.pth/file` | MediaFire | Closest public match; filename omits `High` |

### Unresolved Moody / ZIB / ZIT

| Filename | Likely source | Note |
| --- | --- | --- |
| `moodyWildMix_v20BASE45STEPS.safetensors` | `https://civitai.com/models/2384856/moody-wild-mix` | No trustworthy direct file URL found |
| `moodyPornMix_zitV10DPO.safetensors` | `https://civitai.com/models/620406/moody-porn-mix` | No trustworthy direct file URL found |

## LTX

| Filename | Target folder | URL | Host | Note |
| --- | --- | --- | --- | --- |
| `google_gemma-3-12b-it-qat-Q6_K.gguf` | `text_encoders/` | `https://huggingface.co/bartowski/google_gemma-3-12b-it-qat-GGUF/resolve/main/google_gemma-3-12b-it-qat-Q6_K.gguf` | Hugging Face | Exact match |
| `gemma-3-12b-it-heretic-Q8_0.gguf` | `text_encoders/` | `https://huggingface.co/mradermacher/gemma-3-12b-it-heretic-GGUF/resolve/main/gemma-3-12b-it-heretic.Q8_0.gguf` | Hugging Face | Close match; punctuation differs |
| `gemma_3_12B_it_fp4_mixed.safetensors` | `text_encoders/` | `https://huggingface.co/Comfy-Org/ltx-2/resolve/main/split_files/text_encoders/gemma_3_12B_it_fp4_mixed.safetensors` | Hugging Face | Exact match |
| `gemma_3_12B_it_fpmixed.safetensors` | `text_encoders/` | `https://huggingface.co/Comfy-Org/ltx-2/resolve/main/split_files/text_encoders/gemma_3_12B_it_fpmixed.safetensors` | Hugging Face | Exact match |
| `gemma_3_12B_it_fp8_e4m3fn.safetensors` | `text_encoders/` | `https://huggingface.co/GitMylo/LTX-2-comfy_gemma_fp8_e4m3fn/resolve/main/gemma_3_12B_it_fp8_e4m3fn.safetensors` | Hugging Face | Community rehost |
| `ltx-2.3_text_projection_bf16.safetensors` | `text_encoders/` | `https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/text_encoders/ltx-2.3_text_projection_bf16.safetensors` | Hugging Face | Exact match |
| `ltx-2-19b-embeddings_connector_dev_bf16.safetensors` | `text_encoders/` | `https://huggingface.co/Kijai/LTXV2_comfy/resolve/main/text_encoders/ltx-2-19b-embeddings_connector_dev_bf16.safetensors` | Hugging Face | Exact match |
| `ltx-2-19b-embeddings_connector_bf16.safetensors` | `text_encoders/` | `https://huggingface.co/Kijai/LTXV2_comfy/resolve/main/text_encoders/ltx-2-19b-embeddings_connector_distill_bf16.safetensors` | Hugging Face | Closest renamed match |
| `LTX23_video_vae_bf16.safetensors` | `vae/` | `https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/vae/LTX23_video_vae_bf16.safetensors` | Hugging Face | Exact match |
| `LTX23_audio_vae_bf16.safetensors` | `vae/` | `https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/vae/LTX23_audio_vae_bf16.safetensors` | Hugging Face | Exact match |
| `LTX2_video_vae_bf16.safetensors` | `VAE/` | `https://huggingface.co/Kijai/LTXV2_comfy/resolve/main/VAE/LTX2_video_vae_bf16.safetensors` | Hugging Face | Exact match |
| `LTX2_audio_vae_bf16.safetensors` | `VAE/` | `https://huggingface.co/Kijai/LTXV2_comfy/resolve/main/VAE/LTX2_audio_vae_bf16.safetensors` | Hugging Face | Exact match |
| `taeltx2_3.safetensors` | `vae/` | `https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/vae/taeltx2_3.safetensors` | Hugging Face | Exact match |
| `ltx-2.3-spatial-upscaler-x2-1.0.safetensors` | `upscale_models/` | `https://huggingface.co/Lightricks/LTX-2.3/resolve/main/ltx-2.3-spatial-upscaler-x2-1.0.safetensors` | Hugging Face | Exact match |
| `ltx-2.3-spatial-upscaler-x2-1.1.safetensors` | `upscale_models/` | `https://huggingface.co/Lightricks/LTX-2.3/resolve/main/ltx-2.3-spatial-upscaler-x2-1.1.safetensors` | Hugging Face | Exact match |
| `ltx-2.3-temporal-upscaler-x2-1.0.safetensors` | `upscale_models/` | `https://huggingface.co/Lightricks/LTX-2.3/resolve/main/ltx-2.3-temporal-upscaler-x2-1.0.safetensors` | Hugging Face | Exact match |
| `ltx-2.3-22b-dev-fp8.safetensors` | `checkpoints/` | `https://huggingface.co/Lightricks/LTX-2.3-fp8/resolve/main/ltx-2.3-22b-dev-fp8.safetensors` | Hugging Face | Exact match |
| `ltx-2.3-22b-dev_transformer_only_bf16.safetensors` | `diffusion_models/` | `https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/diffusion_models/ltx-2.3-22b-dev_transformer_only_bf16.safetensors` | Hugging Face | Exact match |
| `ltx-2-3-22b-dev_transformer_only_fp8_input_scaled.safetensors` | `diffusion_models/` | `https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/diffusion_models/ltx-2-3-22b-dev_transformer_only_fp8_input_scaled.safetensors` | Hugging Face | Exact match |
| `ltx-2.3-22b-distilled_transformer_only_fp8_input_scaled.safetensors` | `diffusion_models/` | `https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/diffusion_models/ltx-2.3-22b-distilled_transformer_only_fp8_input_scaled.safetensors` | Hugging Face | Exact match |
| `ltx-2.3-22b-distilled_transformer_only_fp8_input_scaled_v3.safetensors` | `diffusion_models/` | `https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/diffusion_models/ltx-2.3-22b-distilled_transformer_only_fp8_input_scaled_v3.safetensors` | Hugging Face | Exact match |
| `ltx-2-19b-dev-fp8_transformer_only.safetensors` | `diffusion_models/` | `https://huggingface.co/Kijai/LTXV2_comfy/resolve/main/diffusion_models/ltx-2-19b-dev-fp8_transformer_only.safetensors` | Hugging Face | Exact match |
| `LTX-2-Image2Vid-Adapter.safetensors` | `loras/` | `https://huggingface.co/MachineDelusions/LTX-2_Image2Video_Adapter_LoRa/resolve/main/LTX-2-Image2Vid-Adapter.safetensors` | Hugging Face | Exact match |
| `ltx-2-19b-ic-lora-detailer.safetensors` | `loras/` | `https://huggingface.co/Lightricks/LTX-2-19b-IC-LoRA-Detailer/resolve/main/ltx-2-19b-ic-lora-detailer.safetensors` | Hugging Face | Exact match |
| `ltx-2-19b-ic-lora-pose-control.safetensors` | `loras/` | `https://huggingface.co/Lightricks/LTX-2-19b-IC-LoRA-Pose-Control/resolve/main/ltx-2-19b-ic-lora-pose-control.safetensors` | Hugging Face | Exact match |
| `ltx-2-19b-lora-camera-control-static.safetensors` | `loras/` | `https://huggingface.co/Lightricks/LTX-2-19b-LoRA-Camera-Control-Static/resolve/main/ltx-2-19b-lora-camera-control-static.safetensors` | Hugging Face | Exact match |
| `ltx-2-19b-distilled-lora-384.safetensors` | `loras/` | `https://huggingface.co/FastVideo/LTX2-Distilled-LoRA/resolve/main/ltx-2-19b-distilled-lora-384.safetensors` | Hugging Face | Community rehost |
| `ltx-2-3-22b-dev-Q4_K_M.gguf` | `diffusion_models/` | `https://huggingface.co/unsloth/LTX-2.3-GGUF/resolve/main/ltx-2.3-22b-dev-Q4_K_M.gguf` | Hugging Face | Workflow uses `2-3`; public file uses `2.3` |
| `ltx-2.3-22b-distilled-Q6_K.gguf` | `diffusion_models/` | `https://huggingface.co/unsloth/LTX-2.3-GGUF/resolve/main/distilled/ltx-2.3-22b-distilled-Q6_K.gguf` | Hugging Face | Exact match |
| `LTX-2.3-distilled-Q4_K_S.gguf` | `diffusion_models/` | `https://huggingface.co/QuantStack/LTX-2.3-GGUF/resolve/main/LTX-2.3-distilled/LTX-2.3-distilled-Q4_K_S.gguf` | Hugging Face | Exact match |
| `LTX-2.3-distilled-Q4_K_M.gguf` | `diffusion_models/` | `https://huggingface.co/QuantStack/LTX-2.3-GGUF/resolve/main/LTX-2.3-distilled/LTX-2.3-distilled-Q4_K_M.gguf` | Hugging Face | Exact match |
| `MelBandRoFormer_comfy/MelBandRoformer_fp16.safetensors` | `audio_models/` | `https://huggingface.co/Kijai/MelBandRoFormer_comfy/resolve/main/MelBandRoformer_fp16.safetensors` | Hugging Face | Verified working direct download |

### Unresolved LTX

| Filename | Note |
| --- | --- |
| `ltx-2-19b-dev-fp8.safetensors` | No trustworthy exact file URL found |
| `ltx-2.3-22b-distilled-lora-dynamic_fro09_avg_rank_105_bf16.safetensors` | No trustworthy exact file URL found |
| `ltx-2-19b-distilled-lora_resized_dynamic_fro09_avg_rank_175_bf16.safetensors` | No trustworthy exact file URL found |
| `ltx-av-step-1751000_vocoder_24K.safetensors` | No trustworthy exact file URL found |
