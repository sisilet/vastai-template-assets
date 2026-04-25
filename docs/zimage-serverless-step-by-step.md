# ZIMAGE on Vast.ai Serverless: Step by Step

This is the practical flow if you want to run a ZIMAGE text-to-image workflow on Vast.ai serverless.

## Which base template to use

Use the **generic ComfyUI Serverless template**, not the Wan 2.2 template.

Reason:
- ZIMAGE is a text-to-image workflow
- the generic ComfyUI template is the lighter and more appropriate base
- Wan 2.2 is optimized for video workflows and carries extra model weight you do not need

## Two deployment paths

## Path A: Fully automatable stock ZIMAGE

This is the easiest path.

Use:
- workflow: `workflows/ZIMAGE/serverless-ready/zimage_stock.serverless.json`
- provisioning script: `wan22-custom-template/provisioning/zimage/zimage-stock.sh`

This installs only public Comfy-Org assets:
- `z_image_bf16.safetensors`
- `z_image_turbo_bf16.safetensors`
- `qwen_3_4b.safetensors`
- `ae.safetensors`

## Path B: Exact Moody / ZIB / ZIT look

Use:
- workflow: `workflows/ZIMAGE/serverless-ready/moody_zib_zit_v4.serverless.json`
- provisioning script: `wan22-custom-template/provisioning/zimage/moody-zib-zit.sh`

This requires you to provide two direct downloadable model URLs:
- `ZIMAGE_ZIB_MODEL_URL`
- `ZIMAGE_ZIT_MODEL_URL`

Reason:
- the exact Moody model files are referenced by filename in the workflow
- their trustworthy public direct file URLs were not reliably derivable automatically from Civitai pages

## Step-by-step in Vast

1. Open the **ComfyUI Serverless** template in Vast.
2. Create a private copy.
3. Set `PROVISIONING_SCRIPT` to the raw GitHub URL.
4. Save the template.
5. Launch an **interactive instance** first.
6. Wait for provisioning to finish.
7. Verify the model files are present in `ComfyUI/models/...`.
8. Test the workflow once manually.
9. If it works, create your serverless endpoint and workergroup using that template.
10. Send `/generate/sync` requests.

## Vast env examples

## Path A: Stock ZIMAGE

```env
PROVISIONING_SCRIPT=https://raw.githubusercontent.com/sisilet/vastai-template-assets/main/wan22-custom-template/provisioning/zimage/zimage-stock.sh
```

## Path B: Exact Moody / ZIB / ZIT

```env
PROVISIONING_SCRIPT=https://raw.githubusercontent.com/sisilet/vastai-template-assets/main/wan22-custom-template/provisioning/zimage/moody-zib-zit.sh
ZIMAGE_ZIB_MODEL_URL=https://your-direct-url/moodyWildMix_v20BASE45STEPS.safetensors
ZIMAGE_ZIT_MODEL_URL=https://your-direct-url/moodyPornMix_zitV10DPO.safetensors
```

## Raw GitHub URLs

Provisioning scripts:
- `https://raw.githubusercontent.com/sisilet/vastai-template-assets/main/wan22-custom-template/provisioning/zimage/zimage-stock.sh`
- `https://raw.githubusercontent.com/sisilet/vastai-template-assets/main/wan22-custom-template/provisioning/zimage/moody-zib-zit.sh`

Serverless-ready workflows:
- `https://raw.githubusercontent.com/sisilet/vastai-template-assets/main/workflows/ZIMAGE/serverless-ready/zimage_stock.serverless.json`
- `https://raw.githubusercontent.com/sisilet/vastai-template-assets/main/workflows/ZIMAGE/serverless-ready/moody_zib_zit_v4.serverless.json`

Runner:
- `https://raw.githubusercontent.com/sisilet/vastai-template-assets/main/workflows/ZIMAGE/serverless-ready/run_zimage_workflow.py`

## Running the workflow

Use the Python runner:

### Stock ZIMAGE

```bash
python3 workflows/ZIMAGE/serverless-ready/run_zimage_workflow.py \
  --endpoint YOUR_ENDPOINT_NAME \
  --workflow workflows/ZIMAGE/serverless-ready/zimage_stock.serverless.json \
  --prompt "A cinematic portrait of a young woman in soft morning light, ultra detailed skin, fashion editorial, shallow depth of field." \
  --output-prefix "image/zimage_stock_test"
```

### Exact Moody / ZIB / ZIT

```bash
python3 workflows/ZIMAGE/serverless-ready/run_zimage_workflow.py \
  --endpoint YOUR_ENDPOINT_NAME \
  --workflow workflows/ZIMAGE/serverless-ready/moody_zib_zit_v4.serverless.json \
  --prompt "A cinematic portrait of a young woman in soft morning light, ultra detailed skin, fashion editorial, shallow depth of field." \
  --output-prefix "image/moody_zib_zit_test"
```

## What is automated vs manual

Automated now:
- provisioning script hosting on GitHub
- public model downloads for stock ZIMAGE
- cleaned serverless-ready workflows
- Python runner for prompt and output prefix override

Still manual for the exact Moody look:
- you need to provide the two direct Moody model URLs

## Recommended first move

Start with **Path A: stock ZIMAGE**.

Why:
- it is fully automatable
- it validates your Vast serverless setup quickly
- once that works, switch to the exact Moody path if you still want the specific model look
