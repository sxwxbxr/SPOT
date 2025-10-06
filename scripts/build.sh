#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

ARTIFACTS_DIR="$ROOT_DIR/artifacts"
rm -rf "$ARTIFACTS_DIR"
mkdir -p "$ARTIFACTS_DIR"

dotnet restore

dotnet build --no-restore -c Release

dotnet publish apps/server/Spot.Api/Spot.Api.csproj --no-build -c Release -o "$ARTIFACTS_DIR/api"
dotnet publish apps/web/Spot.Web/Spot.Web.csproj --no-build -c Release -o "$ARTIFACTS_DIR/web"

echo "Artifacts published to $ARTIFACTS_DIR"
