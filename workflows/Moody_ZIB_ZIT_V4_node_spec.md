# Moody ZIB + ZIT Simple Workflow V4 — Node Configuration Spec

> 29 unique node types across 6 packages. Mode 0 = active, Mode 4 = disabled/bypassed.

---

## Package Summary

| Package | Repository | Nodes |
|---------|-----------|-------|
| comfy-core | https://github.com/comfyanonymous/ComfyUI | CLIPLoader, CLIPTextEncode, ConditioningZeroOut, EmptySD3LatentImage, GetImageSize, KSamplerAdvanced, LatentUpscaleBy, ModelSamplingAuraFlow, PreviewImage, SaveImage, UNETLoader, UpscaleModelLoader, VAEDecode, VAELoader |
| rgthree-comfy | https://github.com/rgthree/rgthree-comfy | Image Comparer, Label, Power Lora Loader, Seed |
| comfyui-impact-pack | https://github.com/ltdrdata/ComfyUI-Impact-Pack | FaceDetailer, SAMLoader |
| comfyui-impact-subpack | https://github.com/ltdrdata/ComfyUI-Impact-Subpack | UltralyticsDetectorProvider |
| comfyui_essentials | https://github.com/cubiq/ComfyUI_essentials | MaskPreview+, SimpleMath+ |
| comfyui-kjnodes | https://github.com/kijai/ComfyUI-KJNodes | FloatConstant |
| comfyui_ultimatesdupscale | https://github.com/ssitu/ComfyUI_UltimateSDUpscale | UltimateSDUpscale |
| ComfyUI-SeedVR2_VideoUpscaler | https://github.com/ainvfx/ComfyUI-SeedVR2_VideoUpscaler | SeedVR2LoadDiTModel, SeedVR2LoadVAEModel, SeedVR2VideoUpscaler |

---

## Workflow Architecture

```
[CLIPLoader] ──→ CLIP ──→ [Power Lora Loader (ZIB)] ──→ [Power Lora Loader (ZIT)] ──→ ...
                                                                                        │
[UNETLoader ZIB] ──→ [Power Lora Loader (ZIB)] ──→ [ModelSamplingAuraFlow] ──→ [KSampler 1ST]
[UNETLoader ZIT] ──→ [Power Lora Loader (ZIT)] ──→ [ModelSamplingAuraFlow] ──→ [KSampler 2ND]
                                                                                        │
[VAELoader] ──→ VAE ──→ [VAEDecode] ──→ IMAGE ──→ [UltimateSDUpscale] ──→ [SaveImage]
                                                                       ──→ [FaceDetailer] (optional)
                                                                       ──→ [SeedVR2] (optional)
```

**Two-pass generation**: ZIB model generates base composition (1st KSampler), then ZIT model refines details on upscaled latent (2nd KSampler).

---

## 1. CLIPLoader

- **Source**: https://github.com/comfyanonymous/ComfyUI (`comfy_extras/nodes_clip.py`)
- **Purpose**: Loads a CLIP text encoder model for conditioning

| Parameter | Type | Options | Description |
|-----------|------|---------|-------------|
| `clip_name` | COMBO | Files from `models/text_encoders/` | CLIP model filename |
| `type` | COMBO | stable_diffusion, stable_cascade, sd3, stable_audio, mochi, ltxv, pixart, cosmos, lumina2, wan, hidream | Architecture type |
| `device` | COMBO | default, cpu | Device to load model on |

| Output | Type |
|--------|------|
| CLIP | CLIP |

**Workflow Config** (id:39, active):
```
clip_name = "qwen_3_4b.safetensors"
type      = "lumina2"
device    = "default"
```

---

## 2. VAELoader

- **Source**: https://github.com/comfyanonymous/ComfyUI (`nodes.py`)
- **Purpose**: Loads a VAE model for encoding/decoding between pixel and latent space

| Parameter | Type | Description |
|-----------|------|-------------|
| `vae_name` | COMBO | VAE model file from `models/vae/` |

| Output | Type |
|--------|------|
| VAE | VAE |

**Workflow Config** (id:40, active):
```
vae_name = "ae.safetensors"
```

---

## 3. UNETLoader

- **Source**: https://github.com/comfyanonymous/ComfyUI (`nodes.py`)
- **Purpose**: Loads a diffusion model (UNet/DiT) checkpoint

| Parameter | Type | Options | Description |
|-----------|------|---------|-------------|
| `unet_name` | COMBO | Files from `models/diffusion_models/` | Model checkpoint |
| `weight_dtype` | COMBO | default, fp8_e4m3fn, fp8_e4m3fn_fast, fp8_e5m2 | Weight precision format |

| Output | Type |
|--------|------|
| MODEL | MODEL |

**Workflow Config**:

| Instance | ID | Title | Model | weight_dtype |
|----------|----|-------|-------|-------------|
| ZIB (1st pass) | 488 | Load Diffusion Model (1ST K) ZIB | `moodyWildMix_v20BASE45STEPS.safetensors` | `default` |
| ZIT (2nd pass) | 46 | Load Diffusion Model (2ND K) ZIT | `moodyPornMix_zitV10DPO.safetensors` | `default` |

---

## 4. CLIPTextEncode

- **Source**: https://github.com/comfyanonymous/ComfyUI (`nodes.py`)
- **Purpose**: Encodes text prompt into CONDITIONING using the loaded CLIP model

| Input | Type | Description |
|-------|------|-------------|
| `clip` | CLIP | CLIP model (linked) |
| `text` | STRING | Prompt text (multiline) |

| Output | Type |
|--------|------|
| CONDITIONING | CONDITIONING |

**Workflow Config**:

| Instance | ID | Title | Mode | Text |
|----------|----|-------|------|------|
| Positive | 45 | (main prompt) | active | Long Chinese-language prompt describing scene, clothing, photography style |
| Negative | 490 | CLIP Text Encode (Negative Prompt) | active | Chinese negative prompt: blur, low-res, ugly, extra limbs, watermark, etc. |
| Face Detailer Positive | 474 | CLIP Text Encode (Positive Prompt) | **disabled** | `"19 years old cute Chinese girl，鞠婧祎"` |

---

## 5. ConditioningZeroOut

- **Source**: https://github.com/comfyanonymous/ComfyUI (`comfy_extras/nodes_model_advanced.py`)
- **Purpose**: Zeros out all conditioning tensors (including pooled_output). Used to create an "empty" negative conditioning for flow-based models that don't use traditional CFG.

| Input | Type |
|-------|------|
| conditioning | CONDITIONING |

| Output | Type |
|--------|------|
| CONDITIONING | CONDITIONING (zeroed) |

**Workflow Config**:

| Instance | ID | Mode | Purpose |
|----------|----|------|---------|
| Main | 42 | active | Negative conditioning for both KSamplers |
| Face Detailer | 465 | **disabled** | Negative conditioning for face detailer |

---

## 6. EmptySD3LatentImage

- **Source**: https://github.com/comfyanonymous/ComfyUI (`comfy_extras/nodes_sd3.py`)
- **Purpose**: Creates an empty 16-channel latent image (for SD3/Lumina2-class models, vs 4-channel for SD1.5)

| Parameter | Type | Default | Range | Description |
|-----------|------|---------|-------|-------------|
| `width` | INT | 1024 | 16–MAX, step 16 | Latent width |
| `height` | INT | 1024 | 16–MAX, step 16 | Latent height |
| `batch_size` | INT | 1 | 1–4096 | Batch count |

| Output | Type |
|--------|------|
| LATENT | LATENT |

**Workflow Config** (id:492, active):
```
width      = 640
height     = 960
batch_size = 1
```

---

## 7. ModelSamplingAuraFlow

- **Source**: https://github.com/comfyanonymous/ComfyUI (`comfy_extras/nodes_model_advanced.py`)
- **Purpose**: Modifies the model's noise schedule using AuraFlow-style sampling. Inherits from `ModelSamplingSD3` but with `multiplier=1.0` (instead of 1000). Higher shift values push more noise into early timesteps.

| Parameter | Type | Default | Range | Description |
|-----------|------|---------|-------|-------------|
| `shift` | FLOAT | 1.73 | 0.0–100.0 | Noise schedule shift factor |

| Input | Type |
|-------|------|
| model | MODEL |

| Output | Type |
|--------|------|
| MODEL | MODEL (modified sampling) |

**Workflow Config** (shift=3 on all instances):

| Instance | ID | Mode | Purpose |
|----------|----|------|---------|
| ZIB pre-1st KSampler | 483 | active | Shifts ZIB model sampling |
| ZIT pre-2nd KSampler | 47 | active | Shifts ZIT model sampling |
| Face Detailer | 462 | **disabled** | Shifts model for face detailer |

---

## 8. KSamplerAdvanced

- **Source**: https://github.com/comfyanonymous/ComfyUI (`nodes.py`)
- **Purpose**: Advanced KSampler with control over noise addition, step range, and leftover noise. Enables multi-pass sampling workflows.

| Parameter | Type | Default | Options/Range | Description |
|-----------|------|---------|---------------|-------------|
| `add_noise` | COMBO | "enable" | enable, disable | Whether to add initial noise |
| `noise_seed` | INT | 0 | 0–0xffffffffffffffff | Random seed |
| `steps` | INT | 20 | 1–10000 | Total sampling steps |
| `cfg` | FLOAT | 8.0 | 0.0–100.0 | Classifier-free guidance scale |
| `sampler_name` | COMBO | — | euler, dpmpp_2m_sde, res_multistep, etc. | Sampler algorithm |
| `scheduler` | COMBO | — | normal, karras, simple, sgm_uniform, etc. | Noise schedule |
| `start_at_step` | INT | 0 | 0–10000 | Step to start sampling at |
| `end_at_step` | INT | 10000 | 0–10000 | Step to end sampling at |
| `return_with_leftover_noise` | COMBO | "disable" | enable, disable | Keep residual noise for next pass |

| Input | Type |
|-------|------|
| model | MODEL |
| positive | CONDITIONING |
| negative | CONDITIONING |
| latent_image | LATENT |

| Output | Type |
|--------|------|
| LATENT | LATENT |

**Workflow Config**:

| | 1st KSampler (id:501) | 2nd KSampler (id:500) |
|-|----------------------|----------------------|
| **Title** | KSampler (Advanced) 1ST | KSampler (Advanced) 2ND |
| `add_noise` | `enable` | `disable` |
| `steps` | 17 | 12 |
| `cfg` | 4 | 1 |
| `sampler_name` | `res_multistep` | `dpmpp_2m_sde` |
| `scheduler` | `simple` | `sgm_uniform` |
| `start_at_step` | 0 | 4 |
| `end_at_step` | 12 | 10000 |
| `return_with_leftover_noise` | `enable` | `disable` |

**Note**: The 1st pass generates base composition with leftover noise, which is latent-upscaled 1.7x, then the 2nd pass refines starting at step 4 with CFG=1 (effectively unconditioned refinement for detail preservation).

---

## 9. LatentUpscaleBy

- **Source**: https://github.com/comfyanonymous/ComfyUI (`nodes.py`)
- **Purpose**: Upscales latent tensor by a scale factor using interpolation

| Parameter | Type | Default | Options | Description |
|-----------|------|---------|---------|-------------|
| `upscale_method` | COMBO | "nearest-exact" | nearest-exact, bilinear, area, bislerp | Interpolation method |
| `scale_by` | FLOAT | 1.5 | 0.01–8.0, step 0.01 | Scale factor |

| Input | Type |
|-------|------|
| samples | LATENT |

| Output | Type |
|--------|------|
| LATENT | LATENT |

**Workflow Config** (id:502, active):
```
upscale_method = "bislerp"
scale_by       = 1.7
```

---

## 10. VAEDecode

- **Source**: https://github.com/comfyanonymous/ComfyUI (`nodes.py`)
- **Purpose**: Decodes latent tensor back to pixel space using VAE

| Input | Type |
|-------|------|
| samples | LATENT |
| vae | VAE |

| Output | Type |
|--------|------|
| IMAGE | IMAGE |

**Workflow Config**:

| Instance | ID | Purpose |
|----------|----|---------|
| After 2nd KSampler | 129 | Main decode for SD upscale input |
| After 1st KSampler | 452 | Preview decode (1st gen preview) |

---

## 11. GetImageSize

- **Source**: https://github.com/comfyanonymous/ComfyUI (`nodes.py`)
- **Purpose**: Returns width, height, and batch_size of an input image

| Input | Type |
|-------|------|
| image | IMAGE |

| Output | Type |
|--------|------|
| width | INT |
| height | INT |
| batch_size | INT |

**Workflow Config** (id:450, active): Feeds width/height into SimpleMath+ for tile size calculation.

---

## 12. UpscaleModelLoader

- **Source**: https://github.com/comfyanonymous/ComfyUI (`nodes.py`)
- **Purpose**: Loads a single-image upscale model (e.g. ESRGAN, RealESRGAN) via the Spandrel library

| Parameter | Type | Description |
|-----------|------|-------------|
| `model_name` | COMBO | File from `models/upscale_models/` |

| Output | Type |
|--------|------|
| UPSCALE_MODEL | UPSCALE_MODEL |

**Workflow Config**:

| Instance | ID | Mode | Model |
|----------|----|------|-------|
| Primary | 481 | active | `4x-UltraSharp.pth` |
| Alternative | 511 | **disabled** | `1xSkinContrast-High-SuperUltraCompact.pth` |

---

## 13. PreviewImage

- **Source**: https://github.com/comfyanonymous/ComfyUI (`nodes.py`)
- **Purpose**: Displays an image preview in the UI (saves as temp file)

| Input | Type |
|-------|------|
| images | IMAGE |

**Workflow Config**:

| Instance | ID | Title |
|----------|----|-------|
| After 1st gen | 455 | Preview Image 1ST |
| After 2nd gen | 200 | Preview Image 2ND |

---

## 14. SaveImage

- **Source**: https://github.com/comfyanonymous/ComfyUI (`nodes.py`)
- **Purpose**: Saves images to disk with configurable filename pattern

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `filename_prefix` | STRING | "ComfyUI" | Path/prefix with date tokens: `%date:format%` |

| Input | Type |
|-------|------|
| images | IMAGE |

**Workflow Config** (all use same pattern):
```
filename_prefix = "image/%date:yyyy-MM-dd%/%date:hhmmss%"
```

| Instance | ID | Mode | Purpose |
|----------|----|------|---------|
| After SD upscale | 9 | active | Save upscaled image |
| After face detailer | 471 | active | Save face-detailed image |
| After SeedVR2 | 480 | **disabled** | Save SeedVR2 upscaled image |

---

## 15. Power Lora Loader (rgthree)

- **Source**: https://github.com/rgthree/rgthree-comfy (`py/power_lora_loader.py`)
- **Purpose**: Loads and applies multiple LoRA models to MODEL and/or CLIP with per-LoRA toggle and strength control

| Input | Type | Required |
|-------|------|----------|
| model | MODEL | optional |
| clip | CLIP | optional |

| Widget | Type | Description |
|--------|------|-------------|
| LoRA rows (dynamic) | PowerLoraLoaderWidgetValue | `{on, lora, strength, strengthTwo}` per LoRA |
| Show Strengths (property) | COMBO | "Single Strength" or "Separate Model & Clip" |

| Output | Type |
|--------|------|
| MODEL | MODEL (with LoRAs applied) |
| CLIP | CLIP (with LoRAs applied) |

**Workflow Config**:

| Instance | ID | Title | Mode | Purpose |
|----------|----|-------|------|---------|
| ZIB step | 515 | Power Lora Loader (ZIB) | active | LoRAs affecting composition/structure |
| ZIT step | 446 | Power Lora Loader (ZIT) | active | LoRAs affecting fine details |
| Face Detailer | 469 | — | **disabled** | LoRAs for face detailer "face-swap" |

**Note**: ZIB LoRAs have stronger structural effect; ZIT LoRAs affect details. For maximum character likeness, the same character LoRA can be loaded in both ZIB and ZIT steps.

---

## 16. Seed (rgthree)

- **Source**: https://github.com/rgthree/rgthree-comfy (`py/seed.py`)
- **Purpose**: Seed management with random/fixed/increment/decrement modes. Special values: -1=random, -2=increment, -3=decrement.

| Parameter | Type | Range | Description |
|-----------|------|-------|-------------|
| `seed` | INT | $[-1125899906842624, 1125899906842624]$ | Seed value |

| Output | Type |
|--------|------|
| SEED | INT |

**Workflow Config**:

| Instance | ID | Mode | Seed | Feeds |
|----------|----|------|------|-------|
| 1st KSampler | 454 | active | `886786875217510` | KSampler 1ST |
| 2nd KSampler | 460 | active | `1071221909412236` | KSampler 2ND |
| Face Detailer | 467 | **disabled** | `10` | FaceDetailer |

---

## 17. Image Comparer (rgthree)

- **Source**: https://github.com/rgthree/rgthree-comfy (`py/image_comparer.py`)
- **Purpose**: Interactive side-by-side image comparison with slider or click toggle

| Input | Type | Description |
|-------|------|-------------|
| image_a | IMAGE | Left/base image |
| image_b | IMAGE | Right/overlay image |

| Property | Options | Default |
|----------|---------|---------|
| `comparer_mode` | Slide, Click | Slide |

**Workflow Config**:

| Instance | ID | Title | Compares |
|----------|----|-------|----------|
| SD Upscale | 64 | SD Upscale Compare | Before vs after SD upscale |
| Detailer | 468 | Detailer Compare | Before vs after face detailing |

---

## 18. UltimateSDUpscale

- **Source**: https://github.com/ssitu/ComfyUI_UltimateSDUpscale
- **Purpose**: Tiled SD upscaling — splits image into overlapping tiles, runs img2img on each, then stitches them together with optional seam fixing

| Parameter | Type | Default | Range/Options | Description |
|-----------|------|---------|---------------|-------------|
| `upscale_by` | FLOAT | 2.0 | 0.05–8.0 | Scale factor (overridden by linked input) |
| `seed` | INT | 0 | 0–0xffffffffffffffff | Random seed |
| `steps` | INT | 20 | 1–10000 | Sampling steps per tile |
| `cfg` | FLOAT | 8.0 | 0.0–100.0 | CFG scale |
| `sampler_name` | COMBO | — | KSampler.SAMPLERS | Sampler algorithm |
| `scheduler` | COMBO | — | KSampler.SCHEDULERS | Noise schedule |
| `denoise` | FLOAT | 0.2 | 0.0–1.0 | Denoising strength per tile |
| `mode_type` | COMBO | "Linear" | Linear, Chess, None | Tile processing order |
| `tile_width` | INT | 512 | 64–MAX, step 8 | Tile width in pixels |
| `tile_height` | INT | 512 | 64–MAX, step 8 | Tile height in pixels |
| `mask_blur` | INT | 8 | 0–64 | Mask blur for tile edges |
| `tile_padding` | INT | 32 | 0–MAX, step 8 | Overlap padding between tiles |
| `seam_fix_mode` | COMBO | "None" | None, Band Pass, Half Tile, Half Tile + Intersections | Seam artifact correction method |
| `seam_fix_denoise` | FLOAT | 1.0 | 0.0–1.0 | Denoise strength for seam fix pass |
| `seam_fix_width` | INT | 64 | 0–128, step 8 | Width of seam fix band |
| `seam_fix_mask_blur` | INT | 8 | 0–64 | Mask blur for seam fix |
| `seam_fix_padding` | INT | 16 | 0–128, step 8 | Padding for seam fix |
| `force_uniform_tiles` | BOOLEAN | true | — | Force consistent tile sizes |
| `tiled_decode` | BOOLEAN | false | — | Use tiled VAE decode (saves VRAM) |
| `batch_size` | INT | 1 | 1–32 | Tiles processed per batch |

| Input | Type | Description |
|-------|------|-------------|
| image | IMAGE | Source image |
| model | MODEL | Diffusion model (ZIT in this workflow) |
| positive | CONDITIONING | Positive conditioning |
| negative | CONDITIONING | Negative conditioning |
| vae | VAE | VAE model |
| upscale_model | UPSCALE_MODEL | Pre-upscale model (4x-UltraSharp) |
| upscale_by | FLOAT | Scale factor (linked from FloatConstant) |

| Output | Type |
|--------|------|
| IMAGE | IMAGE |

**Workflow Config** (id:170, active):
```
upscale_by       = 2.5 (widget) / 1.7 (linked from FloatConstant)
seed             = 677826103351453
steps            = 3
cfg              = 1
sampler_name     = "dpmpp_2m_sde"
scheduler        = "sgm_uniform"
denoise          = 0.27
mode_type        = "Chess"
tile_width       = 1024 (linked from SimpleMath+)
tile_height      = 1024 (linked from SimpleMath+)
mask_blur        = 64
tile_padding     = 128
seam_fix_mode    = "None"
force_uniform_tiles = true
tiled_decode     = false
batch_size       = 1
```

**Note**: The linked `upscale_by` (1.7 from FloatConstant) overrides the widget value (2.5). Uses Chess tiling pattern for better coherence. Low denoise (0.27) preserves most detail while adding sharpness.

---

## 19. SimpleMath+

- **Source**: https://github.com/cubiq/ComfyUI_essentials (`nodes.py`)
- **Purpose**: Mathematical expression evaluator using safe Python `ast` parsing. Supports variables `a`, `b`, `c`, `d` and functions `min`, `max`, `round`, `sum`, `len`.

| Input | Type | Description |
|-------|------|-------------|
| a | INT/FLOAT | First variable |
| b | INT/FLOAT | Second variable |
| value | STRING | Expression formula |
| c | * | Third variable (optional) |

| Output | Type |
|--------|------|
| INT | INT (truncated result) |
| FLOAT | FLOAT |

**Workflow Config**:

| Instance | ID | Title | Formula | Purpose |
|----------|----|-------|---------|---------|
| Width | 176 | Calculate optimized width | `(a*b + (128 * 2))/2` | `a`=image_width, `b`=upscale_factor → tile width |
| Height | 172 | Calculate optimized height | `(a*b + (128 * 2))/2` | `a`=image_height, `b`=upscale_factor → tile height |

---

## 20. MaskPreview+

- **Source**: https://github.com/cubiq/ComfyUI_essentials
- **Purpose**: Previews a mask as a grayscale image (converts mask to 3-channel for display)

| Input | Type |
|-------|------|
| mask | MASK |

**Workflow Config** (id:464, **disabled**): Shows mask from FaceDetailer output.

---

## 21. FloatConstant

- **Source**: https://github.com/kijai/ComfyUI-KJNodes
- **Purpose**: Stores and outputs a constant float value. Outputs `round(value, 6)`.

| Parameter | Type | Default | Range | Description |
|-----------|------|---------|-------|-------------|
| `value` | FLOAT | 0.0 | -9999999.0–9999999.0, step 0.00001 | Constant value |

| Output | Type |
|--------|------|
| value | FLOAT |

**Workflow Config** (id:175, active, title: "Upscale Factor 放大倍数"):
```
value = 1.7
```
Feeds into: LatentUpscaleBy `scale_by`, UltimateSDUpscale `upscale_by`, and both SimpleMath+ formulas.

---

## 22. FaceDetailer

- **Source**: https://github.com/ltdrdata/ComfyUI-Impact-Pack (v8.28.0)
- **Purpose**: Automated face detection + inpainting pipeline. Detects faces via bbox detector, optionally refines mask with SAM, crops/enlarges each face to guide_size, runs img2img inpainting, and composites back.

| Parameter | Type | Default | Range | Description |
|-----------|------|---------|-------|-------------|
| `guide_size` | FLOAT | 512 | 64–MAX, step 8 | Target crop resolution |
| `guide_size_for` | BOOLEAN | true | — | true=based on bbox, false=crop_region |
| `max_size` | FLOAT | 1024 | 64–MAX, step 8 | Max resolution cap |
| `seed` | INT | 0 | — | Random seed |
| `steps` | INT | 20 | 1–10000 | Sampling steps |
| `cfg` | FLOAT | 8.0 | 0.0–100.0 | CFG scale |
| `sampler_name` | COMBO | — | — | Sampler |
| `scheduler` | COMBO | — | — | Schedule |
| `denoise` | FLOAT | 0.5 | 0.0001–1.0 | Denoising strength |
| `feather` | INT | 5 | 0–100 | Mask feathering |
| `noise_mask` | BOOLEAN | true | — | Apply noise only in mask |
| `force_inpaint` | BOOLEAN | true | — | Force inpaint |
| `bbox_threshold` | FLOAT | 0.5 | 0.0–1.0 | Detection confidence |
| `bbox_dilation` | INT | 10 | -512–512 | Expand/shrink bbox |
| `bbox_crop_factor` | FLOAT | 3.0 | 1.0–10 | Context around face |
| `sam_detection_hint` | COMBO | — | center-1, horizontal-2, vertical-2, rect-4, diamond-4, mask-area, mask-points, mask-point-bbox, none | SAM prompt point strategy |
| `sam_dilation` | INT | 0 | -512–512 | SAM mask dilation |
| `sam_threshold` | FLOAT | 0.93 | 0.0–1.0 | SAM confidence |
| `sam_bbox_expansion` | INT | 0 | 0–1000 | Expand bbox for SAM |
| `sam_mask_hint_threshold` | FLOAT | 0.7 | 0.0–1.0 | Mask hint threshold |
| `sam_mask_hint_use_negative` | COMBO | — | False, Small, Outter | Negative point strategy |
| `drop_size` | INT | 10 | 1–MAX | Min detection size |
| `wildcard` | STRING | "" | — | Per-face prompt variation |
| `cycle` | INT | 1 | 1–10 | Enhancement passes |
| `inpaint_model` | BOOLEAN | false | — | Use inpaint model mode |
| `noise_mask_feather` | INT | 20 | 0–100 | Noise mask feathering |
| `tiled_encode` | BOOLEAN | false | — | Tiled VAE encode |
| `tiled_decode` | BOOLEAN | false | — | Tiled VAE decode |

| Input | Type | Required |
|-------|------|----------|
| image | IMAGE | yes |
| model | MODEL | yes |
| clip | CLIP | yes |
| vae | VAE | yes |
| positive | CONDITIONING | yes |
| negative | CONDITIONING | yes |
| bbox_detector | BBOX_DETECTOR | yes |
| sam_model_opt | SAM_MODEL | optional |
| segm_detector_opt | SEGM_DETECTOR | optional |
| detailer_hook | DETAILER_HOOK | optional |

| Output | Type | Description |
|--------|------|-------------|
| image | IMAGE | Enhanced image |
| cropped_refined | IMAGE | Cropped face patches |
| cropped_enhanced_alpha | IMAGE | Patches with alpha mask |
| mask | MASK | Detection mask |
| detailer_pipe | DETAILER_PIPE | Bundled pipe for chaining |
| cnet_images | IMAGE | ControlNet images |

**Workflow Config** (id:470, **disabled**):
```
guide_size=1440, guide_size_for=true, max_size=1027, seed=941516485663297,
steps=4, cfg=1, sampler="dpmpp_2m_sde", scheduler="sgm_uniform", denoise=0.4,
feather=100, noise_mask=true, force_inpaint=true, bbox_threshold=0.3,
bbox_dilation=10, bbox_crop_factor=2.5, sam_detection_hint="center-1",
sam_dilation=32, sam_threshold=0.93, sam_bbox_expansion=0,
sam_mask_hint_threshold=0.7, sam_mask_hint_use_negative="False",
drop_size=10, wildcard="", cycle=1, inpaint_model=false,
noise_mask_feather=20, tiled_encode=false, tiled_decode=false
```

---

## 23. SAMLoader

- **Source**: https://github.com/ltdrdata/ComfyUI-Impact-Pack
- **Purpose**: Loads a SAM (Segment Anything) model for mask refinement in FaceDetailer

| Parameter | Type | Options | Description |
|-----------|------|---------|-------------|
| `model_name` | COMBO | Files from `models/sams/` | SAM checkpoint |
| `device_mode` | COMBO | AUTO, Prefer GPU, CPU | Device strategy |

| Output | Type |
|--------|------|
| SAM_MODEL | SAM_MODEL |

**Workflow Config** (id:463, **disabled**):
```
model_name  = "sam_vit_b_01ec64.pth"
device_mode = "AUTO"
```

---

## 24. UltralyticsDetectorProvider

- **Source**: https://github.com/ltdrdata/ComfyUI-Impact-Subpack
- **Purpose**: Loads a YOLO model for face/object bounding box and segmentation detection

| Parameter | Type | Description |
|-----------|------|-------------|
| `model_name` | COMBO | YOLO model from `models/ultralytics/{bbox,segm}/` |

| Output | Type | Description |
|--------|------|-------------|
| BBOX_DETECTOR | BBOX_DETECTOR | Always functional |
| SEGM_DETECTOR | SEGM_DETECTOR | Only for segm/ models |

**Workflow Config** (id:466, **disabled**):
```
model_name = "bbox/face_yolov8m.pt"
```

---

## 25. SeedVR2LoadDiTModel

- **Source**: https://github.com/ainvfx/ComfyUI-SeedVR2_VideoUpscaler
- **Purpose**: Loads the SeedVR2 DiT (Diffusion Transformer) model for AI-based video/image upscaling

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `model` | COMBO | — | DiT checkpoint from `models/seedvr2/` |
| `device` | COMBO | "cuda:0" | GPU device |
| `blocks_to_swap` | INT | 36 | Number of transformer blocks to swap to CPU for VRAM savings |
| `swap_io_components` | BOOLEAN | false | Also swap I/O components to save VRAM |
| `offload_device` | COMBO | "cpu" | Where to offload swapped blocks |
| `cache_model` | BOOLEAN | false | Keep model in memory between runs |
| `attention_mode` | COMBO | "sageattn_3" | Attention backend: sdpa, sageattn, sageattn_2, sageattn_3, flash_attn |

| Output | Type |
|--------|------|
| SEEDVR2_DIT | SEEDVR2_DIT |

**Workflow Config** (id:478, **disabled**):
```
model            = "seedvr2_ema_7b_sharp_fp16.safetensors"
device           = "cuda:0"
blocks_to_swap   = 36
swap_io_components = false
offload_device   = "cpu"
cache_model      = false
attention_mode   = "sageattn_3"
```

---

## 26. SeedVR2LoadVAEModel

- **Source**: https://github.com/ainvfx/ComfyUI-SeedVR2_VideoUpscaler
- **Purpose**: Loads the SeedVR2 VAE for encoding/decoding in the upscaling pipeline

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `model` | COMBO | — | VAE checkpoint |
| `device` | COMBO | "cuda:0" | GPU device |
| `encode_tiled` | BOOLEAN | true | Use tiled encoding |
| `encode_tile_size` | INT | 1024 | Encode tile size |
| `encode_tile_overlap` | INT | 128 | Encode tile overlap |
| `decode_tiled` | BOOLEAN | true | Use tiled decoding |
| `decode_tile_size` | INT | 1024 | Decode tile size |
| `decode_tile_overlap` | INT | 128 | Decode tile overlap |
| `tile_debug` | COMBO | "false" | Show tile boundaries |
| `offload_device` | COMBO | "cpu" | Offload device |
| `cache_model` | BOOLEAN | false | Keep in memory |

| Output | Type |
|--------|------|
| SEEDVR2_VAE | SEEDVR2_VAE |

**Workflow Config** (id:477, **disabled**):
```
model               = "ema_vae_fp16.safetensors"
device              = "cuda:0"
encode_tiled        = true
encode_tile_size    = 1024
encode_tile_overlap = 128
decode_tiled        = true
decode_tile_size    = 1024
decode_tile_overlap = 128
tile_debug          = "false"
offload_device      = "cpu"
cache_model         = false
```

---

## 27. SeedVR2VideoUpscaler

- **Source**: https://github.com/ainvfx/ComfyUI-SeedVR2_VideoUpscaler
- **Purpose**: AI-powered image/video upscaler using the SeedVR2 diffusion transformer. Processes images in tiles with optional color correction.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `seed` | INT | — | Random seed |
| `resolution` | INT | 4096 | Target output resolution |
| `max_resolution` | INT | 4096 | Maximum resolution cap |
| `batch_size` | INT | 1 | Frames per batch (formula: 4n+1) |
| `uniform_batch_size` | BOOLEAN | false | Force uniform batch sizes |
| `color_correction` | COMBO | "lab" | none, lab, wavelet, adaptive | Color correction method |
| `temporal_overlap` | INT | 0 | Frame overlap for video |
| `prepend_frames` | INT | 0 | Prepend frames for temporal coherence |
| `input_noise_scale` | FLOAT | 0.0 | Input noise injection |
| `latent_noise_scale` | FLOAT | 0.0 | Latent space noise |
| `offload_device` | COMBO | "cpu" | Offload device |
| `enable_debug` | BOOLEAN | false | Debug mode |

| Input | Type |
|-------|------|
| image | IMAGE |
| dit | SEEDVR2_DIT |
| vae | SEEDVR2_VAE |

| Output | Type |
|--------|------|
| IMAGE | IMAGE |

**Workflow Config** (id:479, **disabled**):
```
seed               = 1234567890
resolution         = 4096
max_resolution     = 4096
batch_size         = 1
uniform_batch_size = false
color_correction   = "lab"
temporal_overlap   = 0
prepend_frames     = 0
input_noise_scale  = 0
latent_noise_scale = 0
offload_device     = "cpu"
enable_debug       = false
```

---

## Required Models Summary

| Model | Path | Source | Used By |
|-------|------|--------|---------|
| `qwen_3_4b.safetensors` | `text_encoders/` | Qwen 3 4B | CLIPLoader |
| `ae.safetensors` | `vae/` | SD3/Lumina VAE | VAELoader |
| `moodyWildMix_v20BASE45STEPS.safetensors` | `diffusion_models/` | [Civitai](https://civitai.com/models/2384856/moody-wild-mix) (undistilled) | UNETLoader ZIB |
| `moodyPornMix_zitV10DPO.safetensors` | `diffusion_models/` | [Civitai](https://civitai.com/models/620406/moody-porn-mix) | UNETLoader ZIT |
| `4x-UltraSharp.pth` | `upscale_models/` | [OpenModelDB](https://openmodeldb.info/models/4x-UltraSharp) | UpscaleModelLoader |
| `1xSkinContrast-High-SuperUltraCompact.pth` | `upscale_models/` | [OpenModelDB](https://openmodeldb.info/models/1x-SkinContrast-SuperUltraCompact) | UpscaleModelLoader (disabled) |
| `sam_vit_b_01ec64.pth` | `sams/` | Meta SAM | SAMLoader (disabled) |
| `bbox/face_yolov8m.pt` | `ultralytics/` | Ultralytics | UltralyticsDetectorProvider (disabled) |
| `seedvr2_ema_7b_sharp_fp16.safetensors` | `seedvr2/` | [ainvfx](https://github.com/ainvfx/ComfyUI-SeedVR2_VideoUpscaler) | SeedVR2 DiT (disabled) |
| `ema_vae_fp16.safetensors` | `seedvr2/` | ainvfx | SeedVR2 VAE (disabled) |

---

## Compatibility Notes

### Model Family
- **Architecture**: Lumina2-class flow model (AuraFlow-family sampling)
- **Latent channels**: 16-channel — must use `EmptySD3LatentImage`, NOT `EmptyLatentImage` (4-channel SD1.5/SDXL)
- **Text encoder**: Single CLIP via `CLIPLoader` with `type="lumina2"`. Does NOT use `DualCLIPLoader`
- **Noise schedule**: Requires `ModelSamplingAuraFlow` (multiplier=1.0), not `ModelSamplingSD3` (multiplier=1000)

### Conditioning
- **Negative prompt**: Uses `ConditioningZeroOut` (zeroed tensors) instead of text-based negative prompts. Flow models don't use traditional CFG in the same way as SD1.5/SDXL
- **CFG values**: 1st pass uses CFG=4, 2nd pass uses CFG=1 (unconditioned refinement)

### Multi-Pass Pipeline Constraints
- 1st KSampler must set `return_with_leftover_noise="enable"` to pass noisy latent to 2nd pass
- 2nd KSampler must set `add_noise="disable"` since it receives pre-noised latent
- `start_at_step` on 2nd KSampler must be > 0 (typically 4) to skip already-sampled early steps
- Latent upscale (1.7× bislerp) happens BETWEEN the two passes

### Dimension Constraints
- Width/height must be multiples of 16 (EmptySD3LatentImage step size)
- Default: 640×960 (portrait)

### Upscale Pipeline
- `UltimateSDUpscale` requires: IMAGE + MODEL + CONDITIONING + VAE + UPSCALE_MODEL (5 inputs)
- The linked `upscale_by` from `FloatConstant` overrides the widget value
- Tile sizes are dynamically calculated via `SimpleMath+` from `GetImageSize` output
- Formula: `tile = (image_dim × upscale_factor + 256) / 2`

### Cross-Workflow Compatibility
- Output IMAGE from `VAEDecode` or `SaveImage` can feed into Qwen Image Edit workflows for post-generation editing
- Output IMAGE can feed into LTX `LTXVImgToVideoInplace` for image-to-video generation
- Models are NOT interchangeable with LTX (different architecture family) or Qwen Image Edit (different VAE/CLIP)
