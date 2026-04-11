# ============================================================
# tokenrouter_to_codex runner (Windows)
# Usage: irm https://raw.githubusercontent.com/PaleBlueDot-AI-Open/tokenrouter-tools/main/install.ps1 | iex
# Then: install <YOUR_KEY>
# ============================================================

$ErrorActionPreference = "Stop"

function install {
    param([string]$Key)

    if (-not $Key) {
        Write-Host "[error] Usage: install <YOUR_KEY>" -ForegroundColor Red
        return
    }

    $BaseUrl = "https://raw.githubusercontent.com/PaleBlueDot-AI-Open/tokenrouter-tools/main"
    $BinaryName = "tokenrouter_to_codex.exe"
    $DownloadUrl = "$BaseUrl/$BinaryName"

    Write-Host "[info]  Downloading from: $DownloadUrl" -ForegroundColor Cyan

    $TmpDir = Join-Path $env:TEMP "tokenrouter_$(Get-Random)"
    New-Item -ItemType Directory -Path $TmpDir -Force | Out-Null
    $BinaryPath = Join-Path $TmpDir $BinaryName

    try {
        Invoke-WebRequest -Uri $DownloadUrl -OutFile $BinaryPath -UseBasicParsing
        $MaskedKey = "****" + $Key.Substring([Math]::Max(0, $Key.Length - 4))
        Write-Host "[info]  Running: $BinaryName $MaskedKey" -ForegroundColor Cyan
        & $BinaryPath $Key
        Write-Host "[info]  Done!" -ForegroundColor Cyan
    }
    finally {
        Remove-Item -Recurse -Force $TmpDir -ErrorAction SilentlyContinue
    }
}
