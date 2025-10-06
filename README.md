# path: README.md
# SPOT

Spot is a .NET 8 monorepo that hosts a Blazor WebAssembly PWA, an ASP.NET Core Web API, shared Razor UI components, shared domain logic, and typed API clients. The repo is optimized for offline-first workflows, reproducible tooling, and infrastructure parity between local Docker and on-prem deployments.

## Prerequisites

- [.NET SDK 8.0](https://dotnet.microsoft.com/download/dotnet/8.0)
- [Node.js 18+](https://nodejs.org/) (for Playwright installation)
- [Docker Desktop or Docker Engine](https://docs.docker.com/get-docker/)
- PowerShell 7+ **or** a POSIX shell (macOS/Linux WSL2)

Optional but recommended:

- [just](https://github.com/casey/just) command runner
- `npx playwright install --with-deps` (once per machine) to set up browsers for E2E tests

## Quickstart

```bash
# restore tools & dependencies
dotnet restore

# install Playwright browsers (first run only)
npx playwright install --with-deps

# start the full dev stack (Docker + watchers + browser)
./scripts/dev.sh
# or on Windows PowerShell
./scripts/dev.ps1
```

Once the script completes:

- API: `http://localhost:5187` (Swagger UI at `/swagger`)
- PWA: `http://localhost:5173`
- OpenSearch Dashboards: `http://localhost:5601`
- PostgreSQL: `localhost:5432`

## Repository Layout

```
spot.sln
apps/
  web/Spot.Web/         # Blazor WebAssembly PWA
  server/Spot.Api/      # ASP.NET Core Web API
packages/
  ui/Spot.UI/           # Shared Razor components
  core/Spot.Core/       # Domain models and contracts
  client-sdk/Spot.ClientSdk/  # Typed API client (Refit)
infra/
  docker-compose.yml    # Docker infrastructure (future artifacts)
scripts/                # Cross-platform automation helpers
tests/
  client.tests/         # Client unit tests
  core.tests/           # Domain unit tests
  server.tests/         # API integration/unit tests
  e2e/                  # Playwright smoke tests
.github/workflows/ci.yml
```

## Configuration & Secrets

- All configuration is read from `appsettings.json` with overrides via environment variables.
- Connection strings and API keys **must** be provided through environment variables or [User Secrets](https://learn.microsoft.com/aspnet/core/security/app-secrets).
- The Docker stack expects `POSTGRES_PASSWORD` and `OPENSEARCH_INITIAL_ADMIN_PASSWORD`. Provide a `.env` file (not committed) or export env vars before running scripts.

## Scripts

- `./scripts/dev.sh` / `./scripts/dev.ps1` — boot Docker services, apply EF Core migrations, run API & PWA watchers, and open the PWA.
- `./scripts/build.sh` / `./scripts/build.ps1` — deterministic restore, build, and publish to `artifacts/`.
- `./scripts/test.sh` / `./scripts/test.ps1` — run unit/integration tests (optionally E2E with `--include-e2e`).
- `./scripts/migrate.sh` / `./scripts/migrate.ps1` — execute `dotnet ef database update` against the configured Postgres instance.
- `./scripts/seed.sh` / `./scripts/seed.ps1` — placeholder for future data seeding.

If you have `just` installed, the `justfile` exposes the same commands (`just dev`, `just build`, etc.).

## One-Command Dev

- **macOS/Linux:** `./scripts/dev.sh`
- **Windows:** `./scripts/dev.ps1`

Both scripts:

1. Start PostgreSQL and OpenSearch via Docker Compose.
2. Wait for health checks.
3. Apply EF Core migrations (no-op today).
4. Run `dotnet watch` for the API and PWA concurrently.
5. Open the browser to the PWA (`http://localhost:5173`).

## Testing

```bash
# unit + integration tests
./scripts/test.sh

# include Playwright once browsers are installed
./scripts/test.sh --include-e2e
```

The Playwright project targets the running PWA; ensure the dev server is running or use the future CI harness before executing the smoke.

## Continuous Integration

GitHub Actions workflow (`.github/workflows/ci.yml`) restores dependencies, builds the solution, and executes tests on push/pull requests with caching enabled for NuGet and Playwright assets.

## Next Steps

- Implement EF Core DbContext and initial migrations.
- Integrate OpenSearch client wiring and Microsoft Graph/FileCloud adapters.
- Flesh out offline sync flow and IndexedDB schema.
- Add production Dockerfiles and GitHub Action deployments.
