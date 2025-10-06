#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if ! command -v dotnet-ef >/dev/null 2>&1; then
  echo "dotnet-ef is required. Install via 'dotnet tool install --global dotnet-ef'." >&2
  exit 1
fi

docker compose up -d postgres

dotnet ef database update --project apps/server/Spot.Api/Spot.Api.csproj "$@"
