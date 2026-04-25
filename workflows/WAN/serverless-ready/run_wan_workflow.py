import argparse
import asyncio
import json
from pathlib import Path

from vastai import Serverless


def load_json(path: Path):
    with path.open("r", encoding="utf-8") as f:
        return json.load(f)


def maybe_s3_from_args(args):
    if not args.s3_endpoint_url:
        return None
    return {
        "access_key_id": args.s3_access_key_id or "",
        "secret_access_key": args.s3_secret_access_key or "",
        "endpoint_url": args.s3_endpoint_url,
        "bucket_name": args.s3_bucket_name or "",
        "region": args.s3_region or "",
    }


async def run(endpoint_name: str, workflow_path: Path, s3: dict | None):
    workflow = load_json(workflow_path)

    payload = {
        "input": {
            "request_id": "",
            "workflow_json": workflow,
        }
    }

    if s3:
        payload["input"]["s3"] = s3

    async with Serverless() as client:
        endpoint = await client.get_endpoint(name=endpoint_name)
        response = await endpoint.request("/generate/sync", payload)
        print(json.dumps(response["response"], indent=2))


def main():
    parser = argparse.ArgumentParser(description="Run a WAN workflow against a Vast serverless endpoint.")
    parser.add_argument("--endpoint", required=True, help="Vast serverless endpoint name")
    parser.add_argument("--workflow", required=True, help="Path to workflow JSON")
    parser.add_argument("--s3-access-key-id")
    parser.add_argument("--s3-secret-access-key")
    parser.add_argument("--s3-endpoint-url")
    parser.add_argument("--s3-bucket-name")
    parser.add_argument("--s3-region")
    args = parser.parse_args()

    asyncio.run(run(args.endpoint, Path(args.workflow), maybe_s3_from_args(args)))


if __name__ == "__main__":
    main()
