#!/usr/bin/env bash
# Bootstrap: دانلود و اجرای نصب‌کننده WVPN با یک دستور
# روی سرور خام هم پیش‌نیازها (curl و...) خودکار نصب می‌شوند.
#
#   curl -fsSL https://raw.githubusercontent.com/lokidv/wvpn/main/install.sh | sudo bash

set -euo pipefail

INSTALL_URL="${WVPN_INSTALL_URL:-https://raw.githubusercontent.com/lokidv/wvpn/main/install_wire.sh}"
TMP="/tmp/wvpn-install-wire.sh"

if [[ "${EUID}" -ne 0 ]]; then
  echo "لطفاً با root اجرا کنید: curl ... | sudo bash"
  exit 1
fi

bootstrap_download_tools() {
  if command -v curl >/dev/null 2>&1 || command -v wget >/dev/null 2>&1; then
    return 0
  fi
  echo "نصب curl برای دانلود اسکریپت ..."
  if command -v apt-get >/dev/null 2>&1; then
    apt-get update -qq
    DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates curl gnupg
    return 0
  fi
  echo "curl/wget یا apt-get یافت نشد"
  exit 1
}

bootstrap_download_tools

echo "در حال دریافت install_wire.sh ..."
if command -v curl >/dev/null 2>&1; then
  curl -fsSL "$INSTALL_URL" -o "$TMP"
elif command -v wget >/dev/null 2>&1; then
  wget -qO "$TMP" "$INSTALL_URL"
else
  echo "curl یا wget نیاز است"
  exit 1
fi

chmod +x "$TMP"
exec bash "$TMP" "$@"
