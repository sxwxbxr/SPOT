#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

INCLUDE_E2E=false
if [[ ${1:-} == "--include-e2e" ]]; then
  INCLUDE_E2E=true
fi

dotnet test spot.sln --filter "FullyQualifiedName!~Spot.E2E" --no-build

if [[ "$INCLUDE_E2E" == "true" ]]; then
  echo "[spot] running Playwright smoke tests..."
  dotnet test tests/e2e/e2e.csproj --no-build
else
  echo "[spot] skipping Playwright tests (pass --include-e2e to enable)"
fi
