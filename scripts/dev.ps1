#!/usr/bin/env pwsh
param()

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path | Join-Path -ChildPath '..' | Resolve-Path
Set-Location $root

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Error 'Docker is required to run the dev environment.'
}

try {
    docker info *> $null
}
catch {
    $hint = @'
Docker could not be reached.

On Windows, this typically means Docker Desktop is not running with administrative privileges or your account is not part of the `docker-users` group.

1. Launch Docker Desktop using "Run as administrator" at least once.
2. Add your Windows user to the `docker-users` group (`net localgroup docker-users %USERNAME% /add`).
3. Sign out and back in, then rerun this script.
'@

    Write-Error ("$hint`nOriginal error: {0}" -f $_.Exception.Message)
}

Write-Host '[spot] starting infrastructure containers...'
docker compose up -d postgres opensearch opensearch-dashboards

function Wait-Postgres {
    for ($i = 0; $i -lt 30; $i++) {
        $result = docker compose exec -T postgres pg_isready -U ${env:POSTGRES_USER ?? 'spot'} -d spot 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host '[spot] postgres is ready.'
            return
        }
        Write-Host "[spot] waiting for postgres (attempt $($i + 1)/30)..."
        Start-Sleep -Seconds 2
    }
    throw 'postgres did not become ready in time.'
}

function Wait-OpenSearch {
    for ($i = 0; $i -lt 30; $i++) {
        docker compose exec -T opensearch curl -sf http://localhost:9200 >$null 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host '[spot] opensearch is ready.'
            return
        }
        Write-Host "[spot] waiting for opensearch (attempt $($i + 1)/30)..."
        Start-Sleep -Seconds 2
    }
    throw 'opensearch did not become ready in time.'
}

Wait-Postgres
Wait-OpenSearch

if (Get-Command dotnet-ef -ErrorAction SilentlyContinue) {
    Write-Host '[spot] applying EF Core migrations (if any)...'
    try {
        dotnet ef database update --project apps/server/Spot.Api/Spot.Api.csproj
    }
    catch {
        Write-Warning '[spot] no migrations available yet.'
    }
}
else {
    Write-Warning '[spot] dotnet-ef not found; skipping migrations.'
}

Write-Host '[spot] starting dotnet watch processes...'
$env:DOTNET_WATCH_SUPPRESS_LAUNCH_BROWSER = '1'

$server = Start-Process dotnet -ArgumentList 'watch', '--project', 'apps/server/Spot.Api/Spot.Api.csproj', 'run' -PassThru
$client = Start-Process dotnet -ArgumentList 'watch', '--project', 'apps/web/Spot.Web/Spot.Web.csproj', 'run' -PassThru

Start-Sleep -Seconds 5
try {
    Start-Process python -ArgumentList '-m', 'webbrowser', 'http://localhost:5173' -WindowStyle Hidden | Out-Null
}
catch {
    Write-Warning 'Unable to auto-open the browser.'
}

Write-Host '[spot] API running at http://localhost:5187'
Write-Host '[spot] PWA available at http://localhost:5173'

try {
    Wait-Process -Id $server.Id, $client.Id
}
finally {
    Write-Host '[spot] shutting down...'
    if (-not $server.HasExited) { $server.Kill() }
    if (-not $client.HasExited) { $client.Kill() }
}
