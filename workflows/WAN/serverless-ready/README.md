# Serverless-Ready WAN Workflows

These are cleaned variants of the official WAN workflows intended for Vast `/generate/sync` usage.

Changes from the official source files:

- replaced demo positive prompts with neutral placeholder text
- replaced demo `LoadImage` filenames with URL placeholders for I2V/TI2V
- standardized `SaveVideo` output prefixes

Files:

- `video_wan2_2_14B_t2v.serverless.json`
- `video_wan2_2_14B_i2v.serverless.json`
- `video_wan2_2_5B_ti2v.serverless.json`
- `run_wan_workflow.py`
- `request_wan22_14b_t2v.example.json`
- `request_wan22_14b_i2v.example.json`
- `request_wan22_5b_ti2v.example.json`
- `WAN_LINK_CHECKS.md`

Before using:

- replace the positive prompt text with your actual prompt
- for I2V/TI2V, replace the placeholder image URL with a real public image URL

## Final Vast Template Env Blocks

Use these with the Vast Wan 2.2 base template.

### WAN 2.2 14B T2V

```env
PROVISIONING_SCRIPT=https://raw.githubusercontent.com/sisilet/vastai-template-assets/main/wan22-custom-template/provisioning_script.sh
WORKFLOW_NAME=wan22-14b-t2v
```

### WAN 2.2 14B I2V

```env
PROVISIONING_SCRIPT=https://raw.githubusercontent.com/sisilet/vastai-template-assets/main/wan22-custom-template/provisioning_script.sh
WORKFLOW_NAME=wan22-14b-i2v
```

### WAN 2.2 5B TI2V

```env
PROVISIONING_SCRIPT=https://raw.githubusercontent.com/sisilet/vastai-template-assets/main/wan22-custom-template/provisioning_script.sh
WORKFLOW_NAME=wan22-5b-ti2v
```

You can also use the dedicated provisioning scripts from `wan22-custom-template/provisioning/wan/` directly if you prefer not to use `WORKFLOW_NAME`.

## Example Runner Usage

### WAN 2.2 14B T2V

```bash
python3 workflows/WAN/serverless-ready/run_wan_workflow.py \
  --endpoint YOUR_ENDPOINT_NAME \
  --workflow workflows/WAN/serverless-ready/video_wan2_2_14B_t2v.serverless.json \
  --prompt "A cinematic aerial shot of a neon-lit city at night, slow camera drift, rain reflections, highly detailed." \
  --output-prefix "video/wan22_14b_t2v_test"
```

### WAN 2.2 14B I2V

```bash
python3 workflows/WAN/serverless-ready/run_wan_workflow.py \
  --endpoint YOUR_ENDPOINT_NAME \
  --workflow workflows/WAN/serverless-ready/video_wan2_2_14B_i2v.serverless.json \
  --prompt "Animate the image into a slow cinematic push-in with subtle hair and cloth motion." \
  --image-url "https://example.com/your-image.jpg" \
  --output-prefix "video/wan22_14b_i2v_test"
```

### WAN 2.2 5B TI2V

```bash
python3 workflows/WAN/serverless-ready/run_wan_workflow.py \
  --endpoint YOUR_ENDPOINT_NAME \
  --workflow workflows/WAN/serverless-ready/video_wan2_2_5B_ti2v.serverless.json \
  --prompt "Create a moody retro subway scene with gentle camera motion and cinematic lighting." \
  --image-url "https://example.com/your-image.png" \
  --output-prefix "video/wan22_5b_ti2v_test"
```

### Optional S3 Uploads

Add these flags to any invocation:

```bash
--s3-access-key-id ... \
--s3-secret-access-key ... \
--s3-endpoint-url ... \
--s3-bucket-name ... \
--s3-region ...
```

The runner will inject those values into the `/generate/sync` payload.
