# LTX Video Workflow — Custom Node Specifications

---

## 1. UnetLoaderGGUF
- **Source**: https://github.com/city96/ComfyUI-GGUF
- **Purpose**: Load GGUF-quantized diffusion/UNET models with on-the-fly dequantization. Reduces VRAM by using variable bitrate quantized weights.
- **Inputs**: *(none — widget-only)*
- **Widgets**:
  - `unet_name`, COMBO — Dropdown listing `.gguf` files from `ComfyUI/models/diffusion_models` and `ComfyUI/models/unet`
- **Outputs**:
  - `MODEL` (MODEL) — The loaded diffusion model with GGML quantized ops
- **Workflow Values**: `unet_name`: `ltx-2-3-22b-dev-Q4_K_M.gguf`
- **Notes**: Place GGUF model files in `models/unet` or `models/diffusion_models`. Supports all GGUF quant types (Q4_K_M, Q8_0, etc.). Advanced variant (`UnetLoaderGGUFAdvanced`) adds `dequant_dtype`, `patch_dtype`, `patch_on_device` params.

---

## 2. DualCLIPLoaderGGUF
- **Source**: https://github.com/city96/ComfyUI-GGUF
- **Purpose**: Load two CLIP/text encoder models (supports both GGUF and safetensors formats) for dual-encoder architectures like LTXv2.
- **Inputs**: *(none — widget-only)*
- **Widgets**:
  - `clip_name1`, COMBO — First text encoder file (from `models/clip` + `models/text_encoders`)
  - `clip_name2`, COMBO — Second text encoder file
  - `type`, COMBO — Clip type enum (e.g., `ltxv`, `sd3`, `flux`, `hunyuan_video`)
- **Outputs**:
  - `CLIP` (CLIP) — Combined dual-CLIP model
- **Workflow Values**: `clip_name1`: `google_gemma-3-12b-it-qat-Q6_K.gguf`, `clip_name2`: `ltx-2.3_text_projection_bf16.safetensors`, `type`: `ltxv`
- **Notes**: Handles mixed GGUF + safetensors inputs. The loader can handle both `.gguf` and regular `.safetensors`/`.bin` files transparently.

---

## 3. MelBandRoFormerModelLoader
- **Source**: https://github.com/KoreTeknique/ComfyUI-MelBandRoFormer
- **Purpose**: Load a MelBand RoFormer audio source separation model for splitting audio into vocals and instruments.
- **Inputs**: *(none — widget-only)*
- **Widgets**:
  - `model_name`, COMBO — Model file path (from models directory)
- **Outputs**:
  - `model` (MELROFORMERMODEL) — Loaded separation model
- **Workflow Values**: `model_name`: `MelBandRoFormer_comfy/MelBandRoformer_fp16.safetensors`

---

## 4. MelBandRoFormerSampler
- **Source**: https://github.com/KoreTeknique/ComfyUI-MelBandRoFormer
- **Purpose**: Run audio source separation — splits an audio track into isolated vocals and instrumental stems.
- **Inputs**:
  - `model` (MELROFORMERMODEL) — Loaded MelBandRoFormer model
  - `audio` (AUDIO) — Input audio to separate
- **Widgets**: *(none)*
- **Outputs**:
  - `vocals` (AUDIO) — Isolated vocal track
  - `instruments` (AUDIO) — Isolated instrumental track
- **Workflow Values**: Connect model from MelBandRoFormerModelLoader, audio from VHS_LoadVideo or other source

---

## 5. NormalizeAudioLoudness
- **Source**: https://github.com/kijai/ComfyUI-WanVideoWrapper (`nodes_utility.py`)
- **Purpose**: Normalize audio loudness to a target LUFS level using the pyloudnorm library. Ensures consistent audio volume across clips.
- **Inputs**:
  - `audio` (AUDIO) — Input audio to normalize
- **Widgets**:
  - `lufs`, FLOAT, default=-23.0, min=-100.0, max=0.0, step=0.1 — Target loudness in LUFS (higher = louder)
- **Outputs**:
  - `audio` (AUDIO) — Normalized audio
- **Workflow Values**: `lufs`: `-16`
- **Notes**: Requires `pyloudnorm` package. LUFS of -16 is typical for broadcast/web content; -23 is EBU R128 standard.

---

## 6. LTXSequencer
- **Source**: https://github.com/WhatDreamsCost/WhatDreamsCost-ComfyUI (`ltx_sequencer.py`)
- **Purpose**: Sequence multiple images into an LTX video at specific frame positions with per-image strength control. Extends the built-in `LTXVAddGuide` node. Supports frame or second-based insertion modes with auto-sync across node instances.
- **Inputs**:
  - `positive` (CONDITIONING) — Positive conditioning
  - `negative` (CONDITIONING) — Negative conditioning
  - `vae` (VAE) — Video VAE for encoding guide images
  - `latent` (LATENT) — Video latent to add guides to
  - `multi_input` (IMAGE) — Batched images from MultiImageLoader
- **Widgets**:
  - `num_images`, INT, default=1, min=0, max=50 — Number of guide images (auto-set from connected MultiImageLoader)
  - `insert_mode`, COMBO, options=["frames", "seconds"], default="frames" — Insertion point mode
  - `frame_rate`, INT, default=24, min=1, max=120 — Video FPS (used for second-to-frame conversion)
  - *Per-image (×50):*
    - `insert_frame_{i}`, INT, default=0, min=-9999, max=9999 — Frame insertion point
    - `insert_second_{i}`, FLOAT, default=0.0, min=0.0, max=9999.0 — Second insertion point
    - `strength_{i}`, FLOAT, default=1.0, min=0.0, max=1.0 — Guide strength
- **Outputs**:
  - `positive` (CONDITIONING) — Updated positive conditioning with guide keyframes
  - `negative` (CONDITIONING) — Updated negative conditioning
  - `latent` (LATENT) — Latent with encoded guide images and noise mask
- **Workflow Values**: 2 images, `insert_mode`: "frames", `insert_frame_1`: 0, `insert_frame_2`: -1, `strength_1`: 1.0, `strength_2`: 1.0
- **Notes**: All LTXSequencer nodes auto-sync their widget state. Negative frame_idx counts from end of video.

---

## 7. MultiImageLoader
- **Source**: https://github.com/WhatDreamsCost/WhatDreamsCost-ComfyUI (`multi_image_loader.py`)
- **Purpose**: Load, resize, and batch multiple images from file paths with a drag-and-drop gallery UI. Provides both a combined batch output and individual per-image outputs.
- **Inputs**: *(none — widget-only)*
- **Widgets**:
  - `image_paths`, STRING (multiline) — Newline-separated image filenames/paths
  - `width`, INT, default=0, min=0, max=8192 — Target width (0 = auto)
  - `height`, INT, default=0, min=0, max=8192 — Target height (0 = auto)
  - `interpolation`, COMBO, options=["lanczos", "nearest", "bilinear", "bicubic", "area", "nearest-exact"]
  - `resize_method`, COMBO, options=["keep proportion", "stretch", "pad", "crop"]
  - `multiple_of`, INT, default=0, min=0, max=512 — Ensure dimensions are multiples of this value
  - `img_compression`, INT, default=18, min=0, max=100 — JPEG compression amount (0 = none)
- **Outputs**:
  - `multi_output` (IMAGE) — All images batched into a single tensor
  - `image_1` through `image_50` (IMAGE) — Individual image outputs (padded with zeros if unused)
- **Workflow Values**: `image_paths`: `"arr1.png\narya_sheet_crop.png"`, `width`: 1920, `height`: 1088, `interpolation`: "lanczos", `resize_method`: "stretch", `multiple_of`: 16, `img_compression`: 18

---

## 8. VHS_LoadVideo
- **Source**: https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite (`load_video_nodes.py`)
- **Purpose**: Load a video file and extract frames as an image batch, with optional audio extraction and VAE-based latent output.
- **Inputs**:
  - `meta_batch` (VHS_BatchManager, optional) — For processing long videos in sub-batches
  - `vae` (VAE, optional) — If provided, outputs latents instead of images (saves RAM)
- **Widgets**:
  - `video`, COMBO — Video file from ComfyUI input directory
  - `force_rate`, FLOAT/INT, default=0, min=0, max=60 — Target frame rate (0 = disabled)
  - `force_size`, STRING (hidden) — Resize preset
  - `custom_width`, INT, default=0 — Custom width (0 = auto)
  - `custom_height`, INT, default=0 — Custom height (0 = auto)
  - `frame_load_cap`, INT, default=0 — Max frames to load (0 = all)
  - `skip_first_frames`, INT, default=0 — Frames to skip from start
  - `select_every_nth`, INT, default=1, min=1 — Frame decimation interval
  - `format`, COMBO — Load format preset (AnimateDiff, LTXV, Wan, etc.)
- **Outputs**:
  - `IMAGE` (IMAGE) or `LATENT` when VAE connected
  - `frame_count` (INT) — Number of frames returned
  - `audio` (AUDIO) — Extracted audio track
  - `video_info` (VHS_VIDEOINFO) — Video metadata
- **Workflow Values**: `force_rate`: 24, `frame_load_cap`: 97, `format`: "LTXV"
- **Notes**: LTXV format preset: target_rate=24, dim=(32,0,768,512), frames=(8,1). Path variant (`VHS_LoadVideoPath`) also available.

---

## 9. VHS_VideoCombine
- **Source**: https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite (`nodes.py`)
- **Purpose**: Combine an image sequence into an output video file with optional audio muxing. Supports GIF, WebP, and ffmpeg-based video formats.
- **Inputs**:
  - `images` (IMAGE) — Image batch to combine into video
  - `audio` (AUDIO, optional) — Audio to mux into the output
  - `meta_batch` (VHS_BatchManager, optional) — For batch processing
  - `vae` (VAE, optional) — For decoding latent inputs
- **Widgets**:
  - `frame_rate`, FLOAT/INT, default=8, min=1 — Output frame rate
  - `loop_count`, INT, default=0, min=0, max=100 — Additional loop repetitions
  - `filename_prefix`, STRING, default="AnimateDiff" — Output filename prefix (supports subfolders, date formatting)
  - `format`, COMBO — Output format (image/gif, image/webp, h264-mp4, h265-mp4, av1-webm, etc.)
  - `pingpong`, BOOLEAN, default=false — Reverse playback for clean loop
  - `save_output`, BOOLEAN, default=true — Save to output vs temp directory
  - *(Format-specific widgets like `crf`, `pix_fmt`, `save_metadata`)*
- **Outputs**:
  - `Filenames` (VHS_FILENAMES) — Output file paths
- **Workflow Values**: `frame_rate`: 24, `format`: "video/h264-mp4", `filename_prefix`: "ltx_output", `crf`: 19

---

## 10. VHS_VideoInfo
- **Source**: https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite (`nodes.py`)
- **Purpose**: Extract detailed video metadata from a Load Video node, splitting into source and loaded info.
- **Inputs**:
  - `video_info` (VHS_VIDEOINFO) — From VHS_LoadVideo output
- **Widgets**: *(none)*
- **Outputs**:
  - `source_fps🟨` (FLOAT) — Original file frame rate
  - `source_frame_count🟨` (INT) — Total frames in file
  - `source_duration🟨` (FLOAT) — Duration in seconds
  - `source_width🟨` (INT) — Original width
  - `source_height🟨` (INT) — Original height
  - `loaded_fps🟦` (FLOAT) — Frame rate after force_rate/select_every_nth
  - `loaded_frame_count🟦` (INT) — Number of frames returned
  - `loaded_duration🟦` (FLOAT) — Duration of loaded portion
  - `loaded_width🟦` (INT) — Width after scaling
  - `loaded_height🟦` (INT) — Height after scaling
- **Workflow Values**: Connect `video_info` from VHS_LoadVideo; `loaded_fps🟦` often piped to VHS_VideoCombine `frame_rate`

---

## 11. AudioCrop
- **Source**: audio-separation-nodes-comfyui
- **Purpose**: Crop/trim audio to a specified time range using start and end timestamps.
- **Inputs**:
  - `audio` (AUDIO) — Input audio
- **Widgets**:
  - `start_time`, STRING, default="0:00" — Start timestamp (MM:SS format)
  - `end_time`, STRING, default="1:00" — End timestamp (MM:SS format)
- **Outputs**:
  - `AUDIO` (AUDIO) — Cropped audio segment
- **Workflow Values**: `start_time`: "0:00", `end_time`: "1:00"

---

## 12. Float
- **Source**: comfyui-logic
- **Purpose**: Simple float constant node. Pass-through a single float value.
- **Inputs**: *(none — widget-only)*
- **Widgets**:
  - `value`, FLOAT — The float value
- **Outputs**:
  - `FLOAT` (FLOAT) — The value
- **Workflow Values**: `value`: `24` (commonly used to set frame rate)

---

## 13. LTXVAddGuide
- **Source**: ComfyUI Core (`comfy_extras/nodes_lt.py`)
- **Purpose**: Add an image or short video as a conditioning guide at a specific frame position in an LTX video latent. Encodes the guide image, appends it to the latent, and sets keyframe indices for the transformer.
- **Inputs**:
  - `positive` (CONDITIONING) — Positive conditioning
  - `negative` (CONDITIONING) — Negative conditioning
  - `vae` (VAE) — VAE for encoding guide image
  - `latent` (LATENT) — Video latent to condition
  - `image` (IMAGE) — Guide image/video (must be 8n+1 frames if video)
- **Widgets**:
  - `frame_idx`, INT, default=0, min=-9999, max=9999, step=1 — Frame position (negative = from end; multi-frame guides with 9+ frames must start at 8n boundary)
  - `strength`, FLOAT, default=1.0, min=0.0, max=1.0, step=0.01 — Conditioning strength
- **Outputs**:
  - `positive` (CONDITIONING) — Updated conditioning with keyframe indices
  - `negative` (CONDITIONING) — Updated conditioning
  - `latent` (LATENT) — Latent with appended guide frames and noise mask
- **Workflow Values**: `frame_idx`: 0 (first frame), `strength`: 0.5–1.0
- **Notes**: Can be chained — multiple LTXVAddGuide nodes add successive guide images. Use LTXVCropGuides to remove guides before re-sampling.

---

## 14. LTXVAddGuideMulti
- **Source**: ComfyUI Core (`comfy_extras/nodes_lt.py`) or custom extension
- **Purpose**: Like LTXVAddGuide but supports up to 5 images at different frame positions with individual strengths in a single node.
- **Inputs**:
  - `positive` (CONDITIONING), `negative` (CONDITIONING), `vae` (VAE), `latent` (LATENT)
  - `image_1` through `image_5` (IMAGE, optional) — Up to 5 guide images
- **Widgets**:
  - `frame_idx_1` through `frame_idx_5`, INT — Per-image frame positions
  - `strength_1` through `strength_5`, FLOAT — Per-image strengths
- **Outputs**:
  - `positive` (CONDITIONING), `negative` (CONDITIONING), `latent` (LATENT)
- **Workflow Values**: Typically `image_1` at frame 0, `image_2` at frame -1 for first-frame/last-frame workflows

---

## 15. LTXVCropGuides
- **Source**: ComfyUI Core (`comfy_extras/nodes_lt.py`)
- **Purpose**: Remove all appended guide conditioning from the latent. Strips keyframe indices and guide attention entries, cropping the latent back to its original length. Required before re-sampling or when switching guide configurations.
- **Inputs**:
  - `positive` (CONDITIONING)
  - `negative` (CONDITIONING)
  - `latent` (LATENT)
- **Widgets**: *(none)*
- **Outputs**:
  - `positive` (CONDITIONING) — Conditioning with keyframe_idxs and guide_attention_entries cleared
  - `negative` (CONDITIONING) — Cleared conditioning
  - `latent` (LATENT) — Latent cropped to remove appended guide frames
- **Workflow Values**: Place after KSampler to clean up before next sampling pass or video combine
- **Notes**: Sets `keyframe_idxs` and `guide_attention_entries` to `None` on both positive and negative conditioning.

---

## 16. LTXVImgToVideoInplaceKJ
- **Source**: ComfyUI-KJNodes (kijai)
- **Purpose**: Extended version of `LTXVImgToVideoInplace` supporting up to 5 images at specific frame indices with individual strengths. Modifies latent in-place rather than appending (replaces existing frames).
- **Inputs**:
  - `vae` (VAE)
  - `latent` (LATENT)
  - `image_1` through `image_5` (IMAGE, optional)
- **Widgets**:
  - `index_1` through `index_5`, INT — Frame indices for each image
  - `strength_1` through `strength_5`, FLOAT — Per-image strengths
- **Outputs**:
  - `latent` (LATENT) — Modified latent with frames replaced
- **Workflow Values**: `image_1` at index 0, `image_2` at last frame
- **Notes**: "Inplace" means the guide frames replace existing latent frames rather than appending new ones (different from LTXVAddGuide).

---

## 17. TorchCompileModel
- **Source**: ComfyUI-KJNodes (kijai) or similar
- **Purpose**: Apply `torch.compile()` to a diffusion model for inference speedup via kernel fusion and optimization.
- **Inputs**:
  - `model` (MODEL) — Model to compile
- **Widgets**:
  - `backend`, COMBO — Compilation backend (e.g., "inductor", "cudagraphs")
- **Outputs**:
  - `MODEL` (MODEL) — Compiled model
- **Workflow Values**: `backend`: "inductor"
- **Notes**: Requires PyTorch 2.0+. First inference is slower (compilation), subsequent runs are faster. Not all models benefit equally. May increase VRAM usage.

---

## 18. TextGenerateLTX2Prompt
- **Source**: ComfyUI Core or LTX extension
- **Purpose**: Use the LTX2 CLIP model (e.g., Gemma-3) to generate or enhance video prompts from an input image and text. Leverages the model's vision-language capabilities to create detailed scene descriptions.
- **Inputs**:
  - `clip` (CLIP) — The CLIP/text encoder model (with vision capability)
  - `image` (IMAGE) — Reference image for prompt generation
- **Widgets**:
  - `prompt`, STRING — Initial/seed prompt text
  - `max_length`, INT — Maximum token length for generated text
  - *(Additional sampling params: temperature, top_k, top_p, etc.)*
- **Outputs**:
  - `generated_text` (STRING) — AI-generated/enhanced prompt text
- **Workflow Values**: Feed image + short description, get detailed video-ready prompt

---

## 19. RTXVideoSuperResolution
- **Source**: ComfyUI-RTXVideoSuperResolution (NVIDIA RTX VSR)
- **Purpose**: Upscale video frames using NVIDIA RTX Video Super Resolution. Leverages Tensor Cores for AI-based upscaling.
- **Inputs**:
  - `images` (IMAGE) — Input frames to upscale
- **Widgets**:
  - `resize_type`, COMBO — Resize mode (e.g., "scale by multiplier")
  - `scale`, FLOAT, default=2.0 — Upscale factor
  - `quality`, COMBO, options=["ULTRA", "HIGH", "MEDIUM"] — Quality preset
- **Outputs**:
  - `upscaled_images` (IMAGE) — Upscaled frames
- **Workflow Values**: `resize_type`: "scale by multiplier", `scale`: 2, `quality`: "ULTRA"
- **Notes**: Requires NVIDIA RTX GPU. Typically used as final post-processing step.

---

## 20. KSampler
- **Source**: ComfyUI Core
- **Purpose**: Standard sampling node for denoising latents. Simpler interface than KSamplerAdvanced.
- **Inputs**:
  - `model` (MODEL), `positive` (CONDITIONING), `negative` (CONDITIONING), `latent_image` (LATENT)
- **Widgets**:
  - `seed`, INT — Random seed
  - `steps`, INT, default=20 — Number of sampling steps
  - `cfg`, FLOAT, default=8.0 — Classifier-free guidance scale
  - `sampler_name`, COMBO — Sampler algorithm (euler, dpmpp_2m, etc.)
  - `scheduler`, COMBO — Noise schedule (normal, karras, sgm_uniform, etc.)
  - `denoise`, FLOAT, default=1.0, min=0.0, max=1.0 — Denoising strength
- **Outputs**:
  - `LATENT` (LATENT) — Denoised latent
- **Workflow Values**: `steps`: 20-30, `cfg`: 3.0-5.0, `sampler_name`: "euler", `scheduler`: "normal", `denoise`: 1.0

---

## 21. ImageScale
- **Source**: ComfyUI Core
- **Purpose**: Scale an image batch to exact pixel dimensions.
- **Inputs**:
  - `image` (IMAGE) — Input image batch
- **Widgets**:
  - `upscale_method`, COMBO — Interpolation method (nearest-exact, bilinear, area, bicubic, lanczos)
  - `width`, INT — Target width in pixels
  - `height`, INT — Target height in pixels
  - `crop`, COMBO — Crop mode ("disabled", "center")
- **Outputs**:
  - `IMAGE` (IMAGE) — Rescaled image
- **Workflow Values**: `width`: 1920, `height`: 1088, `upscale_method`: "lanczos", `crop`: "disabled"

---

## 22. LatentComposite
- **Source**: ComfyUI Core
- **Purpose**: Composite one latent onto another at a specific spatial position. Used for inpainting, outpainting, or spatial composition.
- **Inputs**:
  - `samples_to` (LATENT) — Base latent
  - `samples_from` (LATENT) — Overlay latent
- **Widgets**:
  - `x`, INT — Horizontal offset in latent space
  - `y`, INT — Vertical offset in latent space
  - `feather`, INT — Edge feathering amount
- **Outputs**:
  - `LATENT` (LATENT) — Composited latent
- **Workflow Values**: Varies by use case

---

## 23. MaskComposite
- **Source**: ComfyUI Core
- **Purpose**: Combine two masks using boolean/blend operations.
- **Inputs**:
  - `destination` (MASK) — Base mask
  - `source` (MASK) — Overlay mask
- **Widgets**:
  - `x`, INT — Horizontal offset
  - `y`, INT — Vertical offset
  - `operation`, COMBO — Blend operation ("multiply", "add", "subtract", "and", "or", "xor")
- **Outputs**:
  - `MASK` (MASK) — Composited mask
- **Workflow Values**: `operation`: "add"

---

## 24. FeatherMask
- **Source**: ComfyUI Core
- **Purpose**: Apply a soft feather/gradient to mask edges for smooth blending transitions.
- **Inputs**:
  - `mask` (MASK) — Input mask
- **Widgets**:
  - `left`, INT, default=0 — Left edge feather in pixels
  - `top`, INT, default=0 — Top edge feather
  - `right`, INT, default=0 — Right edge feather
  - `bottom`, INT, default=0 — Bottom edge feather
- **Outputs**:
  - `MASK` (MASK) — Feathered mask

---

## 25. AudioConcat
- **Source**: ComfyUI Core or audio utility pack
- **Purpose**: Concatenate two audio clips sequentially.
- **Inputs**:
  - `audio_1` (AUDIO) — First audio clip
  - `audio_2` (AUDIO) — Second audio clip (appended after first)
- **Widgets**: *(none)*
- **Outputs**:
  - `AUDIO` (AUDIO) — Combined audio

---

## 26. TrimAudio / TrimAudioDuration
- **Source**: ComfyUI Core or audio utility pack
- **Purpose**: Trim audio to a specific duration or remove portions from start/end.
- **Inputs**:
  - `audio` (AUDIO) — Input audio
- **Widgets**:
  - `start_time` or `start`, FLOAT — Start time in seconds
  - `end_time` or `duration`, FLOAT — End time or duration in seconds
- **Outputs**:
  - `AUDIO` (AUDIO) — Trimmed audio

---

## 27. GetImage / GetImageRangeFromBatch / GetImageSizeAndCount
- **Source**: ComfyUI Core / Impact Pack / utility packs
- **Purpose**: Utility nodes for extracting specific images from a batch or querying batch metadata.

### GetImage
- **Inputs**: `images` (IMAGE)
- **Widgets**: `index`, INT — Which image to extract from the batch
- **Outputs**: `IMAGE` (IMAGE) — Single extracted image

### GetImageRangeFromBatch
- **Inputs**: `images` (IMAGE)
- **Widgets**: `start`, INT — Start index; `length`, INT — Number of images
- **Outputs**: `IMAGE` (IMAGE) — Sub-batch of images

### GetImageSizeAndCount
- **Inputs**: `image` (IMAGE)
- **Outputs**: `image` (IMAGE) — Pass-through; `width` (INT); `height` (INT); `count` (INT) — Batch size

---

## 28. ImageBatchMulti
- **Source**: ComfyUI utility pack (e.g., Impact Pack or similar)
- **Purpose**: Batch multiple individual images into a single image batch tensor.
- **Inputs**:
  - `image_1` (IMAGE), `image_2` (IMAGE), ... — Individual images to batch
- **Widgets**:
  - `inputcount`, INT — Number of image inputs
- **Outputs**:
  - `IMAGE` (IMAGE) — Combined batch
- **Notes**: Dynamic input count. All images must be the same dimensions.

---

## 29. easy showAnything
- **Source**: ComfyUI-Easy-Use
- **Purpose**: Debug/display node that shows any value passed to it (strings, numbers, tensors, etc.) in the node UI. Does not modify the data.
- **Inputs**:
  - `anything` (any type) — Any value to display
- **Widgets**: *(none — display only)*
- **Outputs**: *(optional pass-through)*
- **Workflow Values**: Connect to any output to inspect values during development
