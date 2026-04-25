# Qwen Image Edit — Node Configuration Spec

> 14 unique node types (all comfy-core). Uses a subgraph component "Qwen-Image-Edit" encapsulating the edit pipeline.
> Two modes: Normal (20 steps, CFG 2.5) and Turbo (4 steps, CFG 1.0 via Lightning LoRA).

---

## Package Summary

| Package | Repository | Nodes |
|---------|-----------|-------|
| comfy-core | https://github.com/comfyanonymous/ComfyUI | CLIPLoader, CFGNorm, ComfySwitchNode, ImageScaleToTotalPixels, KSampler, LoadImage, LoraLoaderModelOnly, ModelSamplingAuraFlow, PrimitiveBoolean, PrimitiveFloat, PrimitiveInt, SaveImage, TextEncodeQwenImageEdit, UNETLoader, VAEDecode, VAEEncode, VAELoader |
| comfy-core (frontend) | https://github.com/Comfy-Org/ComfyUI_frontend | MarkdownNote |

---

## Workflow Architecture

**Outer graph:**
```
[LoadImage] ──→ IMAGE ──┬──→ [ImageScaleToTotalPixels] (output disconnected)
                        └──→ [Qwen-Image-Edit subgraph] ──→ [SaveImage]
```

**Inside subgraph:**
```
[UNETLoader] ──→ MODEL ──┬──→ [LoraLoaderModelOnly] ──→ Switch(model) ──┐
                          └────────────────────────────→ Switch(model) ──┘
                                                              │
                            [PrimitiveBoolean: enable_turbo] ──┤
                                  ├──→ Switch(Steps): 20 vs 4  │
                                  └──→ Switch(CFG): 2.5 vs 1.0 │
                                                              ▼
                          MODEL ──→ [ModelSamplingAuraFlow] ──→ [CFGNorm] ──→ KSampler
                                                                                │
[CLIPLoader] ──→ CLIP ──┬──→ [TextEncodeQwenImageEdit (positive+prompt)] ──→ KSampler
                        └──→ [TextEncodeQwenImageEdit (negative, empty)] ──→ KSampler
                                                                                │
[VAELoader] ──→ VAE ──┬──→ TextEncodeQwenImageEdit (both)                       │
                      ├──→ [VAEEncode] ──→ LATENT ──→ KSampler ──→ [VAEDecode] ──→ OUTPUT
                      └──→ VAEDecode
```

**Single-pass image editing**: Input image is VAE-encoded, conditioned with edit prompt via Qwen VL encoder, sampled, and decoded.

---

## 1. LoadImage

- **Source**: https://github.com/comfyanonymous/ComfyUI (`nodes.py`)
- **Purpose**: Loads an image from disk for editing

| Parameter | Type | Description |
|-----------|------|-------------|
| `image` | COMBO | Image file to load |
| `upload` | — | Upload widget |

| Output | Type |
|--------|------|
| IMAGE | IMAGE |
| MASK | MASK |

**Workflow Config** (id:78, active):
```
image = "image_qwen_image_edit_input_image.png"
```

---

## 2. ImageScaleToTotalPixels

- **Source**: https://github.com/comfyanonymous/ComfyUI (`comfy_extras/nodes_post_processing.py`)
- **Purpose**: Rescales an image to a target megapixel count, preserving aspect ratio. Prevents oversized inputs from degrading output quality.

| Parameter | Type | Default | Options/Range | Description |
|-----------|------|---------|---------------|-------------|
| `upscale_method` | COMBO | — | lanczos, nearest-exact, bilinear, area, bicubic, bislerp | Interpolation method |
| `megapixels` | FLOAT | 1.0 | 0.01–16.0 | Target total megapixels |
| `resolution_steps` | INT | 1 | 1–1024 | Round dimensions to multiple of this |

| Input | Type |
|-------|------|
| image | IMAGE |

| Output | Type |
|--------|------|
| IMAGE | IMAGE |

**Workflow Config** (id:93, active, **output disconnected**):
```
upscale_method   = "lanczos"
megapixels       = 1.5
resolution_steps = 1
```

> **Note**: This node receives the input image but its output is not connected — it's available for the user to wire in as a pre-processing step if the input is too large.

---

## 3. UNETLoader

- **Source**: https://github.com/comfyanonymous/ComfyUI (`nodes.py`)
- **Purpose**: Loads the Qwen Image Edit diffusion model

| Parameter | Type | Options | Description |
|-----------|------|---------|-------------|
| `unet_name` | COMBO | Files from `models/diffusion_models/` | Model checkpoint |
| `weight_dtype` | COMBO | default, fp8_e4m3fn, fp8_e4m3fn_fast, fp8_e5m2 | Weight precision |

| Output | Type |
|--------|------|
| MODEL | MODEL |

**Workflow Config** (id:37, active):
```
unet_name    = "qwen_image_edit_fp8_e4m3fn.safetensors"
weight_dtype = "default"
```

---

## 4. CLIPLoader

- **Source**: https://github.com/comfyanonymous/ComfyUI (`comfy_extras/nodes_clip.py`)
- **Purpose**: Loads the Qwen 2.5 VL 7B vision-language text encoder

| Parameter | Type | Options | Description |
|-----------|------|---------|-------------|
| `clip_name` | COMBO | Files from `models/text_encoders/` | CLIP model filename |
| `type` | COMBO | stable_diffusion, stable_cascade, sd3, stable_audio, mochi, ltxv, pixart, cosmos, lumina2, wan, hidream, qwen_image, ... | Architecture type |
| `device` | COMBO | default, cpu | Device to load model on |

| Output | Type |
|--------|------|
| CLIP | CLIP |

**Workflow Config** (id:38, active):
```
clip_name = "qwen_2.5_vl_7b_fp8_scaled.safetensors"
type      = "qwen_image"
device    = "default"
```

---

## 5. VAELoader

- **Source**: https://github.com/comfyanonymous/ComfyUI (`nodes.py`)
- **Purpose**: Loads the Qwen Image VAE for encoding/decoding between pixel and latent space

| Parameter | Type | Description |
|-----------|------|-------------|
| `vae_name` | COMBO | VAE model file from `models/vae/` |

| Output | Type |
|--------|------|
| VAE | VAE |

**Workflow Config** (id:39, active):
```
vae_name = "qwen_image_vae.safetensors"
```

---

## 6. TextEncodeQwenImageEdit

- **Source**: https://github.com/comfyanonymous/ComfyUI (`comfy_extras/nodes_qwen.py`)
- **Purpose**: Encodes an edit prompt with the input image into CONDITIONING using the Qwen VL encoder. The image provides visual context so the model understands what to edit.

| Input | Type | Required | Description |
|-------|------|----------|-------------|
| clip | CLIP | yes | Qwen VL CLIP model |
| vae | VAE | optional | VAE for image encoding |
| image | IMAGE | optional | Source image for edit context |
| prompt | STRING | yes | Edit instruction text |

| Output | Type |
|--------|------|
| CONDITIONING | CONDITIONING |

**Workflow Config**:

| Instance | ID | Role | Prompt | Image |
|----------|----|------|--------|-------|
| Positive | 76 | Edit instruction | `"Remove all UI text elements from the image. Keep the feeling that the characters and scene are in water. Also, remove the green UI elements at the bottom."` | linked |
| Negative | 77 | Empty conditioning | `""` (empty) | linked |

> Both instances receive the input image and VAE. The positive prompt describes the desired edit; the negative has an empty prompt to create unconditional conditioning.

---

## 7. VAEEncode

- **Source**: https://github.com/comfyanonymous/ComfyUI (`nodes.py`)
- **Purpose**: Encodes the input image into latent space for sampling

| Input | Type |
|-------|------|
| pixels | IMAGE |
| vae | VAE |

| Output | Type |
|--------|------|
| LATENT | LATENT |

**Workflow Config** (id:88, active): Encodes the input image to provide the initial latent for KSampler.

---

## 8. LoraLoaderModelOnly

- **Source**: https://github.com/comfyanonymous/ComfyUI (`nodes.py`)
- **Purpose**: Loads and applies a LoRA to the model only (no CLIP modification). Used for the 4-step Lightning acceleration LoRA.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `lora_name` | COMBO | — | LoRA file from `models/loras/` |
| `strength_model` | FLOAT | 1.0 | LoRA strength |

| Input | Type |
|-------|------|
| model | MODEL |

| Output | Type |
|--------|------|
| MODEL | MODEL (with LoRA applied) |

**Workflow Config** (id:89, active):
```
lora_name      = "Qwen-Image-Edit-Lightning-4steps-V1.0-bf16.safetensors"
strength_model = 1.0
```

> The LoRA output only reaches KSampler when turbo mode is enabled (via ComfySwitchNode).

---

## 9. ComfySwitchNode

- **Source**: https://github.com/comfyanonymous/ComfyUI (`comfy_extras/nodes_logic.py`, experimental)
- **Purpose**: Routes one of two inputs based on a boolean switch. Used to toggle between normal and turbo mode parameters.

| Input | Type | Description |
|-------|------|-------------|
| on_false | * | Value when switch is false |
| on_true | * | Value when switch is true |
| switch | BOOLEAN | Selector |

| Output | Type |
|--------|------|
| output | * (same type as inputs) |

**Workflow Config**:

| Instance | ID | Title | on_false | on_true | Purpose |
|----------|----|-------|----------|---------|---------|
| Model | 108 | Switch (model) | Base model | Base + LoRA | Toggle Lightning LoRA |
| Steps | 110 | Switch (Steps) | 20 | 4 | Toggle step count |
| CFG | 109 | Switch (CFG) | 2.5 | 1.0 | Toggle guidance scale |

All three are driven by the same PrimitiveBoolean (id:111).

---

## 10. ModelSamplingAuraFlow

- **Source**: https://github.com/comfyanonymous/ComfyUI (`comfy_extras/nodes_model_advanced.py`)
- **Purpose**: Modifies the model's noise schedule using AuraFlow-style sampling

| Parameter | Type | Default | Range | Description |
|-----------|------|---------|-------|-------------|
| `shift` | FLOAT | 1.73 | 0.0–100.0 | Noise schedule shift factor |

| Input | Type |
|-------|------|
| model | MODEL |

| Output | Type |
|--------|------|
| MODEL | MODEL (modified sampling) |

**Workflow Config** (id:66, active):
```
shift = 3
```

---

## 11. CFGNorm

- **Source**: https://github.com/comfyanonymous/ComfyUI (`comfy_extras/nodes_cfg.py`, experimental)
- **Purpose**: Normalizes the CFG (classifier-free guidance) output. Patches the model to apply CFG normalization at the given strength.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `strength` | FLOAT | 1.0 | Normalization strength |

| Input | Type |
|-------|------|
| model | MODEL |

| Output | Type |
|--------|------|
| patched_model | MODEL |

**Workflow Config** (id:75, active):
```
strength = 1
```

---

## 12. KSampler

- **Source**: https://github.com/comfyanonymous/ComfyUI (`nodes.py`)
- **Purpose**: Main sampler node — denoises the latent using the conditioned model

| Parameter | Type | Default | Options/Range | Description |
|-----------|------|---------|---------------|-------------|
| `seed` | INT | 0 | 0–0xffffffffffffffff | Random seed |
| `control_after_generate` | COMBO | — | fixed, increment, decrement, randomize | Seed behavior |
| `steps` | INT | 20 | 1–10000 | Sampling steps (linked from Switch) |
| `cfg` | FLOAT | 8.0 | 0.0–100.0 | CFG scale (linked from Switch) |
| `sampler_name` | COMBO | — | euler, dpmpp_2m_sde, etc. | Sampler algorithm |
| `scheduler` | COMBO | — | normal, karras, simple, etc. | Noise schedule |
| `denoise` | FLOAT | 1.0 | 0.0–1.0 | Denoising strength |

| Input | Type |
|-------|------|
| model | MODEL |
| positive | CONDITIONING |
| negative | CONDITIONING |
| latent_image | LATENT |

| Output | Type |
|--------|------|
| LATENT | LATENT |

**Workflow Config** (id:3, active):
```
seed                   = 344147753686358
control_after_generate = "randomize"
steps                  = 4  (widget) / linked from Switch(Steps)
cfg                    = 1  (widget) / linked from Switch(CFG)
sampler_name           = "euler"
scheduler              = "simple"
denoise                = 1
```

> The `steps` and `cfg` widget values are overridden by linked Switch outputs. Effective values depend on turbo mode toggle.

**Reference settings from workflow:**

| Mode | Steps | CFG | Notes |
|------|-------|-----|-------|
| Official (full model) | 50 | 4.0 | Highest quality |
| Comfy default | 20 | 2.5 | Good balance |
| fp8 + 4-step LoRA | 4 | 1.0 | Fast, turbo mode |

---

## 13. VAEDecode

- **Source**: https://github.com/comfyanonymous/ComfyUI (`nodes.py`)
- **Purpose**: Decodes latent tensor back to pixel space

| Input | Type |
|-------|------|
| samples | LATENT |
| vae | VAE |

| Output | Type |
|--------|------|
| IMAGE | IMAGE |

**Workflow Config** (id:8, active): Decodes KSampler output to final image.

---

## 14. SaveImage

- **Source**: https://github.com/comfyanonymous/ComfyUI (`nodes.py`)
- **Purpose**: Saves the edited image to disk

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `filename_prefix` | STRING | "ComfyUI" | Filename prefix with optional date tokens |

| Input | Type |
|-------|------|
| images | IMAGE |

**Workflow Config** (id:60, active):
```
filename_prefix = "ComfyUI"
```

---

## Primitive / Utility Nodes

### PrimitiveInt

- **Source**: https://github.com/comfyanonymous/ComfyUI (`comfy_extras/nodes_primitive.py`)
- **Purpose**: Stores and outputs a constant integer value

| Instance | ID | Title | Value | Feeds |
|----------|----|-------|-------|-------|
| Normal steps | 106 | Steps | `20` (fixed) | Switch(Steps) on_false |
| Turbo steps | 103 | Steps | `4` (fixed) | Switch(Steps) on_true |

### PrimitiveFloat

- **Source**: https://github.com/comfyanonymous/ComfyUI (`comfy_extras/nodes_primitive.py`)
- **Purpose**: Stores and outputs a constant float value

| Instance | ID | Title | Value | Feeds |
|----------|----|-------|-------|-------|
| Normal CFG | 107 | CFG | `2.5` | Switch(CFG) on_false |
| Turbo CFG | 105 | CFG | `1.0` | Switch(CFG) on_true |

### PrimitiveBoolean

- **Source**: https://github.com/comfyanonymous/ComfyUI (`comfy_extras/nodes_primitive.py`)
- **Purpose**: Master toggle for turbo mode

| Instance | ID | Title | Value | Feeds |
|----------|----|-------|-------|-------|
| Turbo toggle | 111 | Enable 4steps LoRA | `false` | All three ComfySwitchNodes |

### MarkdownNote

- **Source**: https://github.com/Comfy-Org/ComfyUI_frontend (`src/extensions/core/noteNode.ts`)
- **Purpose**: Frontend-only UI annotation node (no execution). Displays markdown text in the canvas.

| Instance | ID | Title | Content |
|----------|----|-------|---------|
| Tutorial | 99 | For Local User | Model download links, storage layout, issue reporting |
| Scale warning | 96 | — | Warning about large input images |
| KSampler ref | 97 | KSampler settings | Reference table for steps/cfg per mode |

---

## Required Models Summary

| Model | Path | Source | Used By |
|-------|------|--------|---------|
| `qwen_image_edit_fp8_e4m3fn.safetensors` | `diffusion_models/` | [Comfy-Org/Qwen-Image-Edit_ComfyUI](https://huggingface.co/Comfy-Org/Qwen-Image-Edit_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_edit_fp8_e4m3fn.safetensors) | UNETLoader |
| `qwen_2.5_vl_7b_fp8_scaled.safetensors` | `text_encoders/` | [Comfy-Org/Qwen-Image_ComfyUI](https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors) | CLIPLoader |
| `qwen_image_vae.safetensors` | `vae/` | [Comfy-Org/Qwen-Image_ComfyUI](https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/vae/qwen_image_vae.safetensors) | VAELoader |
| `Qwen-Image-Edit-Lightning-4steps-V1.0-bf16.safetensors` | `loras/` | [lightx2v/Qwen-Image-Lightning](https://huggingface.co/lightx2v/Qwen-Image-Lightning/resolve/main/Qwen-Image-Edit-Lightning-4steps-V1.0-bf16.safetensors) | LoraLoaderModelOnly |

---

## Compatibility Notes

### Model Family
- **Architecture**: Qwen Image Edit — a diffusion transformer using Qwen 2.5 VL as the text/vision encoder
- **Text encoder**: Single CLIP via `CLIPLoader` with `type="qwen_image"`. Uses vision-language model (not text-only)
- **Noise schedule**: Uses `ModelSamplingAuraFlow` with shift=3 (same as Moody/Lumina2 workflows)
- **CFG normalization**: Applies `CFGNorm` (experimental) after `ModelSamplingAuraFlow` — unique to this workflow

### Image Editing Pipeline
- **Input requirement**: Requires a source image — this is an image-to-image edit workflow, NOT text-to-image generation
- **Conditioning**: Uses `TextEncodeQwenImageEdit` which takes image + prompt together (not standard `CLIPTextEncode`)
- **Negative conditioning**: Empty-prompt `TextEncodeQwenImageEdit` with the source image (not `ConditioningZeroOut`)
- **Latent initialization**: Source image is `VAEEncode`d to provide the starting latent (denoise=1.0 — full re-generation guided by conditioning)

### Turbo Mode Toggle
- The `PrimitiveBoolean` → 3× `ComfySwitchNode` pattern simultaneously switches model (±LoRA), steps (20→4), and CFG (2.5→1.0)
- When turbo is OFF: base model runs 20 steps at CFG 2.5
- When turbo is ON: base + Lightning LoRA runs 4 steps at CFG 1.0
- The LoRA is always loaded but only routed to the sampler when turbo is enabled

### Subgraph Component
- The core pipeline is wrapped in a subgraph node (type `74a8e1e2-9cb8-4112-978e-06ce1b5793f1`)
- External inputs exposed: image, prompt, unet_name, clip_name, vae_name, lora_name, enable_turbo_mode
- When composing new workflows, either use the subgraph as a black box or inline its nodes

### Disconnected Node
- `ImageScaleToTotalPixels` (id:93) receives input but output is unwired — user can optionally connect it as a pre-processor to limit input resolution to 1.5 megapixels

### Cross-Workflow Compatibility
- Output IMAGE can feed into Moody's `UltimateSDUpscale` for upscaling edited images
- Output IMAGE can feed into LTX `LTXVImgToVideoInplace` for animating edited images
- Can receive IMAGE output from Moody `VAEDecode` or `SaveImage` as edit input
- Models are NOT interchangeable — Qwen uses its own VAE, CLIP, and diffusion model
