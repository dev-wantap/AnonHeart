# AnonHeart — nashville

익명 연애상담 커뮤니티 **TurtleLove**의 전체 스택 배포용 저장소입니다.

## 아키텍처

```
[사용자 브라우저]
       |
       | HTTP :3000
       v
┌─────────────────────┐
│   frontend (Nginx)   │
│   - 정적 파일 서비스   │
│   - /api/  → proxy   │
│   - /ws    → proxy   │
└────────┬────────────┘
         |  내부 네트워크 (anonlove-network)
         v
┌─────────────────────┐     ┌──────────┐
│   backend            │────>│  mysql   │
│   (Spring Boot)      │     │  8.0     │
│   :8080              │     └──────────┘
│                      │
│                      │────>┌──────────┐
│                      │     │  redis   │
└─────────────────────┘     │  7       │
                             └──────────┘
```

- 외부로 열린 포트: **3000** (frontend, prod 기준)
- `backend`, `mysql`, `redis`는 내부 네트워크만 사용 (dev 환경에서는 호스트 포트도 노출됨)

---

## 사전 요구사항

| 항목 | 권장 버전 |
|------|-----------|
| Docker | 24.0 이상 |
| Docker Compose | v2 (`docker compose` 명령) |
| Git | - |

---

## 빠른 시작 (Quick Start)

### Step 1. 저장소 초기화

```bash
git clone https://github.com/dev-wantap/AnonHeart.git
cd AnonHeart
chmod +x init.sh
./init.sh
```

`init.sh`는 백엔드(`anonLove`)와 프론트엔드(`turtlelove-frontend`)를 자동으로 clone합니다. 이미 존재하면 건너뜁니다.

### Step 2. 환경변수 설정

```bash
cp .env.example .env
```

`.env` 파일을 열어 아래 값을 채웁니다.

| 변수 | 필수 | 기본값 | 설명 |
|------|------|--------|------|
| `DB_PASSWORD` | 선택 | `anonlove123` | MySQL root 비밀번호 |
| `MAIL_USERNAME` | **필수** | - | Gmail 주소 |
| `MAIL_PASSWORD` | **필수** | - | Gmail 앱 비밀번호 ([생성 안내](https://myaccount.google.com/apppasswords)) |

### Step 3. 스택 시작

**prod 환경** (frontend만 호스트 포트 노출):

```bash
docker compose up -d --build
```

**dev 환경** (backend, mysql, redis 호스트 포트도 노출):

```bash
docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d --build
```

### Step 4. 접속 확인

| 항목 | URL |
|------|-----|
| 프론트엔드 | http://localhost:3000 |
| API (nginx 프록시) | http://localhost:3000/api/ |
| WebSocket (nginx 프록시) | ws://localhost:3000/ws |

dev 환경에서만 추가로 접근 가능:

| 항목 | URL |
|------|-----|
| backend (직접) | http://localhost:8080 |
| MySQL | `localhost:3306` (root / `DB_PASSWORD`) |
| Redis | `localhost:6379` |

---

## 환경별 포트 정리

| 서비스 | prod | dev |
|--------|------|-----|
| frontend | 3000 | 3000 |
| backend | 미노출 | 8080 |
| mysql | 미노출 | 3306 |
| redis | 미노출 | 6379 |

---

## 유용한 명령어

```bash
# --- prod 환경 ---
docker compose up -d --build          # 백그라운드 시작 (빌드 포함)
docker compose up -d                  # 이미지 재빌드 없이 시작
docker compose down                   # 컨테이너 중지 (볼륨 유지)
docker compose down -v                # 컨테이너 및 볼륨 모두 삭제 (DB 초기화)

# --- dev 환경 ---
docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d --build
docker compose -f docker-compose.yml -f docker-compose.dev.yml down

# --- 공통 ---
docker compose ps                     # 서비스 상태 확인
docker compose logs -f                # 모든 서비스 로그
docker compose logs -f backend        # 백엔드 로그만
docker compose logs -f frontend       # 프론트엔드 로그만

# --- 컨테이너에 접근 ---
docker exec -it nashville-backend bash
docker exec -it nashville-mysql bash
docker exec -it nashville-redis redis-cli
```

---

## 프로젝트 구조

```
nashville/
├── docker-compose.yml          # prod 기본 스택 정의
├── docker-compose.dev.yml      # dev 환경 포트 override
├── .env.example                # 환경변수 템플릿
├── .env                        # 실제 환경변수 (gitignore)
├── init.sh                     # 백엔드/프론트엔드 clone 스크립트
├── .gitignore
├── anonLove/                   # Spring Boot 백엔드 (별도 저장소)
│   ├── Dockerfile
│   ├── build.gradle
│   └── src/
└── turtlelove-frontend/        # React 프론트엔드 (별도 저장소)
    ├── Dockerfile
    ├── nginx.conf
    └── src/
```
