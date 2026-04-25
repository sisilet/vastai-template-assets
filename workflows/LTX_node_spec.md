# LTX Video Workflows — Node Configuration Spec

> 92 unique node types across 12 packages. Extracted from 19 LTX workflow JSON files.
> LTX Video uses 128-channel latents with 32× spatial and 8× temporal compression.
> CFG=1 is standard (LTX is trained for low/no classifier-free guidance).

---

## Package Summary

| Package | Repository | Node Count |
|---------|-----------|------------|
| comfy-core | https://github.com/comfyanonymous/ComfyUI | 55 |
| comfyui-kjnodes | https://github.com/kijai/ComfyUI-KJNodes | 21 |
| ComfyUI-LTXVideo (ltxv) | https://github.com/Lightricks/ComfyUI-LTXVideo | 3 |
| ComfyUI-GGUF | https://github.com/city96/ComfyUI-GGUF | 2 |
| comfyui-videohelpersuite | https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite | 3 |
| ComfyUI-MelBandRoFormer | https://github.com/KoreTeknique/ComfyUI-MelBandRoFormer | 2 |
| WhatDreamsCost-ComfyUI | https://github.com/WhatDreamsCost/ComfyUI-WhatDreamsCost | 2 |
| ComfyUI-WanVideoWrapper | https://github.com/kijai/ComfyUI-WanVideoWrapper | 1 |
| comfyui-logic | https://github.com/thecooltechguy/ComfyUI-Logic | 1 |
| audio-separation-nodes-comfyui | https://github.com/DimaChaworski/audio-separation-nodes-comfyui | 1 |
| ComfyUI-Easy-Use | https://github.com/yolain/ComfyUI-Easy-Use | 1 |
| comfyui-rtx-simple | https://github.com/BetaDoggo/comfyui-rtx-simple | 1 |

---

## Node → Package Quick Reference

| Node | Package |
|------|---------|
| AudioConcat | comfy-core |
| BasicScheduler | comfy-core |
| CFGGuider | comfy-core |
| CheckpointLoaderSimple | comfy-core |
| ComfyMathExpression | comfy-core |
| CreateVideo | comfy-core |
| DualCLIPLoader | comfy-core |
| EmptyImage | comfy-core |
| EmptyLTXVLatentVideo | comfy-core |
| FeatherMask | comfy-core |
| ImageScale | comfy-core |
| ImageScaleBy | comfy-core |
| KSampler | comfy-core |
| KSamplerSelect | comfy-core |
| LatentComposite | comfy-core |
| LatentUpscaleModelLoader | comfy-core |
| LoadAudio | comfy-core |
| LoadImage | comfy-core |
| LoraLoaderModelOnly | comfy-core |
| LTXVAddGuide | comfy-core |
| LTXVAudioVAEDecode | comfy-core |
| LTXVAudioVAEEncode | comfy-core |
| LTXVAudioVAELoader | comfy-core |
| LTXVConcatAVLatent | comfy-core |
| LTXVConditioning | comfy-core |
| LTXVCropGuides | comfy-core |
| LTXVEmptyLatentAudio | comfy-core |
| LTXVImgToVideoInplace | comfy-core |
| LTXVLatentUpsampler | comfy-core |
| LTXVPreprocess | comfy-core |
| LTXVScheduler | comfy-core |
| LTXVSeparateAVLatent | comfy-core |
| ManualSigmas | comfy-core |
| MaskComposite | comfy-core |
| ModelSamplingSD3 | comfy-core |
| PreviewAny | comfy-core |
| PreviewAudio | comfy-core |
| PrimitiveBoolean | comfy-core |
| PrimitiveFloat | comfy-core |
| PrimitiveInt | comfy-core |
| PrimitiveStringMultiline | comfy-core |
| RandomNoise | comfy-core |
| ResizeImageMaskNode | comfy-core |
| ResizeImagesByLongerEdge | comfy-core |
| SamplerCustomAdvanced | comfy-core |
| SaveVideo | comfy-core |
| SetLatentNoiseMask | comfy-core |
| SolidMask | comfy-core |
| TextGenerateLTX2Prompt | comfy-core |
| TorchCompileModel | comfy-core |
| TrimAudio | comfy-core |
| TrimAudioDuration | comfy-core |
| VAEDecodeTiled | comfy-core |
| VAEEncodeTiled | comfy-core |
| GetImage¹ | comfy-core |
| GetImageRangeFromBatch | comfyui-kjnodes |
| GetImageSizeAndCount | comfyui-kjnodes |
| ImageBatchExtendWithOverlap | comfyui-kjnodes |
| ImageBatchMulti | comfyui-kjnodes |
| ImageResizeKJv2 | comfyui-kjnodes |
| INTConstant | comfyui-kjnodes |
| LazySwitchKJ | comfyui-kjnodes |
| LTX2AttentionTunerPatch | comfyui-kjnodes |
| LTX2AudioLatentNormalizingSampling | comfyui-kjnodes |
| LTX2MemoryEfficientSageAttentionPatch | comfyui-kjnodes |
| LTX2SamplingPreviewOverride | comfyui-kjnodes |
| LTX2_NAG | comfyui-kjnodes |
| LTXVAddGuideMulti | comfyui-kjnodes |
| LTXVAudioVideoMask | comfyui-kjnodes |
| LTXVChunkFeedForward | comfyui-kjnodes |
| LTXVImgToVideoInplaceKJ | comfyui-kjnodes |
| PathchSageAttentionKJ | comfyui-kjnodes |
| SimpleCalculatorKJ | comfyui-kjnodes |
| VAELoaderKJ | comfyui-kjnodes |
| VisualizeSigmasKJ | comfyui-kjnodes |
| GuiderParameters | ComfyUI-LTXVideo |
| LTXVSpatioTemporalTiledVAEDecode | ComfyUI-LTXVideo |
| MultimodalGuider | ComfyUI-LTXVideo |
| DualCLIPLoaderGGUF | ComfyUI-GGUF |
| UnetLoaderGGUF | ComfyUI-GGUF |
| VHS_LoadVideo | comfyui-videohelpersuite |
| VHS_VideoCombine | comfyui-videohelpersuite |
| VHS_VideoInfo | comfyui-videohelpersuite |
| MelBandRoFormerModelLoader | ComfyUI-MelBandRoFormer |
| MelBandRoFormerSampler | ComfyUI-MelBandRoFormer |
| LTXSequencer | WhatDreamsCost-ComfyUI |
| MultiImageLoader | WhatDreamsCost-ComfyUI |
| NormalizeAudioLoudness | ComfyUI-WanVideoWrapper |
| Float | comfyui-logic |
| AudioCrop | audio-separation-nodes-comfyui |
| easy showAnything | ComfyUI-Easy-Use |
| RTXVideoSuperResolution | comfyui-rtx-simple |

> ¹ GetImage source unconfirmed — likely comfy-core or a deprecated custom node

---

## Workflow Architecture (LTX 2.3 Typical Pipeline)

```
[DualCLIPLoader / DualCLIPLoaderGGUF] ──→ CLIP ──→ [CLIPTextEncode] ──→ CONDITIONING
                                                                             │
[UnetLoaderGGUF / CheckpointLoaderSimple] ──→ MODEL ──→ [LoraLoaderModelOnly] ──→ MODEL
     │                                                                              │
     │    [LTXVConditioning] ←── positive + negative + frame_rate                   │
     │           │                                                                  │
     │    [CFGGuider] ←── model + conditioning + cfg                                │
     │           │                                                                  │
     │    [SamplerCustomAdvanced] ←── guider + sampler + sigmas + latent             │
     │           │                                                                  │
     │    [VAEDecodeTiled] ──→ IMAGE ──→ [SaveVideo / CreateVideo]                  │
     │                                                                              │
[EmptyLTXVLatentVideo] ──→ LATENT ──→ [LTXVImgToVideoInplace] ──→ LATENT           │
                                           ↑                                        │
                                    [LoadImage + LTXVPreprocess]                    │
                                                                                    │
[KSamplerSelect] ──→ SAMPLER ──────────────────────────────────────────────────────→│
[RandomNoise] ──→ NOISE ──────────────────────────────────────────────────────────→│
[ManualSigmas / LTXVScheduler / BasicScheduler] ──→ SIGMAS ──────────────────────→│
```

**Audio extension (LTX 2.3+):**
```
[LTXVAudioVAELoader] ──→ AudioVAE
[LoadAudio] ──→ AUDIO ──→ [LTXVAudioVAEEncode] ──→ audio_latent
[LTXVEmptyLatentAudio] ──→ empty audio latent
[LTXVConcatAVLatent] ←── video_latent + audio_latent ──→ combined latent
     ... sampling ...
[LTXVSeparateAVLatent] ──→ video_latent + audio_latent
[LTXVAudioVAEDecode] ──→ AUDIO
[CreateVideo] ←── images + audio ──→ VIDEO ──→ [SaveVideo]
```

---

# COMFY-CORE NODES (55)

---

## 1. EmptyLTXVLatentVideo

- **Source**: `comfy_extras/nodes_lt.py`
- **Purpose**: Creates an empty latent tensor for LTX Video generation. Uses 128-channel latents with 32× spatial and 8× temporal downsampling.

| Parameter | Type | Default | Range | Description |
|-----------|------|---------|-------|-------------|
| `width` | INT | 768 | 64–8192, step 32 | Output width (pixels) |
| `height` | INT | 512 | 64–8192, step 32 | Output height (pixels) |
| `length` | INT | 97 | 1–max | Number of video frames |
| `batch_size` | INT | 1 | 1–4096 | Batch size |

| Output | Type |
|--------|------|
| LATENT | LATENT |

**Workflow Values**: `width=768, height=512, length=121, batch_size=1`

---

## 2. LTXVConditioning

- **Source**: `comfy_extras/nodes_lt.py`
- **Purpose**: Wraps conditioning with LTX-specific frame rate metadata. The frame rate affects motion synthesis speed.

| Parameter | Type | Default | Range | Description |
|-----------|------|---------|-------|-------------|
| `frame_rate` | FLOAT | 25.0 | 1–120 | Target video frame rate |

| Input | Type |
|-------|------|
| positive | CONDITIONING |
| negative | CONDITIONING |

| Output | Type |
|--------|------|
| positive | CONDITIONING |
| negative | CONDITIONING |

**Workflow Values**: `frame_rate=24`

---

## 3. LTXVImgToVideoInplace

- **Source**: `comfy_extras/nodes_lt.py`
- **Purpose**: Encodes an input image and injects it into the first frame of a latent video for image-to-video generation. Sets up a noise mask so the first frame is preserved during denoising.

| Parameter | Type | Default | Range | Description |
|-----------|------|---------|-------|-------------|
| `strength` | FLOAT | 0.8 | 0.0–1.0 | Denoise strength for non-guide frames |
| `bypass` | BOOLEAN | False | | Skip this node entirely |

| Input | Type |
|-------|------|
| vae | VAE |
| image | IMAGE |
| latent | LATENT |

| Output | Type |
|--------|------|
| latent | LATENT |

**Workflow Values**: `strength=0.8, bypass=False`

---

## 4. LTXVPreprocess

- **Source**: `comfy_extras/nodes_lt.py`
- **Purpose**: Preprocesses images for LTX Video by simulating H.264 compression artifacts to match the model's training distribution. Setting `img_compression=0` disables compression simulation.

| Parameter | Type | Default | Range | Description |
|-----------|------|---------|-------|-------------|
| `img_compression` | INT | 0 | 0–100 | JPEG-like compression level (0=off) |

| Input | Type |
|-------|------|
| image | IMAGE |

| Output | Type |
|--------|------|
| output_image | IMAGE |

**Workflow Values**: `img_compression=0`

---

## 5. LTXVLatentUpsampler

- **Source**: `comfy_extras/nodes_lt.py`
- **Purpose**: Upscales latent video using a dedicated latent upscale model (2× spatial). Operates in latent space without decoding, preserving temporal coherence.

| Input | Type |
|-------|------|
| samples | LATENT |
| upscale_model | LATENT_UPSCALE_MODEL |
| vae | VAE |

| Output | Type |
|--------|------|
| LATENT | LATENT |

---

## 6. LTXVScheduler

- **Source**: `comfy_extras/nodes_lt.py`
- **Purpose**: Generates noise schedule (sigmas) adapted for LTX Video. Automatically adjusts the shift parameter based on latent token count (resolution-aware scheduling).

| Parameter | Type | Default | Range | Description |
|-----------|------|---------|-------|-------------|
| `steps` | INT | 20 | 1–1000 | Number of sampling steps |
| `max_shift` | FLOAT | 2.05 | 0.0–100 | Max schedule shift |
| `min_shift` | FLOAT | 0.95 | 0.0–100 | Min schedule shift |
| `stretch` | BOOLEAN | True | | Enable stretch scheduling |
| `terminal` | FLOAT | 0.1 | 0.0–1.0 | Terminal sigma value |

| Input | Type |
|-------|------|
| latent | LATENT |

| Output | Type |
|--------|------|
| SIGMAS | SIGMAS |

**Workflow Values**: `steps=20, max_shift=2.05, min_shift=0.95, stretch=True, terminal=0.1`

---

## 7. LTXVAddGuide

- **Source**: `comfy_extras/nodes_lt.py` (core node, not a custom pack)
- **Purpose**: Adds an image guide at a specific frame index in the LTX video. The image is VAE-encoded, concatenated to the latent with a noise mask, and keyframe indices are set for transformer attention.

| Parameter | Type | Default | Range | Description |
|-----------|------|---------|-------|-------------|
| `frame_idx` | INT | 0 | 0–max | Frame position to insert guide |
| `strength` | FLOAT | 0.5 | 0.0–1.0 | Guide influence strength |

| Input | Type |
|-------|------|
| positive | CONDITIONING |
| negative | CONDITIONING |
| vae | VAE |
| latent | LATENT |
| image | IMAGE |

| Output | Type |
|--------|------|
| positive | CONDITIONING |
| negative | CONDITIONING |
| latent | LATENT |

**Workflow Values**: `frame_idx=0, strength=0.5`

---

## 8. LTXVAddGuideMulti

- **Source**: https://github.com/kijai/ComfyUI-KJNodes (`nodes/ltxv_nodes.py`)
- **Purpose**: Like LTXVAddGuide but supports up to 5 images at different frame positions with individual strengths for multi-frame guided generation.

| Input | Type |
|-------|------|
| positive | CONDITIONING |
| negative | CONDITIONING |
| vae | VAE |
| latent | LATENT |
| image_1..5 | IMAGE (optional) |
| frame_idx_1..5 | INT |
| strength_1..5 | FLOAT |

| Output | Type |
|--------|------|
| positive | CONDITIONING |
| negative | CONDITIONING |
| latent | LATENT |

---

## 9. LTXVCropGuides

- **Source**: `comfy_extras/nodes_lt.py`
- **Purpose**: Crops/trims guide conditioning to match the current latent dimensions. Ensures guide data aligns properly after latent operations.

| Input | Type |
|-------|------|
| positive | CONDITIONING |
| negative | CONDITIONING |
| latent | LATENT |

| Output | Type |
|--------|------|
| positive | CONDITIONING |
| negative | CONDITIONING |
| latent | LATENT |

---

## 10. LTXVConcatAVLatent

- **Source**: `comfy_extras/nodes_lt.py`
- **Purpose**: Concatenates video and audio latents into a combined audio-video latent using NestedTensor for joint processing in LTX 2.3+.

| Input | Type |
|-------|------|
| video_latent | LATENT |
| audio_latent | LATENT |

| Output | Type |
|--------|------|
| latent | LATENT |

---

## 11. LTXVSeparateAVLatent

- **Source**: `comfy_extras/nodes_lt.py`
- **Purpose**: Separates a combined audio-video latent back into individual video and audio latent components after sampling.

| Input | Type |
|-------|------|
| av_latent | LATENT |

| Output | Type |
|--------|------|
| video_latent | LATENT |
| audio_latent | LATENT |

---

## 12. LTXVAudioVAEDecode

- **Source**: `comfy_extras/nodes_lt.py`
- **Purpose**: Decodes audio latents back to waveform audio using the LTX audio VAE.

| Input | Type |
|-------|------|
| samples | LATENT |
| audio_vae | VAE |

| Output | Type |
|--------|------|
| Audio | AUDIO |

---

## 13. LTXVAudioVAEEncode

- **Source**: `comfy_extras/nodes_lt.py`
- **Purpose**: Encodes raw audio waveform into latent space using the LTX audio VAE.

| Input | Type |
|-------|------|
| audio | AUDIO |
| audio_vae | VAE |

| Output | Type |
|--------|------|
| Audio Latent | LATENT |

---

## 14. LTXVAudioVAELoader

- **Source**: `comfy_extras/nodes_lt.py`
- **Purpose**: Loads the LTX audio VAE model for encoding/decoding audio latents.

| Parameter | Type | Options | Description |
|-----------|------|---------|-------------|
| `vae_name` | COMBO | Files from `models/vae_audio/` | Audio VAE model |

| Output | Type |
|--------|------|
| Audio VAE | VAE |

**Workflow Values**: `vae_name="LTX23_audio_vae_bf16.safetensors"`

---

## 15. LTXVEmptyLatentAudio

- **Source**: `comfy_extras/nodes_lt.py`
- **Purpose**: Creates an empty audio latent tensor matching the video frame count and rate for unconditional audio generation.

| Parameter | Type | Default | Range | Description |
|-----------|------|---------|-------|-------------|
| `frames_number` | INT | 97 | 1–max | Number of video frames to match |
| `frame_rate` | INT | 25 | 1–120 | Video frame rate |
| `batch_size` | INT | 1 | 1–4096 | Batch size |

| Input | Type |
|-------|------|
| audio_vae | VAE |

| Output | Type |
|--------|------|
| Latent | LATENT |

**Workflow Values**: `frames_number=97, frame_rate=25, batch_size=1`

---

## 16. LatentUpscaleModelLoader

- **Source**: `comfy_extras/nodes_lt.py`
- **Purpose**: Loads a latent upscale model (e.g., the LTX 2× spatial upscaler) for use with LTXVLatentUpsampler.

| Parameter | Type | Options | Description |
|-----------|------|---------|-------------|
| `model_name` | COMBO | Files from `models/latent_upscale/` | Upscale model file |

| Output | Type |
|--------|------|
| LATENT_UPSCALE_MODEL | LATENT_UPSCALE_MODEL |

**Workflow Values**: `model_name="ltx-2.3-spatial-upscaler-x2-1.0.safetensors"`

---

## 17. SamplerCustomAdvanced

- **Source**: `comfy_extras/nodes_custom_sampler.py`
- **Purpose**: Advanced sampler with explicit noise, guider, sampler, and sigma inputs. The standard sampling node for LTX workflows — provides full control over the denoising pipeline.

| Input | Type |
|-------|------|
| noise | NOISE |
| guider | GUIDER |
| sampler | SAMPLER |
| sigmas | SIGMAS |
| latent_image | LATENT |

| Output | Type |
|--------|------|
| output | LATENT |
| denoised_output | LATENT |

---

## 18. CFGGuider

- **Source**: `comfy_extras/nodes_custom_sampler.py`
- **Purpose**: Creates a classifier-free guidance guider. LTX Video typically uses cfg=1.0 (no guidance) as the model is trained for low CFG.

| Parameter | Type | Default | Range | Description |
|-----------|------|---------|-------|-------------|
| `cfg` | FLOAT | 1.0 | 0.0–100 | CFG scale (1.0 = no guidance) |

| Input | Type |
|-------|------|
| model | MODEL |
| positive | CONDITIONING |
| negative | CONDITIONING |

| Output | Type |
|--------|------|
| GUIDER | GUIDER |

**Workflow Values**: `cfg=1`

---

## 19. KSamplerSelect

- **Source**: `comfy_extras/nodes_custom_sampler.py`
- **Purpose**: Selects the sampling algorithm to use.

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| `sampler_name` | COMBO | euler | euler, euler_ancestral, heun, dpm_2, dpm_2_ancestral, lms, dpm_fast, dpm_adaptive, dpmpp_2s_ancestral, dpmpp_sde, dpmpp_2m, dpmpp_2m_sde, dpmpp_3m_sde, ddpm, lcm, uni_pc, uni_pc_bh2 | Sampler algorithm |

| Output | Type |
|--------|------|
| SAMPLER | SAMPLER |

**Workflow Values**: `sampler_name="euler"`

---

## 20. RandomNoise

- **Source**: `comfy_extras/nodes_custom_sampler.py`
- **Purpose**: Generates random noise with a given seed for reproducible sampling.

| Parameter | Type | Default | Range | Description |
|-----------|------|---------|-------|-------------|
| `noise_seed` | INT | 0 | 0–2⁶⁴ | Random seed (often "randomize" control) |

| Output | Type |
|--------|------|
| NOISE | NOISE |

---

## 21. ManualSigmas

- **Source**: `comfy_extras/nodes_custom_sampler.py`
- **Purpose**: Allows manually specifying the exact sigma schedule as a comma-separated string. Provides full control over noise levels at each step.

| Parameter | Type | Description |
|-----------|------|-------------|
| `sigmas` | STRING | Comma-separated sigma values (descending) |

| Output | Type |
|--------|------|
| SIGMAS | SIGMAS |

**Workflow Values**: `"1., 0.99375, 0.9875, 0.98125, 0.975, 0.909375, 0.725, 0.4218"`

---

## 22. BasicScheduler

- **Source**: `comfy_extras/nodes_custom_sampler.py`
- **Purpose**: Generates a standard noise schedule from a model. Simpler alternative to LTXVScheduler when resolution-aware shifting isn't needed.

| Parameter | Type | Default | Range | Description |
|-----------|------|---------|-------|-------------|
| `scheduler` | COMBO | normal | normal, karras, exponential, sgm_uniform, simple, ddim_uniform, beta, linear_quadratic | Schedule type |
| `steps` | INT | 20 | 1–10000 | Number of steps |
| `denoise` | FLOAT | 1.0 | 0.0–1.0 | Denoise strength |

| Input | Type |
|-------|------|
| model | MODEL |

| Output | Type |
|--------|------|
| SIGMAS | SIGMAS |

**Workflow Values**: `scheduler="linear_quadratic", steps=16, denoise=1`

---

## 23. DualCLIPLoader

- **Source**: `comfy_extras/nodes_clip.py`
- **Purpose**: Loads two CLIP models simultaneously (e.g., Gemma + LTX text projection for LTX Video).

| Parameter | Type | Options | Description |
|-----------|------|---------|-------------|
| `clip_name1` | COMBO | Models in `text_encoders/` | Primary CLIP (e.g., Gemma) |
| `clip_name2` | COMBO | Models in `text_encoders/` | Secondary CLIP (e.g., LTX text projection) |
| `type` | COMBO | sdxl, sd3, flux, hunyuan_video, ltxv, cosmos | Architecture type |
| `device` | COMBO | default, cpu | Load device |

| Output | Type |
|--------|------|
| CLIP | CLIP |

**Workflow Values**: `clip_name1="gemma_3_12B_it_fp4_mixed.safetensors", clip_name2="ltx-2.3_text_projection_bf16.safetensors", type="ltxv", device="default"`

---

## 24. CheckpointLoaderSimple

- **Source**: `nodes.py`
- **Purpose**: Loads a complete checkpoint (model + CLIP + VAE) in one step.

| Parameter | Type | Options | Description |
|-----------|------|---------|-------------|
| `ckpt_name` | COMBO | Files from `models/checkpoints/` | Checkpoint file |

| Output | Type |
|--------|------|
| MODEL | MODEL |
| CLIP | CLIP |
| VAE | VAE |

**Workflow Values**: `ckpt_name="ltx-2-19b-dev-fp8.safetensors"`

---

## 25. LoadImage

- **Source**: `nodes.py`
- **Purpose**: Loads an image from disk for use as input (e.g., for image-to-video).

| Parameter | Type | Description |
|-----------|------|-------------|
| `image` | COMBO | Image file from input directory |

| Output | Type |
|--------|------|
| IMAGE | IMAGE |
| MASK | MASK |

---

## 26. LoadAudio

- **Source**: `comfy_extras/nodes_audio.py`
- **Purpose**: Loads an audio file for audio-conditioned video generation.

| Parameter | Type | Description |
|-----------|------|-------------|
| `audio` | COMBO | Audio file from input directory |

| Output | Type |
|--------|------|
| AUDIO | AUDIO |

---

## 27. LoraLoaderModelOnly

- **Source**: `nodes.py`
- **Purpose**: Loads a LoRA adapter and merges it into a model (model-only, no CLIP modification).

| Parameter | Type | Default | Range | Description |
|-----------|------|---------|-------|-------------|
| `lora_name` | COMBO | | Files from `models/loras/` | LoRA file |
| `strength_model` | FLOAT | 1.0 | -100–100 | LoRA weight strength |

| Input | Type |
|-------|------|
| model | MODEL |

| Output | Type |
|--------|------|
| MODEL | MODEL |

**Workflow Values**: `lora_name="LTX-2/LTX-2-Image2Vid-Adapter.safetensors", strength_model=1`

---

## 28. CreateVideo

- **Source**: `comfy_extras/nodes_video.py`
- **Purpose**: Combines image frames and optional audio into a VIDEO object.

| Parameter | Type | Default | Range | Description |
|-----------|------|---------|-------|-------------|
| `fps` | FLOAT | 30 | 1–120 | Output frame rate |

| Input | Type |
|-------|------|
| images | IMAGE |
| audio | AUDIO (optional) |

| Output | Type |
|--------|------|
| VIDEO | VIDEO |

**Workflow Values**: `fps=30`

---

## 29. SaveVideo

- **Source**: `comfy_extras/nodes_video.py`
- **Purpose**: Saves a VIDEO object to disk as a video file.

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| `filename_prefix` | STRING | "video/ComfyUI" | | Output path prefix |
| `format` | COMBO | mp4 | mp4, webm, mkv | Container format |
| `codec` | COMBO | auto | auto, h264, h265, vp9, av1 | Video codec |

| Input | Type |
|-------|------|
| video | VIDEO |

**Workflow Values**: `filename_prefix="video/LTX-2", format="mp4", codec="auto"`

---

## 30. VAEDecodeTiled

- **Source**: `nodes.py`
- **Purpose**: Decodes latents to images using tiled processing to reduce VRAM usage. Critical for large LTX video generation.

| Parameter | Type | Default | Range | Description |
|-----------|------|---------|-------|-------------|
| `tile_size` | INT | 512 | 64–4096 | Spatial tile size |
| `overlap` | INT | 64 | 0–4096 | Spatial overlap |
| `temporal_size` | INT | 64 | 1–4096 | Temporal tile size |
| `temporal_overlap` | INT | 8 | 0–4096 | Temporal overlap |

| Input | Type |
|-------|------|
| samples | LATENT |
| vae | VAE |

| Output | Type |
|--------|------|
| IMAGE | IMAGE |

**Workflow Values**: `tile_size=512, overlap=64, temporal_size=2048, temporal_overlap=8`

---

## 31. VAEEncodeTiled

- **Source**: `nodes.py`
- **Purpose**: Encodes images to latents using tiled processing for VRAM efficiency.

| Parameter | Type | Default | Range | Description |
|-----------|------|---------|-------|-------------|
| `tile_size` | INT | 512 | 64–4096 | Spatial tile size |
| `overlap` | INT | 64 | 0–4096 | Spatial overlap |
| `temporal_size` | INT | 64 | 1–4096 | Temporal tile size |
| `temporal_overlap` | INT | 8 | 0–4096 | Temporal overlap |

| Input | Type |
|-------|------|
| pixels | IMAGE |
| vae | VAE |

| Output | Type |
|--------|------|
| LATENT | LATENT |

**Workflow Values**: `tile_size=512, overlap=64, temporal_size=4096, temporal_overlap=8`

---

## 32. ImageScaleBy

- **Source**: `nodes.py`
- **Purpose**: Scales image by a multiplier factor.

| Parameter | Type | Default | Options/Range | Description |
|-----------|------|---------|---------------|-------------|
| `upscale_method` | COMBO | nearest-exact | nearest-exact, bilinear, area, bicubic, lanczos | Interpolation method |
| `scale_by` | FLOAT | 1.0 | 0.01–8.0 | Scale multiplier |

| Input | Type |
|-------|------|
| image | IMAGE |

| Output | Type |
|--------|------|
| IMAGE | IMAGE |

**Workflow Values**: `upscale_method="lanczos", scale_by=0.5`

---

## 33. EmptyImage

- **Source**: `nodes.py`
- **Purpose**: Creates a blank solid-color image tensor.

| Parameter | Type | Default | Range | Description |
|-----------|------|---------|-------|-------------|
| `width` | INT | 512 | 1–max | Image width |
| `height` | INT | 512 | 1–max | Image height |
| `batch_size` | INT | 1 | 1–4096 | Batch size |
| `color` | INT | 0 | 0–0xFFFFFF | Fill color (hex RGB) |

| Output | Type |
|--------|------|
| IMAGE | IMAGE |

**Workflow Values**: `width=960, height=704, batch_size=1, color=0`

---

## 34. ResizeImagesByLongerEdge

- **Source**: `comfy_extras/nodes_images.py` (alias: ImageScaleToMaxDimension)
- **Purpose**: Scales images so the longer edge matches the target, maintaining aspect ratio.

| Parameter | Type | Default | Range | Description |
|-----------|------|---------|-------|-------------|
| `longer_edge` | INT | 1024 | 1–max | Target longer edge in pixels |

| Input | Type |
|-------|------|
| images | IMAGE |

| Output | Type |
|--------|------|
| images | IMAGE |

**Workflow Values**: `longer_edge=1536`

---

## 35. ResizeImageMaskNode

- **Source**: `comfy_extras/nodes_images.py`
- **Purpose**: Resizes images or masks with flexible scaling modes.

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| `resize_type` | COMBO | | scale dimensions, scale by multiplier | Resize mode |
| `width` | INT | 1920 | | Target width |
| `height` | INT | 1088 | | Target height |
| `position` | COMBO | center | center, top-left, etc. | Anchor position |
| `scale_method` | COMBO | lanczos | nearest, bilinear, bicubic, lanczos | Interpolation |

| Input | Type |
|-------|------|
| input | IMAGE or MASK |

| Output | Type |
|--------|------|
| resized | IMAGE or MASK |

**Workflow Values**: `resize_type="scale dimensions", width=1920, height=1088, position="center", scale_method="lanczos"`

---

## 36. SetLatentNoiseMask

- **Source**: `nodes.py`
- **Purpose**: Applies a mask to a latent to control which regions get denoised. Used in inpainting and video extension workflows.

| Input | Type |
|-------|------|
| samples | LATENT |
| mask | MASK |

| Output | Type |
|--------|------|
| LATENT | LATENT |

---

## 37. SolidMask

- **Source**: `comfy_extras/nodes_mask.py`
- **Purpose**: Creates a solid mask of a given value and dimensions.

| Parameter | Type | Default | Range | Description |
|-----------|------|---------|-------|-------------|
| `value` | FLOAT | 1.0 | 0.0–1.0 | Mask value |
| `width` | INT | 512 | 1–max | Mask width |
| `height` | INT | 512 | 1–max | Mask height |

| Output | Type |
|--------|------|
| MASK | MASK |

**Workflow Values**: `value=0, width=512, height=512`

---

## 38. ModelSamplingSD3

- **Source**: `comfy_extras/nodes_model_advanced.py`
- **Purpose**: Overrides the model's noise schedule shift parameter. Used to fine-tune the noise schedule for specific resolutions.

| Parameter | Type | Default | Range | Description |
|-----------|------|---------|-------|-------------|
| `shift` | FLOAT | 3.0 | 0.0–100 | Schedule shift value |

| Input | Type |
|-------|------|
| model | MODEL |

| Output | Type |
|--------|------|
| MODEL | MODEL |

**Workflow Values**: `shift=13`

---

## 39. ComfyMathExpression

- **Source**: Built-in (`comfy_extras/nodes_math.py`)
- **Purpose**: Evaluates a math expression with variables a, b. Used extensively for dynamic resolution/frame calculations.

| Parameter | Type | Description |
|-----------|------|-------------|
| `expression` | STRING | Math expression using variables a, b (e.g., `a * 2`, `1+ 8*(round(a*b)/8)`) |

| Input | Type |
|-------|------|
| values.a | FLOAT/INT |
| values.b | FLOAT/INT (optional) |

| Output | Type |
|--------|------|
| FLOAT | FLOAT |
| INT | INT |

**Workflow Values**: Various expressions like `"a * 2"`, `"1+ 8*(round(a*b)/8)"`

---

## 40. KSampler

- **Source**: `nodes.py`
- **Purpose**: Standard sampler node — simpler alternative to SamplerCustomAdvanced with all-in-one interface.

| Parameter | Type | Default | Options/Range | Description |
|-----------|------|---------|---------------|-------------|
| `seed` | INT | 0 | 0–2⁶⁴ | Random seed |
| `steps` | INT | 20 | 1–10000 | Sampling steps |
| `cfg` | FLOAT | 8.0 | 0.0–100 | CFG scale |
| `sampler_name` | COMBO | euler | All samplers | Sampler algorithm |
| `scheduler` | COMBO | normal | All schedulers | Noise schedule |
| `denoise` | FLOAT | 1.0 | 0.0–1.0 | Denoise strength |

| Input | Type |
|-------|------|
| model | MODEL |
| positive | CONDITIONING |
| negative | CONDITIONING |
| latent_image | LATENT |

| Output | Type |
|--------|------|
| LATENT | LATENT |

---

## 41–42. Primitive Nodes

### PrimitiveInt
- **Purpose**: Outputs a constant integer value. Used for resolution, frame count, etc.
- **Widget**: `value` (INT) — **Workflow Values**: various (e.g., 1920, 1088, 121)

### PrimitiveFloat
- **Purpose**: Outputs a constant float value.
- **Widget**: `value` (FLOAT) — **Workflow Values**: various

### PrimitiveBoolean
- **Purpose**: Outputs a constant boolean value. Often used as switches.
- **Widget**: `value` (BOOLEAN) — **Workflow Values**: True/False

### PrimitiveStringMultiline
- **Purpose**: Outputs a multiline string. Used for prompts.
- **Widget**: `value` (STRING, multiline)

### PreviewAny
- **Source**: `nodes.py`
- **Purpose**: Previews any data type in the UI for debugging.

### PreviewAudio
- **Source**: `comfy_extras/nodes_audio.py`
- **Purpose**: Plays back audio in the UI for preview.

---

## 43. ImageScale

- **Source**: `nodes.py`
- **Purpose**: Scales image to exact target dimensions.

| Parameter | Type | Options | Description |
|-----------|------|---------|-------------|
| `upscale_method` | COMBO | nearest-exact, bilinear, area, bicubic, lanczos | Interpolation |
| `width` | INT | | Target width |
| `height` | INT | | Target height |
| `crop` | COMBO | disabled, center | Crop mode |

| Input | Type |
|-------|------|
| image | IMAGE |

| Output | Type |
|--------|------|
| IMAGE | IMAGE |

---

## 44. LatentComposite

- **Source**: `nodes.py`
- **Purpose**: Composites one latent onto another at a specified position. Used for spatial video stitching.

| Parameter | Type | Description |
|-----------|------|-------------|
| `x` | INT | X offset position |
| `y` | INT | Y offset position |
| `feather` | INT | Edge feathering |

| Input | Type |
|-------|------|
| samples_to | LATENT |
| samples_from | LATENT |

| Output | Type |
|--------|------|
| LATENT | LATENT |

---

## 45. MaskComposite

- **Source**: `nodes.py`
- **Purpose**: Composites masks together using boolean/arithmetic operations.

| Parameter | Type | Options | Description |
|-----------|------|---------|-------------|
| `x` | INT | | X offset |
| `y` | INT | | Y offset |
| `operation` | COMBO | multiply, add, subtract, and, or, xor | Compositing mode |

| Input | Type |
|-------|------|
| destination | MASK |
| source | MASK |

| Output | Type |
|--------|------|
| MASK | MASK |

---

## 46. FeatherMask

- **Source**: `nodes.py`
- **Purpose**: Applies feathering (gradual fade) to mask edges.

| Parameter | Type | Description |
|-----------|------|-------------|
| `left` | INT | Left edge feather |
| `top` | INT | Top edge feather |
| `right` | INT | Right edge feather |
| `bottom` | INT | Bottom edge feather |

| Input | Type |
|-------|------|
| mask | MASK |

| Output | Type |
|--------|------|
| MASK | MASK |

---

# COMFYUI-KJNODES (21)

---

## 47. VAELoaderKJ

- **Source**: https://github.com/kijai/ComfyUI-KJNodes
- **Purpose**: Enhanced VAE loader with device and dtype control. Allows loading VAE in specific precision (bf16) and on specific devices.

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| `vae_name` | COMBO | | Models from `models/vae/` | VAE model file |
| `device` | COMBO | main_device | main_device, offload_device, cpu | Target device |
| `weight_dtype` | COMBO | default | default, fp16, bf16, fp32 | Weight precision |

| Output | Type |
|--------|------|
| VAE | VAE |

**Workflow Values**: `vae_name="LTX23_video_vae_bf16.safetensors", device="main_device", weight_dtype="bf16"`

---

## 48. ImageResizeKJv2

- **Source**: https://github.com/kijai/ComfyUI-KJNodes
- **Purpose**: Advanced image resize with aspect ratio preservation, padding, and divisibility constraints. The go-to resize node for LTX workflows.

| Parameter | Type | Default | Options/Range | Description |
|-----------|------|---------|---------------|-------------|
| `width` | INT | 960 | 1–max | Target width |
| `height` | INT | 960 | 1–max | Target height |
| `upscale_method` | COMBO | lanczos | nearest, bilinear, bicubic, lanczos | Interpolation |
| `keep_proportion` | COMBO | resize | resize, crop, pad | Aspect ratio handling |
| `pad_color` | STRING | "0, 0, 0" | | Padding color (R,G,B) |
| `crop_position` | COMBO | center | center, top, bottom, left, right | Crop anchor |
| `divisible_by` | INT | 32 | 1–512 | Round dimensions to multiple |
| `device` | COMBO | cpu | cpu, cuda | Processing device |

| Input | Type |
|-------|------|
| image | IMAGE |
| mask | MASK (optional) |

| Output | Type |
|--------|------|
| IMAGE | IMAGE |
| width | INT |
| height | INT |
| mask | MASK |

**Workflow Values**: `width=960, height=960, upscale_method="lanczos", keep_proportion="resize", divisible_by=32`

---

## 49. INTConstant

- **Source**: https://github.com/kijai/ComfyUI-KJNodes
- **Purpose**: Simple integer constant output.

| Parameter | Type | Default | Range |
|-----------|------|---------|-------|
| `value` | INT | 0 | 0–max |

| Output | Type |
|--------|------|
| value | INT |

**Workflow Values**: `value=1920`

---

## 50. SimpleCalculatorKJ

- **Source**: https://github.com/kijai/ComfyUI-KJNodes
- **Purpose**: Expression-based calculator with type coercion. Supports arbitrary math expressions with variables a, b.

| Parameter | Type | Description |
|-----------|------|-------------|
| `expression` | STRING | Math expression with a, b variables |

| Input | Type |
|-------|------|
| a | INT/FLOAT/BOOLEAN |
| b | INT/FLOAT/BOOLEAN |

| Output | Type |
|--------|------|
| FLOAT | FLOAT |
| INT | INT |
| BOOLEAN | BOOLEAN |

**Workflow Values**: `expression="1+ 8*(round(a*b)/8)"`

---

## 51. LTXVChunkFeedForward

- **Source**: https://github.com/kijai/ComfyUI-KJNodes
- **Purpose**: Patches the model to use chunked feed-forward processing, reducing VRAM usage during inference at the cost of speed.

| Parameter | Type | Default | Range | Description |
|-----------|------|---------|-------|-------------|
| `chunks` | INT | 2 | 1–32 | Number of chunks |
| `dim_threshold` | INT | 4096 | 0–max | Dimension threshold for chunking |

| Input | Type |
|-------|------|
| model | MODEL |

| Output | Type |
|--------|------|
| model | MODEL |

**Workflow Values**: `chunks=2, dim_threshold=4096`

---

## 52. LTXVAudioVideoMask

- **Source**: https://github.com/kijai/ComfyUI-KJNodes
- **Purpose**: Creates temporal masks for audio-video latents to control which time ranges are active during generation. Supports padding or trimming.

| Parameter | Type | Default | Range | Description |
|-----------|------|---------|-------|-------------|
| `video_fps` | FLOAT | 24 | 1–120 | Video frame rate |
| `video_start_time` | FLOAT | 0 | 0–max | Video start time (seconds) |
| `video_end_time` | FLOAT | 5 | 0–max | Video end time (seconds) |
| `audio_start_time` | FLOAT | 0 | 0–max | Audio start time (seconds) |
| `audio_end_time` | FLOAT | 5 | 0–max | Audio end time (seconds) |
| `max_length` | COMBO | pad | pad, trim | Length handling |

| Input | Type |
|-------|------|
| video_latent | LATENT |
| audio_latent | LATENT |

| Output | Type |
|--------|------|
| video_latent | LATENT |
| audio_latent | LATENT |

**Workflow Values**: `video_fps=24, video_start=5, video_end=11, audio_start=5, audio_end=11, max_length="pad"`

---

## 53. LTX2AttentionTunerPatch

- **Source**: https://github.com/kijai/ComfyUI-KJNodes
- **Purpose**: Fine-tunes cross-attention scaling between video and audio modalities in the LTX2 transformer. Controls how strongly each modality influences the other.

| Parameter | Type | Default | Range | Description |
|-----------|------|---------|-------|-------------|
| `blocks` | STRING | "" | | Block indices to patch (comma-separated, empty=all) |
| `video_scale` | FLOAT | 1.0 | 0.0–10 | Video self-attention scale |
| `audio_scale` | FLOAT | 1.0 | 0.0–10 | Audio self-attention scale |
| `audio_to_video_scale` | FLOAT | 1.0 | 0.0–10 | Audio→video cross-attention |
| `video_to_audio_scale` | FLOAT | 1.0 | 0.0–10 | Video→audio cross-attention |
| `triton_kernels` | BOOLEAN | True | | Use Triton acceleration |

| Input | Type |
|-------|------|
| model | MODEL |

| Output | Type |
|--------|------|
| model | MODEL |

---

## 54. LTX2AudioLatentNormalizingSampling

- **Source**: https://github.com/kijai/ComfyUI-KJNodes
- **Purpose**: Applies per-block audio latent normalization during sampling to stabilize audio generation quality.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| (config string) | STRING | "1,1,0.01,1,1,0.01,1,1" | Per-block normalization weights |

| Input | Type |
|-------|------|
| model | MODEL |

| Output | Type |
|--------|------|
| MODEL | MODEL |

---

## 55. LTX2MemoryEfficientSageAttentionPatch

- **Source**: https://github.com/kijai/ComfyUI-KJNodes
- **Purpose**: Patches the model to use SageAttention for reduced memory usage during inference.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `triton_kernels` | BOOLEAN | True | Use Triton kernel acceleration |

| Input | Type |
|-------|------|
| model | MODEL |

| Output | Type |
|--------|------|
| model | MODEL |

---

## 56. LTX2SamplingPreviewOverride

- **Source**: https://github.com/kijai/ComfyUI-KJNodes
- **Purpose**: Enables intermediate preview frames during sampling by periodically decoding latents.

| Parameter | Type | Default | Range | Description |
|-----------|------|---------|-------|-------------|
| `preview_rate` | INT | 8 | 1–100 | Preview every N steps |

| Input | Type |
|-------|------|
| model | MODEL |
| latent_upscale_model | LATENT_UPSCALE_MODEL |
| vae | VAE |

| Output | Type |
|--------|------|
| MODEL | MODEL |

**Workflow Values**: `preview_rate=8`

---

## 57. LTX2_NAG

- **Source**: https://github.com/kijai/ComfyUI-KJNodes
- **Purpose**: Normalized Attention Guidance for LTX2. Alternative guidance method to CFG that works per-attention-head for improved quality.

| Parameter | Type | Default | Range | Description |
|-----------|------|---------|-------|-------------|
| `nag_scale` | FLOAT | 11 | 0.0–100 | NAG guidance scale |
| `nag_alpha` | FLOAT | 0.25 | 0.0–1.0 | Alpha blend parameter |
| `nag_tau` | FLOAT | 2.5 | 0.0–10 | Temperature parameter |
| `inplace` | BOOLEAN | True | | In-place computation (saves VRAM) |

| Input | Type |
|-------|------|
| model | MODEL |
| nag_cond_video | CONDITIONING |
| nag_cond_audio | CONDITIONING |

| Output | Type |
|--------|------|
| model | MODEL |

**Workflow Values**: `nag_scale=11, nag_alpha=0.25, nag_tau=2.5, inplace=True`

---

## 58. PathchSageAttentionKJ

- **Source**: https://github.com/kijai/ComfyUI-KJNodes
- **Purpose**: Patches model attention to use SageAttention (memory-efficient attention implementation). Note: name has typo in source.

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| `sage_attention` | COMBO | auto | auto, sageattn, sageattn_qk_int8_pv_fp16_cuda, etc. | Attention variant |
| `allow_compile` | BOOLEAN | False | | Allow torch.compile |

| Input | Type |
|-------|------|
| model | MODEL |

| Output | Type |
|--------|------|
| MODEL | MODEL |

**Workflow Values**: `sage_attention="auto", allow_compile=False`

---

## 59. LazySwitchKJ

- **Source**: https://github.com/kijai/ComfyUI-KJNodes
- **Purpose**: Lazy conditional switch — only evaluates the active branch. Used for workflow routing without wasting compute.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `switch` | BOOLEAN | False | True selects on_true, False selects on_false |

| Input | Type |
|-------|------|
| on_false | * (any) |
| on_true | * (any) |

| Output | Type |
|--------|------|
| * | * (same as input) |

---

## 60. ImageBatchExtendWithOverlap

- **Source**: https://github.com/kijai/ComfyUI-KJNodes
- **Purpose**: Extends an image batch with new images using blended overlap for smooth transitions in video extension.

| Parameter | Type | Default | Options/Range | Description |
|-----------|------|---------|---------------|-------------|
| `overlap` | INT | 5 | 0–max | Number of overlap frames |
| `overlap_side` | COMBO | source | source, new | Which side provides overlap |
| `overlap_mode` | COMBO | linear_blend | linear_blend, ease_in, ease_out | Blend mode |

| Input | Type |
|-------|------|
| source_images | IMAGE |
| new_images | IMAGE |

| Output | Type |
|--------|------|
| source_images | IMAGE |
| start_images | IMAGE |
| extended_images | IMAGE |

**Workflow Values**: `overlap=5, overlap_side="source", overlap_mode="linear_blend"`

---

## 61. VisualizeSigmasKJ

- **Source**: https://github.com/kijai/ComfyUI-KJNodes
- **Purpose**: Visualizes the sigma schedule as a plot image for debugging noise schedules.

| Input | Type |
|-------|------|
| sigmas | SIGMAS |

| Output | Type |
|--------|------|
| IMAGE | IMAGE |

---

# COMFYUI-LTXVIDEO (3)

---

## 62. GuiderParameters

- **Source**: https://github.com/Lightricks/ComfyUI-LTXVideo
- **Purpose**: Configures guidance parameters per modality (video/audio) for the multimodal guider. Allows different CFG, STG (spatiotemporal guidance), and rescale settings per modality.

| Parameter | Type | Default | Range | Description |
|-----------|------|---------|-------|-------------|
| `modality` | COMBO | VIDEO | VIDEO, AUDIO | Target modality |
| `cfg` | FLOAT | 7.0 | 0.0–100 | CFG guidance scale |
| `stg` | FLOAT | 1.0 | 0.0–100 | Spatiotemporal guidance scale |
| `perturb_attn` | BOOLEAN | True | | Perturb attention for STG |
| `rescale` | FLOAT | 0.7 | 0.0–1.0 | Guidance rescale factor |
| `modality_scale` | FLOAT | 3.0 | 0.0–100 | Cross-modality scale |
| `skip_step` | INT | 0 | 0–1000 | Skip guidance for first N steps |
| `cross_attn` | BOOLEAN | True | | Enable cross-attention guidance |

| Input | Type |
|-------|------|
| parameters | GUIDER_PARAMETERS (optional, chains) |

| Output | Type |
|--------|------|
| GUIDER_PARAMETERS | GUIDER_PARAMETERS |

**Workflow Values**: `modality="AUDIO", cfg=7, stg=1, perturb_attn=True, rescale=0.7, modality_scale=3, skip_step=0, cross_attn=True`

---

## 63. MultimodalGuider

- **Source**: https://github.com/Lightricks/ComfyUI-LTXVideo
- **Purpose**: Creates a multimodal guider that handles both video and audio conditioning with independent guidance parameters. Replacement for CFGGuider in audio-video workflows.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `skip_blocks` | STRING | "28" | Transformer block indices to skip (comma-separated) |

| Input | Type |
|-------|------|
| model | MODEL |
| positive | CONDITIONING |
| negative | CONDITIONING |
| parameters | GUIDER_PARAMETERS |

| Output | Type |
|--------|------|
| GUIDER | GUIDER |

**Workflow Values**: `skip_blocks="28"`

---

## 64. LTXVSpatioTemporalTiledVAEDecode

- **Source**: https://github.com/Lightricks/ComfyUI-LTXVideo
- **Purpose**: Memory-efficient VAE decoder with independent spatial and temporal tiling. Alternative to core VAEDecodeTiled with more control.

| Parameter | Type | Default | Range | Description |
|-----------|------|---------|-------|-------------|
| `spatial_tiles` | INT | 4 | 1–16 | Number of spatial tiles |
| `spatial_overlap` | INT | 4 | 0–32 | Spatial tile overlap |
| `temporal_tile_length` | INT | 16 | 1–256 | Temporal tile frames |
| `temporal_overlap` | INT | 4 | 0–32 | Temporal tile overlap |
| `last_frame_fix` | BOOLEAN | False | | Fix last frame artifacts |
| `working_device` | COMBO | auto | auto, cpu, cuda | Compute device |
| `working_dtype` | COMBO | auto | auto, fp16, bf16, fp32 | Compute precision |

| Input | Type |
|-------|------|
| vae | VAE |
| latents | LATENT |

| Output | Type |
|--------|------|
| image | IMAGE |

**Workflow Values**: `spatial_tiles=4, spatial_overlap=4, temporal_tile_length=16, temporal_overlap=4, last_frame_fix=False`

---

# COMFYUI-GGUF (2)

---

## 65. UnetLoaderGGUF

- **Source**: https://github.com/city96/ComfyUI-GGUF
- **Purpose**: Loads GGUF-quantized diffusion model weights for reduced VRAM usage. Supports Q4, Q5, Q6, Q8 and other GGUF quantization formats.

| Parameter | Type | Options | Description |
|-----------|------|---------|-------------|
| `unet_name` | COMBO | GGUF files from `models/diffusion_models/` or `models/unet/` | Model file |

| Output | Type |
|--------|------|
| MODEL | MODEL |

**Workflow Values**: `unet_name="ltx-2-3-22b-dev-Q4_K_M.gguf"`

---

## 66. DualCLIPLoaderGGUF

- **Source**: https://github.com/city96/ComfyUI-GGUF
- **Purpose**: Loads two CLIP models with GGUF quantization support. Transparently handles mixed formats — accepts both `.gguf` and `.safetensors` files.

| Parameter | Type | Options | Description |
|-----------|------|---------|-------------|
| `clip_name1` | COMBO | CLIP files (GGUF or safetensors) | Primary CLIP |
| `clip_name2` | COMBO | CLIP files (GGUF or safetensors) | Secondary CLIP |
| `type` | COMBO | sdxl, sd3, flux, ltxv, etc. | Architecture type |

| Output | Type |
|--------|------|
| CLIP | CLIP |

**Workflow Values**: `clip_name1="google_gemma-3-12b-it-qat-Q6_K.gguf", clip_name2="ltx-2.3_text_projection_bf16.safetensors", type="ltxv"`

---

# COMFYUI-VIDEOHELPERSUITE (3)

---

## 67. VHS_LoadVideo

- **Source**: https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite
- **Purpose**: Loads video files as image batches with frame rate control, cropping, and frame selection.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `video` | COMBO | | Video file from input directory |
| `force_rate` | FLOAT | 0 | Force specific frame rate (0=original) |
| `custom_width` | INT | 0 | Resize width (0=original) |
| `custom_height` | INT | 0 | Resize height (0=original) |
| `frame_load_cap` | INT | 0 | Max frames to load (0=all) |
| `skip_first_frames` | INT | 0 | Skip N frames from start |
| `select_every_nth` | INT | 1 | Frame subsampling |
| `format` | COMBO | image/default | Output format |

| Output | Type |
|--------|------|
| IMAGE | IMAGE |
| frame_count | INT |
| audio | AUDIO |
| video_info | VHS_VIDEOINFO |

---

## 68. VHS_VideoCombine

- **Source**: https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite
- **Purpose**: Combines image frames into a video file with audio support. Feature-rich video output node.

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| `frame_rate` | FLOAT | 24 | 1–120 | Output FPS |
| `format` | COMBO | video/h264-mp4 | video/h264-mp4, video/h265-mp4, image/gif, image/webp | Output format |
| `filename_prefix` | STRING | "AnimateDiff" | | Output filename prefix |
| `pingpong` | BOOLEAN | False | | Loop forward then backward |
| `save_output` | BOOLEAN | True | | Save to output directory |

| Input | Type |
|-------|------|
| images | IMAGE |
| audio | AUDIO (optional) |

---

## 69. VHS_VideoInfo

- **Source**: https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite
- **Purpose**: Extracts metadata from loaded video (fps, frame count, duration, dimensions).

| Input | Type |
|-------|------|
| video_info | VHS_VIDEOINFO |

| Output | Type |
|--------|------|
| fps | FLOAT |
| frame_count | INT |
| duration | FLOAT |
| width | INT |
| height | INT |

---

# COMFYUI-MELBANDROFORMER (2)

---

## 70. MelBandRoFormerModelLoader

- **Source**: https://github.com/KoreTeknique/ComfyUI-MelBandRoFormer
- **Purpose**: Loads a MelBandRoFormer model for audio source separation (vocals/instruments).

| Parameter | Type | Options | Description |
|-----------|------|---------|-------------|
| `model_name` | COMBO | Models from `models/MelBandRoFormer_comfy/` | Model file |

| Output | Type |
|--------|------|
| model | MELROFORMERMODEL |

**Workflow Values**: `model_name="MelBandRoFormer_comfy/MelBandRoformer_fp16.safetensors"`

---

## 71. MelBandRoFormerSampler

- **Source**: https://github.com/KoreTeknique/ComfyUI-MelBandRoFormer
- **Purpose**: Runs audio source separation, splitting audio into vocals and instruments tracks.

| Input | Type |
|-------|------|
| model | MELROFORMERMODEL |
| audio | AUDIO |

| Output | Type |
|--------|------|
| vocals | AUDIO |
| instruments | AUDIO |

---

# WHATDREAMSCOST-COMFYUI (2)

---

## 72. LTXSequencer

- **Source**: https://github.com/WhatDreamsCost/ComfyUI-WhatDreamsCost
- **Purpose**: Sequences multiple images into an LTX video at specific frame positions. Extends LTXVAddGuide with support for up to 50 frame insertion points and seconds-based timing mode. Each insertion can have its own strength.

| Parameter | Type | Description |
|-----------|------|-------------|
| `insert_frame_N` | INT | Frame index for Nth image insertion |
| `insert_second_N` | FLOAT | Time position in seconds (alternative) |
| `strength_N` | FLOAT | Guide strength for Nth image |

| Input | Type |
|-------|------|
| positive | CONDITIONING |
| negative | CONDITIONING |
| vae | VAE |
| latent | LATENT |
| multi_input | IMAGE (batch of guide images) |

| Output | Type |
|--------|------|
| positive | CONDITIONING |
| negative | CONDITIONING |
| latent | LATENT |

---

## 73. MultiImageLoader

- **Source**: https://github.com/WhatDreamsCost/ComfyUI-WhatDreamsCost
- **Purpose**: Loads multiple images from file paths with resize/preprocessing. Outputs a fixed 51-tuple (1 batch + 50 individual slots, unused slots padded with zero tensors).

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `image_paths` | STRING | | Newline-separated image filenames |
| `width` | INT | 1920 | Target width |
| `height` | INT | 1088 | Target height |
| `interpolation` | COMBO | lanczos | Resize interpolation |
| `resize_method` | COMBO | stretch | stretch, crop, pad |
| `multiple_of` | INT | 16 | Round dimensions to multiple |
| `img_compression` | INT | 18 | H.264 compression simulation |

| Output | Type |
|--------|------|
| multi_output | IMAGE (batch) |
| image_1..50 | IMAGE (individual) |

---

# OTHER CUSTOM NODES

---

## 74. NormalizeAudioLoudness

- **Source**: https://github.com/kijai/ComfyUI-WanVideoWrapper
- **Purpose**: Normalizes audio loudness to a target LUFS (Loudness Units Full Scale) using pyloudnorm.

| Parameter | Type | Default | Range | Description |
|-----------|------|---------|-------|-------------|
| `lufs` | FLOAT | -16 | -50–0 | Target loudness in LUFS |

| Input | Type |
|-------|------|
| audio | AUDIO |

| Output | Type |
|--------|------|
| audio | AUDIO |

**Workflow Values**: `lufs=-16`

---

## 75. Float (comfyui-logic)

- **Source**: https://github.com/thecooltechguy/ComfyUI-Logic
- **Purpose**: Simple float constant node from the Logic pack.

| Parameter | Type | Default |
|-----------|------|---------|
| `value` | FLOAT | 0.0 |

| Output | Type |
|--------|------|
| FLOAT | FLOAT |

**Workflow Values**: `value=24`

---

## 76. LTXVImgToVideoInplaceKJ

- **Source**: https://github.com/kijai/ComfyUI-KJNodes
- **Purpose**: Extended version of LTXVImgToVideoInplace supporting up to 5 images at specific frame indices with individual strengths.

| Parameter | Type | Description |
|-----------|------|-------------|
| `image_index_N` | INT | Frame index for Nth image |
| `strength_N` | FLOAT | Guide strength for Nth image |

| Input | Type |
|-------|------|
| vae | VAE |
| latent | LATENT |
| image_1..5 | IMAGE |

| Output | Type |
|--------|------|
| latent | LATENT |

---

## 77. TextGenerateLTX2Prompt

- **Source**: https://github.com/comfyanonymous/ComfyUI (`comfy_extras/nodes_textgen.py`)
- **Purpose**: Uses the CLIP model (e.g., Gemma) to generate or enhance text prompts for LTX2 video generation. Runs the language model in generation mode to produce descriptive prompts.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `prompt` | STRING | | Input prompt or instructions |
| `max_length` | INT | 256 | Maximum generated token length |
| `temperature` | FLOAT | 0.7 | Sampling temperature |
| `top_p` | FLOAT | 0.9 | Top-p sampling threshold |

| Input | Type |
|-------|------|
| clip | CLIP |
| image | IMAGE (optional) |

| Output | Type |
|--------|------|
| generated_text | STRING |

---

## 78. TorchCompileModel

- **Source**: https://github.com/comfyanonymous/ComfyUI (`comfy_extras/nodes_torch_compile.py`)
- **Purpose**: Applies torch.compile to the model for potential speedup via kernel fusion and optimization.

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| `backend` | COMBO | inductor | inductor, cudagraphs, aot_eager | Compile backend |

| Input | Type |
|-------|------|
| model | MODEL |

| Output | Type |
|--------|------|
| MODEL | MODEL |

**Workflow Values**: `backend="inductor"`

---

## 79. RTXVideoSuperResolution

- **Source**: https://github.com/BetaDoggo/comfyui-rtx-simple
- **Purpose**: Upscales video frames using NVIDIA RTX Video Super Resolution. Requires RTX GPU.

| Parameter | Type | Default | Options/Range | Description |
|-----------|------|---------|---------------|-------------|
| `resize_type` | COMBO | | scale by multiplier, scale to dimensions | Resize mode |
| `scale` | FLOAT | 2.0 | 1.0–4.0 | Scale factor |
| `quality` | COMBO | ULTRA | LOW, MEDIUM, HIGH, ULTRA | Quality preset |

| Input | Type |
|-------|------|
| images | IMAGE |

| Output | Type |
|--------|------|
| upscaled_images | IMAGE |

**Workflow Values**: `scale=2, quality="ULTRA"`

---

## 80–84. Audio Utility Nodes

### AudioConcat
- **Source**: https://github.com/comfyanonymous/ComfyUI (`comfy_extras/nodes_audio.py`)
- **Purpose**: Concatenates multiple audio clips sequentially.
- **Input**: audio1 (AUDIO), audio2 (AUDIO) → **Output**: AUDIO

### AudioCrop
- **Source**: https://github.com/DimaChaworski/audio-separation-nodes-comfyui
- **Purpose**: Crops audio to a time range.
- **Widgets**: `start_time` (STRING, "0:00"), `end_time` (STRING, "1:00")
- **Input**: audio (AUDIO) → **Output**: AUDIO

### TrimAudio
- **Source**: https://github.com/comfyanonymous/ComfyUI (`comfy_extras/nodes_audio.py`)
- **Purpose**: Trims audio by sample count or time.
- **Input**: audio (AUDIO) → **Output**: AUDIO

### TrimAudioDuration
- **Source**: https://github.com/comfyanonymous/ComfyUI (`comfy_extras/nodes_audio.py`)
- **Purpose**: Trims audio to a specific duration.
- **Input**: audio (AUDIO), duration (FLOAT) → **Output**: AUDIO

### NormalizeAudioLoudness
- See node #74 above.

---

## 85–88. Image Utility Nodes

### GetImage
- **Source**: comfy-core (unconfirmed)
- **Purpose**: Gets a single image from a batch by index.
- **Input**: images (IMAGE), index (INT) → **Output**: IMAGE

### GetImageRangeFromBatch
- **Source**: https://github.com/kijai/ComfyUI-KJNodes (`nodes/image_nodes.py`)
- **Purpose**: Extracts a range of images from a batch.
- **Input**: images (IMAGE), start (INT), length (INT) → **Output**: IMAGE

### GetImageSizeAndCount
- **Source**: https://github.com/kijai/ComfyUI-KJNodes (`nodes/image_nodes.py`)
- **Purpose**: Returns image dimensions and batch count.
- **Input**: image (IMAGE) → **Output**: width (INT), height (INT), count (INT), image (IMAGE passthrough)

### ImageBatchMulti
- **Source**: https://github.com/kijai/ComfyUI-KJNodes (`nodes/image_nodes.py`)
- **Purpose**: Combines multiple individual images into a batch.
- **Input**: image_1..N (IMAGE) → **Output**: IMAGE (batch)

---

## 89. easy showAnything

- **Source**: https://github.com/yolain/ComfyUI-Easy-Use
- **Purpose**: Debug/preview node that displays any data type as text in the UI.

| Input | Type |
|-------|------|
| anything | * (any) |

---

# Required Models Summary

| Model | Type | Source | Used By |
|-------|------|--------|---------|
| `ltx-2-3-22b-dev-Q4_K_M.gguf` | Diffusion (GGUF Q4) | Lightricks | UnetLoaderGGUF |
| `ltx-2-19b-dev-fp8.safetensors` | Checkpoint (FP8) | Lightricks | CheckpointLoaderSimple |
| `gemma_3_12B_it_fp4_mixed.safetensors` | Text encoder | Google | DualCLIPLoader |
| `google_gemma-3-12b-it-qat-Q6_K.gguf` | Text encoder (GGUF) | Google | DualCLIPLoaderGGUF |
| `ltx-2.3_text_projection_bf16.safetensors` | Text projection | Lightricks | DualCLIPLoader |
| `LTX23_video_vae_bf16.safetensors` | Video VAE | Lightricks | VAELoaderKJ |
| `LTX23_audio_vae_bf16.safetensors` | Audio VAE | Lightricks | LTXVAudioVAELoader |
| `ltx-2.3-spatial-upscaler-x2-1.0.safetensors` | Latent upscaler | Lightricks | LatentUpscaleModelLoader |
| `LTX-2/LTX-2-Image2Vid-Adapter.safetensors` | LoRA adapter | Lightricks | LoraLoaderModelOnly |
| `MelBandRoformer_fp16.safetensors` | Audio separator | Community | MelBandRoFormerModelLoader |

---

## Compatibility Notes

### Model Family
- **Architecture**: LTX Video — a video diffusion transformer (DiT) with 128-channel latents
- **Latent space**: 128-channel with 32× spatial and 8× temporal compression — completely incompatible with SD/Lumina/Qwen latents
- **Text encoder**: Dual CLIP via `DualCLIPLoader` (Gemma + LTX text projection) with `type="ltxv"`. Does NOT use single `CLIPLoader`
- **Noise schedule**: Uses `LTXVScheduler` (resolution-aware) or `BasicScheduler` or `ManualSigmas` — NOT `ModelSamplingAuraFlow`

### CFG Behavior
- LTX is trained for CFG=1 (no classifier-free guidance) — this is standard, not a bug
- `CFGGuider` with `cfg=1` is the norm; higher values cause artifacts
- Negative conditioning is typically empty `CLIPTextEncode` or minimal text

### Video-Specific Constraints
- `EmptyLTXVLatentVideo` must be used (not `EmptyLatentImage` or `EmptySD3LatentImage`)
- Frame `length` follows formula: $1 + 8k$ (e.g., 1, 9, 17, 25, ..., 97, 121) due to 8× temporal compression
- Width/height must be multiples of 32
- Use `SamplerCustomAdvanced` (not `KSampler` or `KSamplerAdvanced`) for full pipeline control

### Image-to-Video
- Input images must go through `LTXVPreprocess` (optional H.264 compression simulation) before `LTXVImgToVideoInplace`
- `LTXVImgToVideoInplace` encodes the image into the first frame and sets up a noise mask
- `LTXVAddGuide` / `LTXVAddGuideMulti` allow injecting keyframe images at arbitrary positions

### Audio-Video (LTX 2.3+)
- Audio and video latents are processed jointly via `LTXVConcatAVLatent` → sampling → `LTXVSeparateAVLatent`
- Audio VAE is separate from video VAE (`LTXVAudioVAELoader` vs `VAELoaderKJ`)
- Final output requires `CreateVideo` to mux images + audio → `SaveVideo`

### Tiled Decoding
- Large videos require `VAEDecodeTiled` (not `VAEDecode`) to avoid OOM
- `LTXVSpatioTemporalTiledVAEDecode` (from ComfyUI-LTXVideo) offers finer control over spatial+temporal tiling

### GGUF Support
- LTX models are available in GGUF quantized format for lower VRAM usage
- Use `UnetLoaderGGUF` + `DualCLIPLoaderGGUF` instead of standard loaders
- GGUF nodes come from ComfyUI-GGUF package (not comfy-core)

### Cross-Workflow Compatibility
- Can receive IMAGE output from Moody `VAEDecode`/`SaveImage` as i2v input via `LTXVImgToVideoInplace`
- Can receive IMAGE output from Qwen Image Edit as i2v input
- Models/VAE/CLIP are NOT interchangeable with Moody or Qwen (completely different architecture)
- Video output frames can be saved as images and fed back into Moody or Qwen for per-frame editing
