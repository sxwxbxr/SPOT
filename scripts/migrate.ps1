#!/usr/bin/env pwsh
param(
    [string[]] $Args
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path | Join-Path -ChildPath '..' | Resolve-Path
Set-Location $root

if (-not (Get-Command dotnet-ef -ErrorAction SilentlyContinue)) {
    Write-Error "dotnet-ef is required. Install via 'dotnet tool install --global dotnet-ef'."
}

docker compose up -d postgres

dotnet ef database update --project apps/server/Spot.Api/Spot.Api.csproj @Args
