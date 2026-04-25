# Workflow-Specific Provisioning Scripts

These scripts are intended to be hosted as individual raw files and used directly as `PROVISIONING_SCRIPT` values in Vast.

Each script is standalone so you can point Vast at a single raw URL.

## Qwen Image Edit

- `qwen-image-edit.sh`
  - for `workflows/image_qwen_image_edit.json`

## LTX

- `ltx/ltx23-gguf-t2v.sh`
  - for `workflows/LTX/LTX2.3 T2V GGUF 12GB.json`
- `ltx/ltx23-gguf-i2v.sh`
  - for `workflows/LTX/LTX2.3 I2V GGUF 12GB.json`
- `ltx/ltx23-gguf-v2v.sh`
  - for `workflows/LTX/LTX2.3 V2V GGUF 12GB.json`
- `ltx/ltx23-audio-t2v.sh`
  - for `workflows/LTX/LTX-2.3 Text Audio 2 Video GGUF 12GB.json`
- `ltx/ltx23-audio-i2v.sh`
  - for `workflows/LTX/LTX-2.3 Image Audio 2 Video GGUF 12GB.json`
- `ltx/ltx23-ti2v.sh`
  - for `workflows/LTX/LTX2 TI2V.json`
- `ltx/ltx23-ti2v-expert.sh`
  - for `workflows/LTX/LTX2 TI2V expert.json`
- `ltx/ltx23-ti2v-expert-q6k.sh`
  - for `workflows/LTX/LTX2 TI2V expert 2.json`
- `ltx/ltx2-s2v.sh`
  - for `workflows/LTX/ltx2_s2v.json`
- `ltx/ltxv2-frame-injection.sh`
  - for `workflows/LTX/LTXV2_Frame_Injection.json`
- `ltx/ltx23-multi-transformer.sh`
  - for `workflows/LTX/LTX-2.3_Multi_transformer.json`
- `ltx/ltx23-latent-workflows.sh`
  - for:
    - `workflows/LTX/video_ltx2_3_extend_video_hres.json`
    - `workflows/LTX/video_ltx2_3_FLframe_latent_guide.json`
    - `workflows/LTX/video_ltx2_3_FLframe_latent_injection.json`
    - `workflows/LTX/video_ltx2_3_FMLframe_latent_injection1.json`
- `ltx/ltx23-i2v-native.sh`
  - for `workflows/LTX/video_ltx2_3_i2v_comfyUI_native.json`
- `ltx/ltx23-i2v-gguf.sh`
  - for `workflows/LTX/video_ltx2_3_i2v_GGUF.json`
- `ltx/ltx23-i2v-kijai.sh`
  - for `workflows/LTX/video_ltx2_3_i2v_kijai.json`

## Notes

- Some workflow files reference assets that do not have a verified public direct download URL.
- In those cases, the script installs all resolved public assets and logs a warning for the remaining manual installs.
- Most LTX scripts are large; expect significant download time and disk use.
