import argparse
import asyncio
import json
from pathlib import Path

from vastai import Serverless


def load_json(path: Path):
    with path.open("r", encoding="utf-8") as f:
        return json.load(f)


def apply_overrides(workflow: dict, prompt: str | None, output_prefix: str | None):
    for node in workflow.get("nodes", []):
        if prompt and node.get("title") == "CLIP Text Encode (Positive Prompt)":
            widgets = node.get("widgets_values") or []
            if widgets:
                widgets[0] = prompt

        if output_prefix and node.get("type") == "SaveImage":
            widgets = node.get("widgets_values") or []
            if widgets:
                widgets[0] = output_prefix

    return workflow


async def run(endpoint_name: str, workflow_path: Path, prompt: str | None, output_prefix: str | None):
    workflow = apply_overrides(load_json(workflow_path), prompt, output_prefix)
    payload = {"input": {"request_id": "", "workflow_json": workflow}}

    async with Serverless() as client:
        endpoint = await client.get_endpoint(name=endpoint_name)
        response = await endpoint.request("/generate/sync", payload)
        print(json.dumps(response["response"], indent=2))


def main():
    parser = argparse.ArgumentParser(description="Run a ZIMAGE workflow against a Vast serverless endpoint.")
    parser.add_argument("--endpoint", required=True)
    parser.add_argument("--workflow", required=True)
    parser.add_argument("--prompt")
    parser.add_argument("--output-prefix")
    args = parser.parse_args()

    asyncio.run(run(args.endpoint, Path(args.workflow), args.prompt, args.output_prefix))


if __name__ == "__main__":
    main()
