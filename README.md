# vastai-template-assets

Assets and helper files for building Vast.ai serverless templates around ComfyUI workflows.

## Main folders

- `wan22-custom-template/`: provisioning scripts, env examples, manifests, and notes for custom Wan 2.2 templates
- `workflows/`: workflow JSON files and workflow-specific notes
- `docs/`: extracted notes and node specs

## Typical use

1. Pick a workflow-specific provisioning script from `wan22-custom-template/provisioning/`.
2. Use its raw GitHub URL as the `PROVISIONING_SCRIPT` value in a Vast template.
3. Set `WORKFLOW_NAME` when using `wan22-custom-template/provisioning_script.sh` or use a workflow-specific script directly.

See `wan22-custom-template/README.md` for the working template setup.
