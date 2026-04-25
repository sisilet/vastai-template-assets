# ZIMAGE Serverless-Ready Workflows

Two paths are provided:

## 1. Fully automatable stock path

- `zimage_stock.serverless.json`
- use with provisioning script:
  - `wan22-custom-template/provisioning/zimage/zimage-stock.sh`

This uses the public Comfy-Org model files:

- `z_image_bf16.safetensors`
- `z_image_turbo_bf16.safetensors`
- `qwen_3_4b.safetensors`
- `ae.safetensors`

## 2. Exact Moody / ZIB / ZIT path

- `moody_zib_zit_v4.serverless.json`
- use with provisioning script:
  - `wan22-custom-template/provisioning/zimage/moody-zib-zit.sh`

This preserves the original Moody model filenames, but you must provide:

- `ZIMAGE_ZIB_MODEL_URL`
- `ZIMAGE_ZIT_MODEL_URL`

as direct downloadable file URLs.

## Prompt handling

Both cleaned workflows have a placeholder positive prompt that you should replace in your client script.
