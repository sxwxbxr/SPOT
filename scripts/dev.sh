#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export DOTNET_WATCH_SUPPRESS_LAUNCH_BROWSER=1

cd "$ROOT_DIR"

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is required to run the dev environment." >&2
  exit 1
fi

echo "[spot] starting infrastructure containers..."
docker compose up -d postgres opensearch opensearch-dashboards

wait_for_postgres() {
  for attempt in {1..30}; do
    if docker compose exec -T postgres pg_isready -U "${POSTGRES_USER:-spot}" -d spot >/dev/null 2>&1; then
      echo "[spot] postgres is ready."
      return 0
    fi
    echo "[spot] waiting for postgres (${attempt}/30)..."
    sleep 2
  done
  echo "[spot] postgres did not become ready in time." >&2
  return 1
}

wait_for_opensearch() {
  for attempt in {1..30}; do
    if docker compose exec -T opensearch curl -sf http://localhost:9200 >/dev/null 2>&1; then
      echo "[spot] opensearch is ready."
      return 0
    fi
    echo "[spot] waiting for opensearch (${attempt}/30)..."
    sleep 2
  done
  echo "[spot] opensearch did not become ready in time." >&2
  return 1
}

wait_for_postgres
wait_for_opensearch

if command -v dotnet-ef >/dev/null 2>&1; then
  echo "[spot] applying EF Core migrations (if any)..."
  dotnet ef database update --project apps/server/Spot.Api/Spot.Api.csproj || echo "[spot] no migrations available yet."
else
  echo "[spot] dotnet-ef not found; skipping migrations."
fi

echo "[spot] starting dotnet watch processes..."
trap 'echo "[spot] shutting down..."; kill 0' INT TERM EXIT

ASPNETCORE_ENVIRONMENT=Development dotnet watch --project apps/server/Spot.Api/Spot.Api.csproj run &

dotnet watch --project apps/web/Spot.Web/Spot.Web.csproj run &

sleep 5
python -m webbrowser "http://localhost:5173" >/dev/null 2>&1 || true

echo "[spot] API running at http://localhost:5187"
echo "[spot] PWA available at http://localhost:5173"

wait
