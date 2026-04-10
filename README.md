# tokenrouter-tools

A CLI tool to set up Codex configuration with your TokenRouter API key.

## Quick Install

Run the following command in your terminal, replacing `<YOUR_API_KEY>` with your actual key:

```bash
curl -fsSL https://raw.githubusercontent.com/PaleBlueDot-AI-Open/tokenrouter-tools/main/install.sh | bash -s -- --key <YOUR_API_KEY>
```

This will automatically detect your platform (macOS/Linux, amd64/arm64), download the appropriate binary, install it to `/usr/local/bin`, and run it.

## Supported Platforms

| OS    | Architecture |
|-------|-------------|
| macOS | arm64       |
| macOS | amd64       |
| Linux | arm64       |
| Linux | amd64       |

## Advanced Options

### Custom install directory

```bash
INSTALL_DIR=~/.local/bin curl -fsSL https://raw.githubusercontent.com/PaleBlueDot-AI-Open/tokenrouter-tools/main/install.sh | bash -s -- --key <YOUR_API_KEY>
```

### Run the binary directly (if already installed)

```bash
tokenrouter_to_codex --key <YOUR_API_KEY>
```
