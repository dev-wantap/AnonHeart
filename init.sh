#!/usr/bin/env bash
# ==============================================================
# nashville init.sh
# 백엔드 및 프론트엔드 레포를 clone합니다.
# 이미 존재하면 건너뜁니다.
#
# 사용: ./init.sh
# ==============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

info()  { echo -e "\033[0;34m[INFO]\033[0m $*"; }
ok()    { echo -e "\033[0;32m[OK]\033[0m $*"; }
warn()  { echo -e "\033[0;33m[WARN]\033[0m $*"; }

# --- 백엔드 clone ---
BACKEND_DIR="${SCRIPT_DIR}/anonLove"
BACKEND_REPO="https://github.com/thecoldestm0ment/anonLove"

if [ -d "${BACKEND_DIR}/.git" ]; then
    ok "anonLove 디렉토리가 이미 존재합니다. 건너뜁니다."
else
    info "백엔드를 clone합니다: ${BACKEND_REPO}"
    git clone "${BACKEND_REPO}" "${BACKEND_DIR}"
    ok "백엔드 clone 완료."
fi

# --- 프론트엔드 clone ---
FRONTEND_DIR="${SCRIPT_DIR}/turtlelove-frontend"
FRONTEND_REPO="https://github.com/dev-wantap/turtlelove-frontend"

if [ -d "${FRONTEND_DIR}/.git" ]; then
    ok "turtlelove-frontend 디렉토리가 이미 존재합니다. 건너뜁니다."
else
    info "프론트엔드를 clone합니다: ${FRONTEND_REPO}"
    git clone "${FRONTEND_REPO}" "${FRONTEND_DIR}"
    ok "프론트엔드 clone 완료."
fi

# --- .env 파일 준비 안내 ---
ENV_FILE="${SCRIPT_DIR}/.env"
ENV_EXAMPLE="${SCRIPT_DIR}/.env.example"

if [ ! -f "${ENV_FILE}" ] && [ -f "${ENV_EXAMPLE}" ]; then
    warn ".env 파일이 없습니다. 다음 명령을 실행하여 생성합니다:"
    warn "  cp .env.example .env"
    warn "생성한 후 MAIL_USERNAME, MAIL_PASSWORD 등을 채워 넣습니다."
else
    ok ".env 파일이 존재합니다."
fi

echo ""
info "초기화 완료. 다음 단계:"
info "  1. .env 파일을 확인하고 필요한 값을 채웁니다."
info "  2. docker compose up -d --build 를 실행합니다."
