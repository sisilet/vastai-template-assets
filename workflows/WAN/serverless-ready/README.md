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

Before using:

- replace the positive prompt text with your actual prompt
- for I2V/TI2V, replace the placeholder image URL with a real public image URL
