# Custom Vast.ai Template for Serverless ComfyUI Wan 2.2

## Goal

Use Vast.ai serverless with:

- ComfyUI Wan 2.2
- a custom model and optional custom nodes
- optional S3 uploads on a per-request basis

## Recommendation

Start from the stock **ComfyUI Wan 2.2 serverless template** and create a private copy.

Use a custom template because your workflow references assets that must already exist on the worker before a request runs.

## What to keep from the stock template

- the stock Wan 2.2 image
- the stock PyWorker / API wrapper behavior
- the stock `/generate/sync` endpoint
- the built-in Wan 2.2 model setup unless you explicitly want to replace it

## What to customize

- add a `PROVISIONING_SCRIPT` environment variable
- set `WORKFLOW_NAME` when you want only one workflow's assets downloaded
- set `WORKFLOW_MODEL_PACK` to choose a built-in model family
- install your custom model files into the correct ComfyUI model directories
- optionally install custom node repositories
- optionally leave all `S3_*` variables unset so uploads are only enabled per request

## Files in this folder

- `provisioning_script.sh`: starter script for downloading custom models into ComfyUI model directories and cloning custom nodes
- `template-env.example`: example template environment variables

## Build steps in Vast UI

1. Open the existing Wan 2.2 serverless template in Vast.
2. Create your own copy instead of editing the shared template directly.
3. Rename it to something like `Wan2.2 Serverless Custom`.
4. Keep it **private** while iterating.
5. In the template environment variables, add:
   - `PROVISIONING_SCRIPT` with a **public raw URL** to your hosted `provisioning_script.sh`
   - `WORKFLOW_NAME` if you want exact workflow-only installs
   - `WORKFLOW_MODEL_PACK` set to `moody-zib-zit`, `ltx`, or `none`
   - your custom model variables from `template-env.example`
6. Do **not** add `S3_*` variables if you want S3 to stay optional.
7. Save the template.

## Selectable workflows and packs

If you want the smallest relevant download set, use `WORKFLOW_NAME`.

Examples:

- `WORKFLOW_NAME=qwen-image-edit`
- `WORKFLOW_NAME=wan22-14b-t2v`
- `WORKFLOW_NAME=wan22-14b-i2v`
- `WORKFLOW_NAME=wan22-5b-ti2v`
- `WORKFLOW_NAME=ltx23-gguf-t2v`
- `WORKFLOW_NAME=ltx23-i2v-native`

When `WORKFLOW_NAME` is set, the script installs only the resolved public assets for that exact workflow.

If `WORKFLOW_NAME` is not set, you can fall back to the broader family selector with `WORKFLOW_MODEL_PACK`.

The provisioning script can install one of two built-in workflow families:

- `WORKFLOW_MODEL_PACK=moody-zib-zit`
- `WORKFLOW_MODEL_PACK=ltx`
- `WORKFLOW_MODEL_PACK=wan22`

Or skip built-in packs entirely:

- `WORKFLOW_MODEL_PACK=none`

This is useful if you want one template that can be switched between the Moody/ZIB/ZIT stack and the LTX stack without editing the script itself.

### Important limitations

- The built-in packs only include files with public, reasonably trustworthy direct download URLs.
- The workflow selector also only includes files with public, reasonably trustworthy direct download URLs.
- Some workflow-referenced files still do not have a verified public direct URL and are therefore not installed by the built-in packs.
- You can layer `CUSTOM_MODEL_URL`, `CUSTOM_MODEL_EXTRA_URLS`, and `CUSTOM_MODEL_EXTRA_SPECS` on top of the selected workflow or pack.

## Important note about PROVISIONING_SCRIPT

Vast expects `PROVISIONING_SCRIPT` to be a URL, not a local file path.

That means this local `provisioning_script.sh` is a starter file you should upload somewhere reachable, for example:

- GitHub repository raw URL
- GitHub Gist raw URL
- another HTTPS-hosted raw file URL

## Model placement guidance

Use the correct ComfyUI subdirectory for each asset type:

- `models/diffusion_models/` for diffusion model weights
- `models/checkpoints/` for checkpoint-based workflows
- `models/loras/` for LoRAs
- `models/vae/` for VAEs
- `models/text_encoders/` for text encoders
- `custom_nodes/` for custom ComfyUI node repos

If your workflow references a file that is not present on the worker, the request will fail.

## Optional S3 behavior

The ComfyUI serverless wrapper supports S3 in two ways:

1. Account/template-level `S3_*` environment variables
2. Per-request `input.s3` overrides

If you want S3 to be optional, the cleanest setup is:

- leave account/template-level `S3_*` unset
- pass `input.s3` only on requests that should upload outputs

### Consequence of no S3

Without S3, outputs only exist on the worker's local disk and are not durable or externally accessible in a useful way for normal serverless usage.

For Wan 2.2 video generation, that usually means:

- okay for dev/testing
- not a good production delivery path

## Minimal request pattern

When you want uploads:

```json
{
  "input": {
    "workflow_json": {},
    "s3": {
      "access_key_id": "...",
      "secret_access_key": "...",
      "endpoint_url": "...",
      "bucket_name": "...",
      "region": "..."
    }
  }
}
```

When you do not want uploads:

```json
{
  "input": {
    "workflow_json": {}
  }
}
```

## Suggested rollout plan

1. Create the custom template.
2. Host the provisioning script and point `PROVISIONING_SCRIPT` at it.
3. Test the template as an **interactive instance** first.
4. Verify that:
   - ComfyUI starts
   - your custom model is present in the expected folder
   - your custom nodes load cleanly
   - the workflow runs manually
5. Only then create the serverless workergroup/endpoint.

## Recommended next improvement

If your custom assets are large and reused often, move from `PROVISIONING_SCRIPT` to a **custom Docker image**. That reduces cold start time and removes runtime dependency on external downloads.
