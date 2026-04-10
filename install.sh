#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# tokenrouter_to_codex installer
# Usage: curl -fsSL <URL>/install.sh | bash -s -- <YOUR_KEY>
# ============================================================

BASE_URL="${TOKENROUTER_BASE_URL:-https://raw.githubusercontent.com/PaleBlueDot-AI-Open/tokenrouter-tools/main}"
BINARY_NAME="tokenrouter_to_codex"
INSTALL_DIR="${INSTALL_DIR:-/usr/local/bin}"

# ---- helpers ----
info()  { printf '\033[1;34m[info]\033[0m  %s\n' "$*"; }
error() { printf '\033[1;31m[error]\033[0m %s\n' "$*" >&2; exit 1; }

# ---- parse args ----
KEY=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --key)
      [[ -z "${2:-}" ]] && error "--key requires a value"
      KEY="$2"; shift 2 ;;
    --key=*)
      KEY="${1#--key=}"; shift ;;
    *)
      error "Unknown argument: $1" ;;
  esac
done

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

# ---- download ----
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

# ---- install ----
if [[ -w "$INSTALL_DIR" ]]; then
  mv "${TMP_DIR}/${BINARY_NAME}" "${INSTALL_DIR}/${BINARY_NAME}"
else
  info "Need sudo to install to ${INSTALL_DIR}"
  sudo mv "${TMP_DIR}/${BINARY_NAME}" "${INSTALL_DIR}/${BINARY_NAME}"
fi

info "Installed ${BINARY_NAME} to ${INSTALL_DIR}/${BINARY_NAME}"

# ---- run ----
info "Running: ${BINARY_NAME} ****${KEY: -4}"
"${INSTALL_DIR}/${BINARY_NAME}" "$KEY"

info "Done!"
