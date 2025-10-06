#!/usr/bin/env pwsh
param()

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path | Join-Path -ChildPath '..' | Resolve-Path
Set-Location $root

$artifacts = Join-Path $root 'artifacts'
if (Test-Path $artifacts) {
    Remove-Item $artifacts -Recurse -Force
}
New-Item -ItemType Directory -Path $artifacts | Out-Null

dotnet restore
dotnet build --no-restore -c Release

dotnet publish apps/server/Spot.Api/Spot.Api.csproj --no-build -c Release -o (Join-Path $artifacts 'api')
dotnet publish apps/web/Spot.Web/Spot.Web.csproj --no-build -c Release -o (Join-Path $artifacts 'web')

Write-Host "Artifacts published to $artifacts"
