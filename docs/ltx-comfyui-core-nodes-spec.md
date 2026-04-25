# ComfyUI Core Nodes Spec — LTX Video Workflows

Source: [Comfy-Org/ComfyUI](https://github.com/Comfy-Org/ComfyUI)
Generated from source code analysis of 42 nodes used across 19 LTX Video workflow files.

---

## Table of Contents

1. [LTX-Specific Core Nodes](#ltx-specific-core-nodes)
2. [Advanced Sampling Nodes](#advanced-sampling-nodes)
3. [Loader Nodes](#loader-nodes)
4. [Video/Image Processing Nodes](#videoimage-processing-nodes)
5. [Mask/Utility Nodes](#maskutility-nodes)
6. [Primitive Nodes](#primitive-nodes)

---

## LTX-Specific Core Nodes

### 1. LTXVConditioning

- **Source**: `comfy_extras/nodes_lt.py`
- **Purpose**: Sets the frame rate on both positive and negative conditioning for LTXV video generation. Required to tell the model what FPS to target.
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | positive | CONDITIONING | Positive conditioning from CLIP encode |
  | negative | CONDITIONING | Negative conditioning from CLIP encode |
  | frame_rate | FLOAT | Target video frame rate |
- **Widgets**:
  | Parameter | Type | Default | Range | Step |
  |-----------|------|---------|-------|------|
  | frame_rate | FLOAT | 25.0 | 0.0–1000.0 | 0.01 |
- **Outputs**:
  | Name | Type |
  |------|------|
  | positive | CONDITIONING |
  | negative | CONDITIONING |
- **Workflow Values**: `frame_rate=24` (typical), `25` (default). Workflows commonly use 24 or 25 fps.

---

### 2. LTXVImgToVideoInplace

- **Source**: `comfy_extras/nodes_lt.py`
- **Purpose**: Encodes a reference image via VAE and injects it into the first frames of an existing latent tensor in-place (modifying the latent directly). Creates a noise mask so the model preserves the image content at the start. Supports bypass mode.
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | vae | VAE | LTXV VAE model |
  | image | IMAGE | Reference image to condition on |
  | latent | LATENT | Existing latent to modify in-place |
  | strength | FLOAT | How much to denoise the conditioned frames (1.0 = full denoise) |
  | bypass | BOOLEAN | Skip conditioning entirely |
- **Widgets**:
  | Parameter | Type | Default | Range | Step |
  |-----------|------|---------|-------|------|
  | strength | FLOAT | 1.0 | 0.0–1.0 | — |
  | bypass | BOOLEAN | False | — | — |
- **Outputs**:
  | Name | Type |
  |------|------|
  | latent | LATENT |
- **Workflow Values**: `strength=0.8`, `bypass=False`. Lower strength preserves more of the original image.

---

### 3. LTXVPreprocess

- **Source**: `comfy_extras/nodes_lt.py`
- **Purpose**: Applies H.264 video compression artifacts to an image to simulate the training data distribution of LTXV models. Encodes/decodes each frame through a virtual H.264 codec at the specified CRF quality. Set to 0 to disable.
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | image | IMAGE | Input image(s) to preprocess |
  | img_compression | INT | CRF value for H.264 compression |
- **Widgets**:
  | Parameter | Type | Default | Range | Step |
  |-----------|------|---------|-------|------|
  | img_compression | INT | 35 | 0–100 | 1 |
- **Outputs**:
  | Name | Type |
  |------|------|
  | output_image | IMAGE |
- **Workflow Values**: `img_compression=0` (disabled in many workflows), `35` (default). Use 0 for clean input, 25–40 to match LTXV training distribution.

---

### 4. LTXVLatentUpsampler

- **Source**: `comfy_extras/nodes_lt_upsampler.py`
- **Purpose**: Upsamples a video latent by a factor of 2× using a dedicated latent spatial upscaler model. Un-normalizes latents, runs through the upscale model, then re-normalizes. Removes any existing noise mask from output.
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | samples | LATENT | Input latent to upscale |
  | upscale_model | LATENT_UPSCALE_MODEL | Loaded latent upscaler weights |
  | vae | VAE | VAE for normalization statistics |
- **Widgets**: None (all connected inputs)
- **Outputs**:
  | Name | Type |
  |------|------|
  | LATENT | LATENT |
- **Workflow Values**: Used with `ltx-2.3-spatial-upscaler-x2-1.0.safetensors`. Always paired with `LatentUpscaleModelLoader`.

---

### 5. LTXVScheduler

- **Source**: `comfy_extras/nodes_lt.py`
- **Purpose**: Generates a sigma schedule specifically tuned for LTXV models. Computes shift based on latent token count (adapts to resolution/length), applies power-law sigma transformation, and optionally stretches sigmas to a terminal value.
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | steps | INT | Number of sampling steps |
  | max_shift | FLOAT | Maximum shift for large latents |
  | base_shift | FLOAT | Base shift for small latents |
  | stretch | BOOLEAN | Stretch sigmas to terminal range |
  | terminal | FLOAT | Terminal sigma value after stretch |
  | latent | LATENT | (optional) Latent for token count |
- **Widgets**:
  | Parameter | Type | Default | Range | Step | Advanced |
  |-----------|------|---------|-------|------|----------|
  | steps | INT | 20 | 1–10000 | 1 | No |
  | max_shift | FLOAT | 2.05 | 0.0–100.0 | 0.01 | No |
  | base_shift | FLOAT | 0.95 | 0.0–100.0 | 0.01 | No |
  | stretch | BOOLEAN | True | — | — | Yes |
  | terminal | FLOAT | 0.1 | 0.0–0.99 | 0.01 | Yes |
- **Outputs**:
  | Name | Type |
  |------|------|
  | SIGMAS | SIGMAS |
- **Workflow Values**: `steps=20`, `max_shift=2.05`, `base_shift=0.95`, `stretch=True`, `terminal=0.1`. These are the standard LTXV defaults.

---

### 6. EmptyLTXVLatentVideo

- **Source**: `comfy_extras/nodes_lt.py`
- **Purpose**: Creates an empty (zeroed) latent tensor sized for LTXV video generation. The latent has 128 channels, with temporal dimension `((length - 1) // 8) + 1`, and spatial dimensions `height // 32` × `width // 32`.
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | width | INT | Video width in pixels |
  | height | INT | Video height in pixels |
  | length | INT | Number of video frames |
  | batch_size | INT | Batch size |
- **Widgets**:
  | Parameter | Type | Default | Range | Step |
  |-----------|------|---------|-------|------|
  | width | INT | 768 | 64–MAX_RESOLUTION | 32 |
  | height | INT | 512 | 64–MAX_RESOLUTION | 32 |
  | length | INT | 97 | 1–MAX_RESOLUTION | 8 |
  | batch_size | INT | 1 | 1–4096 | 1 |
- **Outputs**:
  | Name | Type |
  |------|------|
  | LATENT | LATENT |
- **Workflow Values**: `width=768, height=512, length=121, batch_size=1`. Length of 97 = 12 sec @ 8fps latent (97 frames → 13 latent frames). Length 121 = ~5 sec @ 25fps.

---

### 7. LTXVConcatAVLatent

- **Source**: `comfy_extras/nodes_lt.py`
- **Purpose**: Concatenates separate video and audio latent tensors into a combined audio-video latent using `NestedTensor`. Required for joint audio-video generation with LTX 2.3+. Also merges noise masks if present.
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | video_latent | LATENT | Video latent tensor |
  | audio_latent | LATENT | Audio latent tensor |
- **Widgets**: None
- **Outputs**:
  | Name | Type |
  |------|------|
  | latent | LATENT |
- **Workflow Values**: Always paired with `LTXVSeparateAVLatent` after sampling. Used in all audio-enabled LTX 2.3 workflows.

---

### 8. LTXVSeparateAVLatent

- **Source**: `comfy_extras/nodes_lt.py`
- **Purpose**: Separates a combined audio-video latent (NestedTensor) back into individual video and audio latent tensors. Used after sampling to decode each modality with its own VAE.
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | av_latent | LATENT | Combined AV latent from sampling |
- **Widgets**: None
- **Outputs**:
  | Name | Type |
  |------|------|
  | video_latent | LATENT |
  | audio_latent | LATENT |
- **Workflow Values**: Post-sampling, feeds video_latent → VAEDecodeTiled and audio_latent → LTXVAudioVAEDecode.

---

### 9. LTXVAudioVAEDecode

- **Source**: `comfy_extras/nodes_lt_audio.py`
- **Purpose**: Decodes audio latent tensors back into waveform audio using the LTXV Audio VAE. Handles nested tensors by extracting the audio component (last element). Returns audio dict with waveform and sample rate.
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | samples | LATENT | Audio latent to decode |
  | audio_vae | VAE | LTXV Audio VAE model |
- **Widgets**: None
- **Outputs**:
  | Name | Type |
  |------|------|
  | Audio | AUDIO |
- **Workflow Values**: `audio_vae` loaded via `LTXVAudioVAELoader`. Output feeds into `CreateVideo` or `PreviewAudio`.

---

### 10. LTXVAudioVAEEncode

- **Source**: `comfy_extras/nodes_lt_audio.py`
- **Purpose**: Encodes audio waveform into latent space using the LTXV Audio VAE. Inherits from `VAEEncodeAudio`. Handles sample rate resampling to match VAE's expected rate (typically 44100 Hz).
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | audio | AUDIO | Audio waveform to encode |
  | audio_vae | VAE | LTXV Audio VAE model |
- **Widgets**: None
- **Outputs**:
  | Name | Type |
  |------|------|
  | Audio Latent | LATENT |
- **Workflow Values**: Used in audio-to-video workflows. Input audio feeds from `LoadAudio`.

---

### 11. LTXVAudioVAELoader

- **Source**: `comfy_extras/nodes_lt_audio.py`
- **Purpose**: Loads the LTXV Audio VAE checkpoint from disk. Remaps state dict keys (`audio_vae.` → `autoencoder.`, `vocoder.` → `vocoder.`) before constructing the VAE.
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | ckpt_name | COMBO | Checkpoint file from `checkpoints/` folder |
- **Widgets**:
  | Parameter | Type | Default | Options |
  |-----------|------|---------|--------|
  | ckpt_name | COMBO | — | Files in `checkpoints/` directory |
- **Outputs**:
  | Name | Type |
  |------|------|
  | Audio VAE | VAE |
- **Workflow Values**: `ckpt_name='LTX23_audio_vae_bf16.safetensors'`

---

### 12. LTXVEmptyLatentAudio

- **Source**: `comfy_extras/nodes_lt_audio.py`
- **Purpose**: Creates an empty (zeroed) audio latent tensor sized to match a given number of video frames at a given frame rate. Uses the Audio VAE to determine channel count, frequency bins, and latent frame mapping.
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | frames_number | INT | Number of video frames to match |
  | frame_rate | INT | Video frame rate |
  | batch_size | INT | Batch size |
  | audio_vae | VAE | Audio VAE for config |
- **Widgets**:
  | Parameter | Type | Default | Range | Step |
  |-----------|------|---------|-------|------|
  | frames_number | INT | 97 | 1–1000 | 1 |
  | frame_rate | INT | 25 | 1–1000 | 1 |
  | batch_size | INT | 1 | 1–4096 | 1 |
- **Outputs**:
  | Name | Type |
  |------|------|
  | Latent | LATENT |
- **Workflow Values**: `frames_number=97`, `frame_rate=25`, `batch_size=1`. The frames_number should match the `length` parameter of `EmptyLTXVLatentVideo`.

---

### 13. LatentUpscaleModelLoader

- **Source**: `comfy_extras/nodes_lt_upsampler.py` (registered separately)
- **Purpose**: Loads a latent spatial upscaler model (safetensors) for use with `LTXVLatentUpsampler`. Returns a `LATENT_UPSCALE_MODEL` type.
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | model_name | COMBO | Model file from upscale_models directory |
- **Widgets**:
  | Parameter | Type | Default | Options |
  |-----------|------|---------|--------|
  | model_name | COMBO | — | Files in `upscale_models/` |
- **Outputs**:
  | Name | Type |
  |------|------|
  | LATENT_UPSCALE_MODEL | LATENT_UPSCALE_MODEL |
- **Workflow Values**: `model_name='ltx-2.3-spatial-upscaler-x2-1.0.safetensors'`

---

## Advanced Sampling Nodes

### 14. SamplerCustomAdvanced

- **Source**: `comfy_extras/nodes_custom_sampler.py`
- **Purpose**: The primary advanced sampling node that takes modular noise, guider, sampler, and sigma inputs. Executes the full denoising loop, producing both the final sampled output and the predicted x0 denoised output. Used in all LTXV workflows instead of the simpler KSampler.
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | noise | NOISE | Noise generator (RandomNoise / DisableNoise) |
  | guider | GUIDER | CFG guider with model + conditioning |
  | sampler | SAMPLER | Sampling algorithm (euler, etc.) |
  | sigmas | SIGMAS | Noise schedule |
  | latent_image | LATENT | Input latent to denoise |
- **Widgets**: None (all connected inputs)
- **Outputs**:
  | Name | Type |
  |------|------|
  | output | LATENT |
  | denoised_output | LATENT |
- **Workflow Values**: Typically uses `output` connection. The `denoised_output` provides the predicted clean latent (x0).

---

### 15. CFGGuider

- **Source**: `comfy_extras/nodes_custom_sampler.py`
- **Purpose**: Creates a Classifier-Free Guidance guider that wraps a model with positive/negative conditioning and a CFG scale. The guider performs the CFG calculation during sampling: `output = uncond + cfg * (cond - uncond)`.
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | model | MODEL | Diffusion model |
  | positive | CONDITIONING | Positive conditioning |
  | negative | CONDITIONING | Negative conditioning |
  | cfg | FLOAT | CFG scale |
- **Widgets**:
  | Parameter | Type | Default | Range | Step |
  |-----------|------|---------|-------|------|
  | cfg | FLOAT | 8.0 | 0.0–100.0 | 0.1 |
- **Outputs**:
  | Name | Type |
  |------|------|
  | GUIDER | GUIDER |
- **Workflow Values**: `cfg=1` (LTXV typically uses very low CFG, often 1.0). The LTXV model is trained to work well with low/no CFG.

---

### 16. KSamplerSelect

- **Source**: `comfy_extras/nodes_custom_sampler.py`
- **Purpose**: Selects a sampling algorithm by name and wraps it as a SAMPLER object for use with `SamplerCustomAdvanced`.
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | sampler_name | COMBO | Sampling algorithm name |
- **Widgets**:
  | Parameter | Type | Default | Options |
  |-----------|------|---------|--------|
  | sampler_name | COMBO | — | euler, euler_ancestral, heun, dpm_2, dpm_2_ancestral, lms, dpm_fast, dpm_adaptive, dpmpp_2s_ancestral, dpmpp_sde, dpmpp_2m, dpmpp_2m_sde, dpmpp_3m_sde, ddpm, lcm, ipndm, ipndm_v, deis, uni_pc, uni_pc_bh2, er_sde, seeds_2 |
- **Outputs**:
  | Name | Type |
  |------|------|
  | SAMPLER | SAMPLER |
- **Workflow Values**: `sampler_name='euler'` (standard for LTXV workflows).

---

### 17. RandomNoise

- **Source**: `comfy_extras/nodes_custom_sampler.py`
- **Purpose**: Creates a random noise generator with a specified seed. Used with `SamplerCustomAdvanced` to provide reproducible noise for sampling.
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | noise_seed | INT | Random seed for noise generation |
- **Widgets**:
  | Parameter | Type | Default | Range | Control |
  |-----------|------|---------|-------|---------|
  | noise_seed | INT | 0 | 0–2^64 | control_after_generate (randomize) |
- **Outputs**:
  | Name | Type |
  |------|------|
  | NOISE | NOISE |
- **Workflow Values**: `noise_seed=780672041158618` with `control_after_generate='randomize'`.

---

### 18. ManualSigmas

- **Source**: `comfy_extras/nodes_custom_sampler.py`
- **Purpose**: Allows manually specifying a comma-separated list of sigma values as a custom noise schedule. Parses numeric values from the input string. Experimental node.
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | sigmas | STRING | Comma-separated sigma values |
- **Widgets**:
  | Parameter | Type | Default |
  |-----------|------|---------|
  | sigmas | STRING | "1, 0.5" |
- **Outputs**:
  | Name | Type |
  |------|------|
  | SIGMAS | SIGMAS |
- **Workflow Values**: `sigmas='1., 0.99375, 0.9875, 0.98125, 0.975, 0.909375, 0.725, 0.42188'` — hand-tuned schedules common in optimized LTXV workflows for fewer-step generation.

---

### 19. BasicScheduler

- **Source**: `comfy_extras/nodes_custom_sampler.py`
- **Purpose**: Generates a sigma schedule from a model's sampling configuration using standard scheduler algorithms. Supports partial denoising via the denoise parameter.
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | model | MODEL | Model for sampling config |
  | scheduler | COMBO | Scheduler algorithm name |
  | steps | INT | Number of steps |
  | denoise | FLOAT | Denoise strength (< 1.0 for img2img) |
- **Widgets**:
  | Parameter | Type | Default | Range | Step |
  |-----------|------|---------|-------|------|
  | scheduler | COMBO | — | normal, karras, exponential, sgm_uniform, simple, ddim_uniform, beta, linear_quadratic |
  | steps | INT | 20 | 1–10000 | 1 |
  | denoise | FLOAT | 1.0 | 0.0–1.0 | 0.01 |
- **Outputs**:
  | Name | Type |
  |------|------|
  | SIGMAS | SIGMAS |
- **Workflow Values**: `scheduler='linear_quadratic'`, `steps=16`, `denoise=1`. Used as alternative to `LTXVScheduler`.

---

## Loader Nodes

### 20. DualCLIPLoader

- **Source**: `nodes.py`
- **Purpose**: Loads two CLIP/text encoder models and combines them into a single CLIP object. For LTXV, loads the Gemma language model and the LTXV text projection model.
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | clip_name1 | COMBO | First text encoder file |
  | clip_name2 | COMBO | Second text encoder file |
  | type | COMBO | Model architecture type |
  | device | COMBO | Device placement (advanced) |
- **Widgets**:
  | Parameter | Type | Default | Options |
  |-----------|------|---------|--------|
  | clip_name1 | COMBO | — | Files in `text_encoders/` |
  | clip_name2 | COMBO | — | Files in `text_encoders/` |
  | type | COMBO | — | sdxl, sd3, flux, hunyuan_video, hidream, hunyuan_image, hunyuan_video_15, kandinsky5, kandinsky5_image, **ltxv**, newbie, ace |
  | device | COMBO | "default" | default, cpu |
- **Outputs**:
  | Name | Type |
  |------|------|
  | CLIP | CLIP |
- **Workflow Values**: `clip_name1='gemma_3_12B_it_fp4_mixed.safetensors'`, `clip_name2='ltx-2.3_text_projection_bf16.safetensors'`, `type='ltxv'`, `device='default'`.

---

### 21. CheckpointLoaderSimple

- **Source**: `nodes.py`
- **Purpose**: Loads a full diffusion model checkpoint containing MODEL, CLIP, and VAE components. Auto-detects the model configuration.
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | ckpt_name | COMBO | Checkpoint file |
- **Widgets**:
  | Parameter | Type | Options |
  |-----------|------|--------|
  | ckpt_name | COMBO | Files in `checkpoints/` |
- **Outputs**:
  | Name | Type |
  |------|------|
  | MODEL | MODEL |
  | CLIP | CLIP |
  | VAE | VAE |
- **Workflow Values**: `ckpt_name='ltx-2-19b-dev-fp8.safetensors'`. Only used in simpler workflows; most use `UNETLoader` + `DualCLIPLoader` + `VAELoader` separately.

---

### 22. LoadImage

- **Source**: `nodes.py`
- **Purpose**: Loads an image from the input directory. Handles EXIF orientation, multi-frame images (GIF/MPO), and alpha channel extraction. Returns image as float32 tensor and mask.
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | image | COMBO | Image file from input directory |
- **Widgets**:
  | Parameter | Type | Options |
  |-----------|------|--------|
  | image | COMBO (upload) | Image files in `input/` directory |
- **Outputs**:
  | Name | Type |
  |------|------|
  | IMAGE | IMAGE |
  | MASK | MASK |
- **Workflow Values**: Used in I2V (image-to-video) workflows. Feeds into `LTXVPreprocess` → `LTXVImgToVideoInplace` or `LTXVAddGuide`.

---

### 23. LoadAudio

- **Source**: `comfy_extras/nodes_audio.py`
- **Purpose**: Loads an audio file from the input directory using PyAV. Supports any format PyAV can decode (wav, mp3, flac, ogg, etc.). Returns audio as float32 PCM waveform dict.
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | audio | COMBO (upload) | Audio/video file from input directory |
- **Widgets**:
  | Parameter | Type | Options |
  |-----------|------|--------|
  | audio | COMBO | Audio/video files in `input/` |
- **Outputs**:
  | Name | Type |
  |------|------|
  | AUDIO | AUDIO |
- **Workflow Values**: Used in audio-to-video workflows. Feeds into `LTXVAudioVAEEncode`.

---

### 24. LoraLoaderModelOnly

- **Source**: `nodes.py`
- **Purpose**: Applies a LoRA to a MODEL only (no CLIP modification). Loads the LoRA weights and merges them at the specified strength.
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | model | MODEL | Base diffusion model |
  | lora_name | COMBO | LoRA file name |
  | strength_model | FLOAT | LoRA application strength |
- **Widgets**:
  | Parameter | Type | Default | Range | Step |
  |-----------|------|---------|-------|------|
  | lora_name | COMBO | — | Files in `loras/` |
  | strength_model | FLOAT | 1.0 | -100.0–100.0 | 0.01 |
- **Outputs**:
  | Name | Type |
  |------|------|
  | MODEL | MODEL |
- **Workflow Values**: `lora_name='LTX-2\LTX-2-Image2Vid-Adapter.safetensors'`, `strength_model=1`. The I2V adapter LoRA is essential for image-to-video workflows.

---

## Video/Image Processing Nodes

### 25. CreateVideo

- **Source**: `comfy_extras/nodes_video.py`
- **Purpose**: Creates a VIDEO object from image frames and optional audio at a specified frame rate. The output is a composable video container (not saved to disk).
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | images | IMAGE | Video frames as image batch |
  | fps | FLOAT | Frames per second |
  | audio | AUDIO | (optional) Audio track |
- **Widgets**:
  | Parameter | Type | Default | Range | Step |
  |-----------|------|---------|-------|------|
  | fps | FLOAT | 30.0 | 1.0–120.0 | 1.0 |
- **Outputs**:
  | Name | Type |
  |------|------|
  | VIDEO | VIDEO |
- **Workflow Values**: `fps=30`. Combines decoded images + decoded audio into a playable video.

---

### 26. SaveVideo

- **Source**: `comfy_extras/nodes_video.py`
- **Purpose**: Saves a VIDEO object to disk in the output directory. Supports multiple container formats and codecs. Embeds workflow metadata.
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | video | VIDEO | Video to save |
  | filename_prefix | STRING | Output filename prefix |
  | format | COMBO | Container format |
  | codec | COMBO | Video codec |
- **Widgets**:
  | Parameter | Type | Default | Options |
  |-----------|------|---------|--------|
  | filename_prefix | STRING | "video/ComfyUI" | — |
  | format | COMBO | "auto" | auto, mp4, webm, mkv, etc. |
  | codec | COMBO | "auto" | auto, h264, h265, vp9, av1, etc. |
- **Outputs**: None (output node)
- **Workflow Values**: `filename_prefix='video/LTX-2'`, `format='mp4'`, `codec='auto'`.

---

### 27. VAEDecodeTiled

- **Source**: `nodes.py`
- **Purpose**: Decodes latent tensors to images using tiled processing to reduce VRAM usage. Essential for video latents that are too large to decode at once. Supports temporal tiling for video VAEs.
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | samples | LATENT | Latent to decode |
  | vae | VAE | VAE model |
  | tile_size | INT | Spatial tile size |
  | overlap | INT | Spatial overlap between tiles |
  | temporal_size | INT | Temporal tile size (video VAEs) |
  | temporal_overlap | INT | Temporal overlap (video VAEs) |
- **Widgets**:
  | Parameter | Type | Default | Range | Step | Advanced |
  |-----------|------|---------|-------|------|----------|
  | tile_size | INT | 512 | 64–4096 | 32 | Yes |
  | overlap | INT | 64 | 0–4096 | 32 | Yes |
  | temporal_size | INT | 64 | 8–4096 | 4 | Yes |
  | temporal_overlap | INT | 8 | 4–4096 | 4 | Yes |
- **Outputs**:
  | Name | Type |
  |------|------|
  | IMAGE | IMAGE |
- **Workflow Values**: `tile_size=512`, `overlap=64`, `temporal_size=2048`, `temporal_overlap=8`. The large temporal_size (2048) means most videos decode in one temporal pass.

---

### 28. VAEEncodeTiled

- **Source**: `nodes.py`
- **Purpose**: Encodes images to latent space using tiled processing. Mirror of VAEDecodeTiled for the encode direction.
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | pixels | IMAGE | Images to encode |
  | vae | VAE | VAE model |
  | tile_size | INT | Spatial tile size |
  | overlap | INT | Spatial overlap |
  | temporal_size | INT | Temporal tile size |
  | temporal_overlap | INT | Temporal overlap |
- **Widgets**:
  | Parameter | Type | Default | Range | Step | Advanced |
  |-----------|------|---------|-------|------|----------|
  | tile_size | INT | 512 | 64–4096 | 64 | Yes |
  | overlap | INT | 64 | 0–4096 | 32 | Yes |
  | temporal_size | INT | 64 | 8–4096 | 4 | Yes |
  | temporal_overlap | INT | 8 | 4–4096 | 4 | Yes |
- **Outputs**:
  | Name | Type |
  |------|------|
  | LATENT | LATENT |
- **Workflow Values**: `tile_size=512`, `overlap=64`, `temporal_size=4096`, `temporal_overlap=8`. Used for video-to-video encoding.

---

### 29. ImageScaleBy

- **Source**: `nodes.py`
- **Purpose**: Scales an image by a multiplier factor using various interpolation methods.
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | image | IMAGE | Input image |
  | upscale_method | COMBO | Interpolation method |
  | scale_by | FLOAT | Scale multiplier |
- **Widgets**:
  | Parameter | Type | Default | Range/Options | Step |
  |-----------|------|---------|---------------|------|
  | upscale_method | COMBO | — | nearest-exact, bilinear, area, bicubic, lanczos |
  | scale_by | FLOAT | 1.0 | 0.01–8.0 | 0.01 |
- **Outputs**:
  | Name | Type |
  |------|------|
  | IMAGE | IMAGE |
- **Workflow Values**: `upscale_method='lanczos'`, `scale_by=0.5`. Commonly used to downscale images before encoding.

---

### 30. EmptyImage

- **Source**: `nodes.py`
- **Purpose**: Creates a solid-color image tensor. Color is specified as a 24-bit hex integer (RGB).
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | width | INT | Image width |
  | height | INT | Image height |
  | batch_size | INT | Number of images |
  | color | INT | RGB color (hex) |
- **Widgets**:
  | Parameter | Type | Default | Range | Step |
  |-----------|------|---------|-------|------|
  | width | INT | 512 | 1–MAX_RESOLUTION | 1 |
  | height | INT | 512 | 1–MAX_RESOLUTION | 1 |
  | batch_size | INT | 1 | 1–4096 | 1 |
  | color | INT | 0 (black) | 0–0xFFFFFF | 1 |
- **Outputs**:
  | Name | Type |
  |------|------|
  | IMAGE | IMAGE |
- **Workflow Values**: `width=960, height=704, batch_size=1, color=0` (black). Used as placeholder or background.

---

### 31. ResizeImagesByLongerEdge

- **Source**: `comfy_extras/nodes_replacements.py` → replacement alias for `ImageScaleToMaxDimension` in `comfy_extras/nodes_images.py`
- **Purpose**: Resizes images so the longest edge matches the specified size, maintaining aspect ratio. Uses lanczos interpolation. Now replaced by `ImageScaleToMaxDimension`.
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | images | IMAGE | Input images |
  | longer_edge | INT | Target size for longest dimension |
- **Widgets**:
  | Parameter | Type | Default | Range | Step |
  |-----------|------|---------|-------|------|
  | longer_edge | INT | 512 | 0–MAX_RESOLUTION | 1 |
- **Outputs**:
  | Name | Type |
  |------|------|
  | images | IMAGE |
- **Workflow Values**: `longer_edge=1536`. Used to resize input images to a consistent size before video generation.

---

### 32. ResizeImageMaskNode

- **Source**: `comfy_extras/nodes_replacements.py` → replacement node for `ImageScaleBy`
- **Purpose**: A unified resize node that supports multiple resize modes: scale by multiplier, scale to specific dimensions, or fit to dimensions. Handles both IMAGE and MASK types via `COMFY_MATCHTYPE_V3`. Replaces the older `ImageScaleBy` node.
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | input | COMFY_MATCHTYPE_V3 | Image or mask to resize |
  | resize_type | COMFY_DYNAMICCOMBO_V3 | Resize mode |
  | scale_method | COMBO | Interpolation method |
- **Widgets**:
  | Parameter | Type | Default | Options |
  |-----------|------|---------|--------|
  | resize_type | DYNAMIC COMBO | "scale dimensions" | scale dimensions, scale by multiplier, fit to dimensions |
  | width | INT | 1920 | — |
  | height | INT | 1088 | — |
  | alignment | COMBO | "center" | center, top-left, etc. |
  | scale_method | COMBO | "lanczos" | nearest-exact, bilinear, area, bicubic, lanczos |
- **Outputs**:
  | Name | Type |
  |------|------|
  | resized | COMFY_MATCHTYPE_V3 |
- **Workflow Values**: `resize_type='scale dimensions'`, `width=1920`, `height=1088`, `alignment='center'`, `scale_method='lanczos'`.

---

## Mask/Utility Nodes

### 33. SetLatentNoiseMask

- **Source**: `nodes.py`
- **Purpose**: Attaches a noise mask to a latent tensor. The mask controls which regions of the latent receive noise during sampling (1 = noise, 0 = preserve). Used for inpainting and partial denoising.
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | samples | LATENT | Input latent |
  | mask | MASK | Noise mask |
- **Widgets**: None
- **Outputs**:
  | Name | Type |
  |------|------|
  | LATENT | LATENT |
- **Workflow Values**: Used with `SolidMask` to create uniform noise masks for video extend/inpaint workflows.

---

### 34. SolidMask

- **Source**: `comfy_extras/nodes_mask.py`
- **Purpose**: Creates a uniform solid mask filled with a single value. Value of 1.0 = fully white (full noise/inpaint), 0.0 = fully black (preserve).
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | value | FLOAT | Mask fill value |
  | width | INT | Mask width |
  | height | INT | Mask height |
- **Widgets**:
  | Parameter | Type | Default | Range | Step |
  |-----------|------|---------|-------|------|
  | value | FLOAT | 1.0 | 0.0–1.0 | 0.01 |
  | width | INT | 512 | 1–MAX_RESOLUTION | 1 |
  | height | INT | 512 | 1–MAX_RESOLUTION | 1 |
- **Outputs**:
  | Name | Type |
  |------|------|
  | MASK | MASK |
- **Workflow Values**: `value=0, width=512, height=512`. Value of 0 used to create "preserve everything" masks.

---

### 35. ModelSamplingSD3

- **Source**: `comfy_extras/nodes_model_advanced.py`
- **Purpose**: Patches a model's sampling configuration to use discrete flow matching (SD3-style) with a configurable shift parameter. Creates `ModelSamplingDiscreteFlow` + `CONST` noise type. The shift controls the noise schedule distribution.
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | model | MODEL | Input model to patch |
  | shift | FLOAT | Flow matching shift value |
- **Widgets**:
  | Parameter | Type | Default | Range | Step |
  |-----------|------|---------|-------|------|
  | shift | FLOAT | 3.0 | 0.0–100.0 | 0.01 |
- **Outputs**:
  | Name | Type |
  |------|------|
  | MODEL | MODEL |
- **Workflow Values**: `shift=13`. Higher shift values push noise schedule toward more denoising at early steps. Used as alternative to `ModelSamplingLTXV` in some workflows.

---

### 36. ComfyMathExpression

- **Source**: `comfy_extras/nodes_math.py`
- **Purpose**: Evaluates a mathematical expression string against named numeric inputs using safe evaluation (simpleeval). Supports standard math functions (sqrt, sin, cos, log, etc.) and auto-growing input variables (a, b, c...).
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | expression | STRING | Math expression to evaluate |
  | values.a | FLOAT/INT | First input value (auto-grow) |
  | values.b | FLOAT/INT | Second input value (auto-grow) |
  | ... | FLOAT/INT | Additional auto-grow inputs |
- **Widgets**:
  | Parameter | Type | Default |
  |-----------|------|---------|
  | expression | STRING | "a + b" |
- **Outputs**:
  | Name | Type |
  |------|------|
  | FLOAT | FLOAT |
  | INT | INT |
- **Workflow Values**: `expression='a * 2'`. Used for dynamic dimension calculations (e.g., computing frame counts, scaling dimensions).

---

## Primitive Nodes

### 37. PrimitiveInt

- **Source**: `comfy_extras/nodes_primitive.py`
- **Purpose**: Provides a single integer value as a connectable output. Basic building block for parameterizing workflows.
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | value | INT | Integer value |
- **Widgets**:
  | Parameter | Type | Default | Range | Control |
  |-----------|------|---------|-------|---------|
  | value | INT | 0 | -sys.maxsize–sys.maxsize | control_after_generate |
- **Outputs**:
  | Name | Type |
  |------|------|
  | INT | INT |
- **Workflow Values**: Used extensively (55 instances) for frame counts, dimensions, steps, etc.

---

### 38. PrimitiveFloat

- **Source**: `comfy_extras/nodes_primitive.py`
- **Purpose**: Provides a single float value as a connectable output.
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | value | FLOAT | Float value |
- **Widgets**:
  | Parameter | Type | Default | Range | Step |
  |-----------|------|---------|-------|------|
  | value | FLOAT | 0.0 | -sys.maxsize–sys.maxsize | 0.1 |
- **Outputs**:
  | Name | Type |
  |------|------|
  | FLOAT | FLOAT |
- **Workflow Values**: Used for CFG scale, strength, and other floating-point parameters.

---

### 39. PrimitiveBoolean

- **Source**: `comfy_extras/nodes_primitive.py`
- **Purpose**: Provides a single boolean value as a connectable output. Used as workflow switches.
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | value | BOOLEAN | Boolean value |
- **Widgets**:
  | Parameter | Type | Default |
  |-----------|------|---------|
  | value | BOOLEAN | False |
- **Outputs**:
  | Name | Type |
  |------|------|
  | BOOLEAN | BOOLEAN |
- **Workflow Values**: Used for bypass flags, enable/disable toggles (30 instances across workflows).

---

### 40. PrimitiveStringMultiline

- **Source**: `comfy_extras/nodes_primitive.py`
- **Purpose**: Provides a multi-line string value as a connectable output. Used for prompts and text parameters.
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | value | STRING | Multi-line text value |
- **Widgets**:
  | Parameter | Type | Default |
  |-----------|------|---------|
  | value | STRING (multiline) | "" |
- **Outputs**:
  | Name | Type |
  |------|------|
  | STRING | STRING |
- **Workflow Values**: Used for positive/negative prompts, sigma strings, and other text parameters.

---

### 41. PreviewAny

- **Source**: `comfy_extras/nodes_preview_any.py`
- **Purpose**: Previews any data type as text in the UI. Serializes the input to JSON or string representation. Useful for debugging workflow values.
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | source | * (ANY) | Any data to preview |
- **Widgets**: None
- **Outputs**:
  | Name | Type |
  |------|------|
  | STRING | STRING |
- **Workflow Values**: Output node. Shows computed values (dimensions, frame counts, etc.) in the workflow UI.

---

### 42. PreviewAudio

- **Source**: `comfy_extras/nodes_audio.py`
- **Purpose**: Previews audio in the UI by encoding it as a temporary FLAC file and sending it to the frontend for playback.
- **Inputs**:
  | Name | Type | Description |
  |------|------|-------------|
  | audio | AUDIO | Audio to preview |
- **Widgets**: None
- **Outputs**: None (output node)
- **Workflow Values**: Used to preview generated audio before final save.

---

## Common LTXV Workflow Patterns

### Text-to-Video (T2V)
```
DualCLIPLoader → CLIPTextEncode (×2) → LTXVConditioning → CFGGuider
UNETLoader → LoraLoaderModelOnly → CFGGuider
EmptyLTXVLatentVideo ──┐
LTXVEmptyLatentAudio ──┤→ LTXVConcatAVLatent → SamplerCustomAdvanced
KSamplerSelect → SamplerCustomAdvanced
LTXVScheduler → SamplerCustomAdvanced
RandomNoise → SamplerCustomAdvanced
SamplerCustomAdvanced → LTXVSeparateAVLatent → VAEDecodeTiled + LTXVAudioVAEDecode → CreateVideo → SaveVideo
```

### Image-to-Video (I2V)
```
LoadImage → LTXVPreprocess → LTXVImgToVideoInplace (with EmptyLTXVLatentVideo)
... same sampling chain as T2V ...
```

### Latent Upscale Pipeline
```
(First pass at low res) → LTXVSeparateAVLatent → video_latent
LatentUpscaleModelLoader → LTXVLatentUpsampler (with video_latent + VAE)
→ LTXVConcatAVLatent → (Second pass sampling) → final decode
```
