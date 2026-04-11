#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# tokenrouter_to_codex runner
# Usage: curl -fsSL <URL>/install.sh | bash -s -- <YOUR_KEY>
# ============================================================

BASE_URL="https://raw.githubusercontent.com/PaleBlueDot-AI-Open/tokenrouter-tools/main"
BINARY_NAME="tokenrouter_to_codex"

# ---- helpers ----
info()  { printf '\033[1;34m[info]\033[0m  %s\n' "$*"; }
error() { printf '\033[1;31m[error]\033[0m %s\n' "$*" >&2; exit 1; }

# ---- parse args ----
KEY="${1:-}"
[[ -z "$KEY" ]] && error "Usage: curl -fsSL <URL>/install.sh | bash -s -- <YOUR_KEY>"

# ---- detect platform ----
OS="$(uname -s)"
ARCH="$(uname -m)"

case "$OS" in
  Linux)  OS_TAG="linux"  ;;
  Darwin) OS_TAG="darwin"  ;;
  *)      error "Unsupported OS: $OS" ;;
esac

case "$ARCH" in
  x86_64)       ARCH_TAG="amd64" ;;
  aarch64|arm64) ARCH_TAG="arm64" ;;
  *)            error "Unsupported architecture: $ARCH" ;;
esac

DOWNLOAD_URL="${BASE_URL}/${BINARY_NAME}_${OS_TAG}_${ARCH_TAG}"
info "Platform: ${OS_TAG}/${ARCH_TAG}"
info "Downloading from: ${DOWNLOAD_URL}"

# ---- download to temp dir ----
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

if command -v curl &>/dev/null; then
  curl -fsSL -o "${TMP_DIR}/${BINARY_NAME}" "$DOWNLOAD_URL"
elif command -v wget &>/dev/null; then
  wget -qO "${TMP_DIR}/${BINARY_NAME}" "$DOWNLOAD_URL"
else
  error "Neither curl nor wget found. Please install one and retry."
fi

chmod +x "${TMP_DIR}/${BINARY_NAME}"

# ---- run ----
info "Running: ${BINARY_NAME} ****${KEY: -4}"
"${TMP_DIR}/${BINARY_NAME}" "$KEY"

info "Done!"
