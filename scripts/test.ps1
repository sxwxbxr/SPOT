#!/usr/bin/env pwsh
param(
    [switch] $IncludeE2E
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path | Join-Path -ChildPath '..' | Resolve-Path
Set-Location $root

dotnet test spot.sln --filter "FullyQualifiedName!~Spot.E2E" --no-build

if ($IncludeE2E) {
    Write-Host '[spot] running Playwright smoke tests...'
    dotnet test tests/e2e/e2e.csproj --no-build
}
else {
    Write-Host '[spot] skipping Playwright tests (pass -IncludeE2E to enable)'
}
