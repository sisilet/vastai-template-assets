# ComfyUI Custom Node Configuration Specs

---

## 1. UltimateSDUpscale

- **Source**: [ssitu/ComfyUI_UltimateSDUpscale](https://github.com/ssitu/ComfyUI_UltimateSDUpscale)
- **Node Class**: `UltimateSDUpscale`
- **Purpose**: Combines image upscaling with tiled image-to-image processing. An upscale model first scales the image by `upscale_by`, then tiles are redrawn via img2img sampling using the given model/prompt/sampler, and optionally seam-fixed between tiles. Produces high-quality detail-enhanced upscaled images while keeping tile sizes within the diffusion model's trained resolution.

### Inputs

| Parameter | Type | Input Method | Description |
|---|---|---|---|
| `image` | IMAGE | Connection | The image to upscale |
| `model` | MODEL | Connection | The diffusion model for img2img on each tile |
| `positive` | CONDITIONING | Connection | Positive conditioning for tile redraw |
| `negative` | CONDITIONING | Connection | Negative conditioning for tile redraw |
| `vae` | VAE | Connection | VAE model for encoding/decoding tiles |
| `upscale_model` | UPSCALE_MODEL | Connection | Upscaler model (e.g. 4x-UltraSharp). If omitted, Lanczos scaling is used |

### Widgets/Config

| Parameter | Type | Default | Range / Options | Description |
|---|---|---|---|---|
| `upscale_by` | FLOAT | 2.0 | 0.05–4.0 (step 0.05) | Scale factor for the image dimensions |
| `seed` | INT | 0 | 0–2^64 | Seed for reproducible img2img sampling |
| `steps` | INT | 20 | 1–10000 | Sampling steps per tile |
| `cfg` | FLOAT | 8.0 | 0.0–100.0 | CFG scale for each tile |
| `sampler_name` | COMBO | — | All KSampler samplers | Sampler algorithm |
| `scheduler` | COMBO | — | All KSampler schedulers | Noise scheduler |
| `denoise` | FLOAT | 0.2 | 0.0–1.0 (step 0.01) | Denoising strength per tile. Lower (0.05–0.2) preserves original; higher allows more creative changes but causes seams |
| `mode_type` | COMBO | — | Linear, Chess, None | Tiling order. **Linear**: row-by-row. **Chess**: checkerboard pattern (reduces seams). **None**: skip redraw entirely |
| `tile_width` | INT | 512 | 64–8192 (step 8) | Base width of each tile |
| `tile_height` | INT | 512 | 64–8192 (step 8) | Base height of each tile |
| `mask_blur` | INT | 8 | 0–64 | Blur radius for tile mask blending |
| `tile_padding` | INT | 32 | 0–8192 (step 8) | Padding around tiles for context overlap |
| `seam_fix_mode` | COMBO | — | None, Band Pass, Half Tile, Half Tile + Intersections | Seam fix strategy. **Band Pass**: band areas between tiles. **Half Tile**: half-tile overlapping. **Half Tile + Intersections**: most thorough |
| `seam_fix_denoise` | FLOAT | 1.0 | 0.0–1.0 (step 0.01) | Denoise strength for seam fix pass |
| `seam_fix_width` | INT | 64 | 0–8192 (step 8) | Band width for Band Pass seam fix |
| `seam_fix_mask_blur` | INT | 8 | 0–64 | Blur radius for seam fix mask |
| `seam_fix_padding` | INT | 16 | 0–8192 (step 8) | Padding for seam fix tiles |
| `force_uniform_tiles` | BOOLEAN | True | True/False | Force all tiles to set size (required when batch_size > 1). Prevents irregular sizes at image edges |
| `tiled_decode` | BOOLEAN | False | True/False | Use tiled VAE decoding to save VRAM |
| `batch_size` | INT | 1 | 1+ | Number of tiles to process simultaneously. Requires `force_uniform_tiles=True` if > 1 |

### Outputs

| Name | Type | Description |
|---|---|---|
| IMAGE | IMAGE | The final upscaled image |

### Workflow Config (id:170)

```
upscale_by = 2.5
seed = 677826103351453
control_after_generate = "fixed"
steps = 3
cfg = 1
sampler_name = "dpmpp_2m_sde"
scheduler = "sgm_uniform"
denoise = 0.27
mode_type = "Chess"
tile_width = 1024
tile_height = 1024
mask_blur = 64
tile_padding = 128
seam_fix_mode = "None"
seam_fix_denoise = 1
seam_fix_width = 64
seam_fix_mask_blur = 8
seam_fix_padding = 16
force_uniform_tiles = true
tiled_decode = false
batch_size = 1
```

### Notes

- Tile sizes are typically set to match the model's trained resolution (512×512 for SD1.5, 1024×1024 for SDXL/Flux).
- Low denoise (0.05–0.2) refines without hallucinations; high denoise needs ControlNet tile to avoid seams.
- The seam fix step significantly increases processing time — often better to reduce denoise or increase tile size.
- `control_after_generate` is a ComfyUI frontend widget (not part of the node logic), controlling seed behavior between runs.

---

## 2. SimpleMath+

- **Source**: [cubiq/ComfyUI_essentials](https://github.com/cubiq/ComfyUI_essentials) — `misc.py`
- **Node Class**: `SimpleMath` (registered as `SimpleMath+`)
- **Purpose**: Evaluates a mathematical expression string using input variables `a`, `b`, `c` (and optionally `d`). Supports arithmetic, comparisons, boolean logic, and functions (`min`, `max`, `round`, `sum`, `len`). Can also operate on tensor shapes (extracting shape as a list) and string-to-float conversion.

### Inputs

| Parameter | Type | Required | Description |
|---|---|---|---|
| `value` | STRING | **Yes** | Math expression to evaluate. Variables: `a`, `b`, `c`, `d`. Operators: `+`, `-`, `*`, `/`, `//`, `%`, `**`. Comparisons: `==`, `!=`, `<`, `<=`, `>`, `>=`. Logic: `and`, `or`, `not`. Functions: `min()`, `max()`, `round()`, `sum()`, `len()`. Indexing: `a[0]` |
| `a` | * (ANY) | No | First input variable (default 0.0). Accepts INT, FLOAT, STRING, or tensor (shape extracted) |
| `b` | * (ANY) | No | Second input variable (default 0.0) |
| `c` | * (ANY) | No | Third input variable (default 0.0) |

### Widgets/Config

| Parameter | Type | Default | Description |
|---|---|---|---|
| `value` | STRING | `""` | The formula/expression string |

### Outputs

| Name | Type | Description |
|---|---|---|
| INT | INT | Result rounded to integer |
| FLOAT | FLOAT | Result as float |

### Workflow Config

**id:172** — title: "Calculate optimized height"
```
value = "(a*b + (128 * 2))/2"
```

**id:176** — title: "Calculate optimized width"
```
value = "(a*b + (128 * 2))/2"
```

### Notes

- Uses Python `ast` module for safe expression evaluation — no `eval()`.
- If inputs are tensors, their `.shape` is extracted as a list and used as the variable value.
- String inputs are auto-converted to float.
- NaN results are replaced with 0.0.
- In this workflow, calculates: `(upscale_factor × dimension + 256) / 2` — producing optimized tile dimensions for the upscaler that account for padding.

---

## 3. MaskPreview+

- **Source**: [cubiq/ComfyUI_essentials](https://github.com/cubiq/ComfyUI_essentials) — `mask.py`
- **Node Class**: `MaskPreview` (registered as `MaskPreview+`)
- **Purpose**: Previews a mask by converting it to a grayscale image and saving as a temp preview. Extends ComfyUI's built-in `SaveImage` node.

### Inputs

| Parameter | Type | Required | Description |
|---|---|---|---|
| `mask` | MASK | **Yes** | The mask tensor to preview |

### Hidden Inputs

| Parameter | Description |
|---|---|
| `prompt` | PROMPT (auto-provided) |
| `extra_pnginfo` | EXTRA_PNGINFO (auto-provided) |

### Widgets/Config

None — this is a preview-only node with no configurable parameters.

### Outputs

Output node (preview display only) — saves temp images to ComfyUI's temp directory.

### Workflow Config (id:464)

```
mode = 4  (disabled/bypassed in this workflow)
```

### Notes

- Converts the mask to a 3-channel grayscale image for display: `mask → [B, 1, H, W] → [B, H, W, 3]`.
- Uses `compress_level = 4` for temp PNG output.
- Mode 4 in ComfyUI means the node is **bypassed/disabled** — it won't execute during workflow runs.

---

## 4. FloatConstant

- **Source**: [kijai/ComfyUI-KJNodes](https://github.com/kijai/ComfyUI-KJNodes) — `nodes/nodes.py`
- **Node Class**: `FloatConstant`
- **Purpose**: Stores and outputs a single constant float value. Simple utility node for parameterizing workflows.

### Inputs

None (purely widget-driven).

### Widgets/Config

| Parameter | Type | Default | Range | Step | Description |
|---|---|---|---|---|---|
| `value` | FLOAT | 0.0 | -2^64 to 2^64 | 0.00001 | The float constant value |

### Outputs

| Name | Type | Description |
|---|---|---|
| value | FLOAT | The stored float value (rounded to 6 decimal places) |

### Workflow Config (id:175)

```
title = "Upscale Factor 放大倍数"
value = 1.7
```

### Notes

- Output is `round(value, 6)` to avoid floating-point precision issues.
- Part of the KJNodes constants family: `BOOLConstant`, `INTConstant`, `FloatConstant`, `StringConstant`, `StringConstantMultiline`.
- In this workflow, feeds the upscale factor (1.7×) into the SimpleMath+ nodes for tile dimension calculations.

---

## 5. SeedVR2LoadDiTModel

- **Source**: [ainvfx/ComfyUI-SeedVR2_VideoUpscaler](https://github.com/ainvfx/ComfyUI-SeedVR2_VideoUpscaler) (fork of numz/ComfyUI-SeedVR2_VideoUpscaler)
- **Node Class**: `SeedVR2LoadDiTModel`
- **Purpose**: Loads and configures the SeedVR2 DiT (Diffusion Transformer) model for video/image upscaling. Handles model selection, device placement, memory optimization (BlockSwap), and attention backend configuration.

### Inputs

| Parameter | Type | Required | Description |
|---|---|---|---|
| `torch_compile_args` | Connection | No | Optional connection from SeedVR2 Torch Compile Settings node for 20–40% speedup |

### Widgets/Config

| Parameter | Type | Default | Options / Range | Description |
|---|---|---|---|---|
| `model` | COMBO | — | 3B models: `seedvr2_ema_3b_fp16.safetensors`, `seedvr2_ema_3b_fp8_e4m3fn.safetensors`, `seedvr2_ema_3b-Q4_K_M.gguf`, `seedvr2_ema_3b-Q8_0.gguf`; 7B models: `seedvr2_ema_7b_fp16.safetensors`, `seedvr2_ema_7b_fp8_e4m3fn_mixed_block35_fp16.safetensors`, `seedvr2_ema_7b-Q4_K_M.gguf`, `seedvr2_ema_7b_sharp_*` variants | DiT model file. 3B = faster/less VRAM; 7B = higher quality |
| `device` | COMBO | `cuda:0` | `cuda:0`, `cuda:1`, etc. | GPU device for DiT inference |
| `blocks_to_swap` | INT | 0 | 0–32 (3B) / 0–36 (7B) | Number of transformer blocks to swap between GPU and CPU. Higher = more VRAM savings but slower. Requires `offload_device` ≠ `none` |
| `swap_io_components` | BOOLEAN | False | True/False | Offload input/output embeddings and normalization layers. Additional VRAM savings with BlockSwap |
| `offload_device` | COMBO | `none` | `none`, `cpu`, `cuda:X` | Device for model offloading when not processing. `none` = keep on GPU (fastest) |
| `cache_model` | BOOLEAN | False | True/False | Keep model loaded between workflow runs. Requires `offload_device` to be set |
| `attention_mode` | COMBO | `sdpa` | `sdpa`, `flash_attn_2`, `flash_attn_3`, `sageattn_2`, `sageattn_3` | Attention backend. `sdpa` always available; Flash/Sage require additional packages |

### Outputs

| Name | Type | Description |
|---|---|---|
| SEEDVR2_DIT | SEEDVR2_DIT | Configured DiT model object |

### Workflow Config (id:478)

```
mode = 4  (disabled/bypassed)
model = "seedvr2_ema_7b_sharp_fp16.safetensors"
device = "cuda:0"
blocks_to_swap = 36
swap_io_components = false
offload_device = "cpu"
cache_model = false
attention_mode = "sageattn_3"
```

### Notes

- Models auto-download from HuggingFace on first use to `ComfyUI/models/SEEDVR2`.
- **BlockSwap** dynamically swaps transformer blocks between GPU and CPU during inference — start at 16, increase to 24/32/36 if OOM persists.
- BlockSwap is **not available on macOS** (unified memory makes it meaningless).
- For 8GB VRAM: use GGUF Q8 model + `blocks_to_swap=32` + `swap_io_components=True` + `offload_device=cpu`.
- This node is **disabled** (mode 4) in the current workflow — SeedVR2 upscaling is not active.

---

## 6. SeedVR2LoadVAEModel

- **Source**: [ainvfx/ComfyUI-SeedVR2_VideoUpscaler](https://github.com/ainvfx/ComfyUI-SeedVR2_VideoUpscaler)
- **Node Class**: `SeedVR2LoadVAEModel`
- **Purpose**: Loads and configures the SeedVR2 VAE (Variational Autoencoder) for encoding input frames to latent space and decoding upscaled latents back to pixel space. Supports tiled encoding/decoding for high-resolution processing with limited VRAM.

### Inputs

| Parameter | Type | Required | Description |
|---|---|---|---|
| `torch_compile_args` | Connection | No | Optional connection from SeedVR2 Torch Compile Settings for 15–25% speedup |

### Widgets/Config

| Parameter | Type | Default | Options / Range | Description |
|---|---|---|---|---|
| `model` | COMBO | — | `ema_vae_fp16.safetensors` (recommended) | VAE model file |
| `device` | COMBO | `cuda:0` | `cuda:0`, `cuda:1`, etc. | GPU device for VAE inference |
| `encode_tiled` | BOOLEAN | False | True/False | Enable tiled encoding for large inputs. Use if OOM during "Encoding" phase |
| `encode_tile_size` | INT | 1024 | px | Encoding tile size (both H and W). Lower reduces VRAM |
| `encode_tile_overlap` | INT | 128 | px | Encoding tile overlap to reduce seams |
| `decode_tiled` | BOOLEAN | False | True/False | Enable tiled decoding. Use if OOM during "Decoding" phase |
| `decode_tile_size` | INT | 1024 | px | Decoding tile size |
| `decode_tile_overlap` | INT | 128 | px | Decoding tile overlap |
| `tile_debug` | COMBO | `false` | `false`, `encode`, `decode` | Visualize tile boundaries for debugging |
| `offload_device` | COMBO | `none` | `none`, `cpu`, `cuda:X` | Device for model offloading when not processing |
| `cache_model` | BOOLEAN | False | True/False | Keep model loaded between runs |

### Outputs

| Name | Type | Description |
|---|---|---|
| SEEDVR2_VAE | SEEDVR2_VAE | Configured VAE model object |

### Workflow Config (id:477)

```
mode = 4  (disabled/bypassed)
model = "ema_vae_fp16.safetensors"
device = "cuda:0"
encode_tiled = true
encode_tile_size = 1024
encode_tile_overlap = 128
decode_tiled = true
decode_tile_size = 1024
decode_tile_overlap = 128
tile_debug = "false"
offload_device = "cpu"
cache_model = false
```

### Notes

- The VAE is often the **bottleneck** — even with fast DiT processing, VAE encode/decode can be slow at high resolutions.
- If seeing tile seams in output, **increase** overlap (default 128 is usually sufficient).
- If seeing OOM during encoding, reduce `encode_tile_size` (try 768, 512).
- This node is **disabled** (mode 4) in the current workflow.

---

## 7. SeedVR2VideoUpscaler

- **Source**: [ainvfx/ComfyUI-SeedVR2_VideoUpscaler](https://github.com/ainvfx/ComfyUI-SeedVR2_VideoUpscaler)
- **Node Class**: `SeedVR2VideoUpscaler`
- **Purpose**: Main upscaling node. Processes video frames (or single images) through the SeedVR2 one-step diffusion pipeline using DiT and VAE models. Handles batching with temporal consistency, color correction, noise injection, and intermediate tensor offloading.

### Inputs

| Parameter | Type | Required | Description |
|---|---|---|---|
| `image` | IMAGE | **Yes** | Input video frames as image batch (RGB or RGBA) |
| `dit` | SEEDVR2_DIT | **Yes** | DiT model from SeedVR2LoadDiTModel node |
| `vae` | SEEDVR2_VAE | **Yes** | VAE model from SeedVR2LoadVAEModel node |

### Widgets/Config

| Parameter | Type | Default | Range / Options | Description |
|---|---|---|---|---|
| `seed` | INT | 42 | 0–2^64 | Random seed for reproducible generation |
| `resolution` | INT | 1080 | px | Target resolution for shortest edge. Maintains aspect ratio |
| `max_resolution` | INT | 0 | 0 = no limit | Maximum resolution for any edge. Auto-scales down if exceeded |
| `batch_size` | INT | 5 | **Must follow 4n+1**: 1, 5, 9, 13, 17, 21, 25... | Frames per batch. Critical for temporal consistency architecture. Ideally match shot length. Higher = better quality + speed but more VRAM |
| `uniform_batch_size` | BOOLEAN | False | True/False | Pad final batch to match `batch_size`. Prevents temporal artifacts when last batch is significantly smaller |
| `color_correction` | COMBO | `wavelet` | `lab`, `wavelet`, `wavelet_adaptive`, `hsv`, `adain`, `none` | Color correction method. **lab** = perceptual, recommended for highest fidelity. **wavelet** = frequency-based, natural |
| `temporal_overlap` | INT | 0 | 0–16 frames | Overlapping frames between batches for smooth blending |
| `prepend_frames` | INT | 0 | 0–32 frames | Prepend reversed frames to reduce start artifacts (auto-removed after processing) |
| `input_noise_scale` | FLOAT | 0.0 | 0.0–1.0 | Noise added to input frames. Try 0.1–0.3 for high-resolution artifact reduction |
| `latent_noise_scale` | FLOAT | 0.0 | 0.0–1.0 | Noise in latent space during diffusion. Try 0.05–0.15 if `input_noise` doesn't help |
| `offload_device` | COMBO | `cpu` | `none`, `cpu`, `cuda:X` | Device for intermediate tensors between processing phases |
| `enable_debug` | BOOLEAN | False | True/False | Verbose logging with memory usage, timing, and processing details |

### Outputs

| Name | Type | Description |
|---|---|---|
| IMAGE | IMAGE | Upscaled video frames. Format (RGB/RGBA) matches input. Range [0, 1] normalized |

### Workflow Config (id:479)

```
mode = 4  (disabled/bypassed)
seed = 1234567890
control_after_generate = "fixed"
resolution = 4096
max_resolution = 4096
batch_size = 1
uniform_batch_size = false
color_correction = "lab"
temporal_overlap = 0
prepend_frames = 0
input_noise_scale = 0
latent_noise_scale = 0
offload_device = "cpu"
enable_debug = false
```

### Notes

- **batch_size must follow 4n+1 formula** (1, 5, 9, 13, 17, 21...) — the temporal consistency architecture requires this.
- Use `batch_size=1` for single images; minimum `batch_size=5` for video temporal consistency.
- The pipeline has **4 phases**: encode → upscale → decode → postprocess, completing each phase for all batches before moving to the next.
- For best quality: match `batch_size` to shot length, use FP16 models, and `color_correction="lab"`.
- All three SeedVR2 nodes (id:477, 478, 479) are **disabled** (mode 4) in this workflow — this is an alternative/optional upscaling path.
- Resolution of 4096 with `max_resolution=4096` targets 4K output.
