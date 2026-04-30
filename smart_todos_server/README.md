# Serverpod Server - To'liq Qo'llanma

## 📋 Loyihaning Tuzilishi

```
smart_todos_server/
├── bin/main.dart              # Serverning kirish nuqtasi
├── lib/
│   ├── server.dart           # Asosiy server konfiguratsiyasi
│   └── src/
│       ├── generated/        # Avtomatik yaratilgan kodlar
│       └── web/              # Web marshrutlar
├── config/                   # Konfiguratsiya fayllar
├── migrations/               # Ma'lumotlar bazasi migratsiyalari
├── web/                      # Statik fayllar
├── Dockerfile                # Docker image yaratish
├── docker-compose.yaml       # Docker Compose konfiguratsiyasi
├── docker-entrypoint.sh      # Docker entrypoint skripti
├── .env                      # Muhit o'zgaruvchilari
├── .env.example              # O'rnak .env fayli
└── DOCKER_SETUP.md           # Docker setup qo'llanmasi
```

## 🚀 Tezkor Boshlash

### 1. Tayyorgarlik

```bash
# Kerakli katalogga o'ting
cd smart_todos_server

# .env faylini yaratish
cp .env.example .env

# .env faylini tahrirlash (ixtiyoriy)
nano .env
```

### 2. To'liq Deploy

```bash
# Barcha xizmatlarni ishga tushirish
docker compose up -d --build
```

Bu komanda avtomatik ravishda:
- Docker imagelarni quradi
- PostgreSQL bazalarini ishga tushiradi
- Ma'lumotlar bazasi migratsiyalarini bajaradi
- Serverpod serverni ishga tushiradi

### 3. Tekshirish

```bash
# Xizmatlar holatini tekshirish
docker compose ps

# Server loglarini ko'rish
docker compose logs -f serverpod

# PostgreSQL loglarini ko'rish
docker compose logs postgres
```

## ⚙️ Konfiguratsiya

### .env Fayli Parametrlari

```env
# Serverpod Konfiguratsiyasi
RUNMODE=production          # production/development/test
SERVERID=default           # Server identifikatori
LOGGING=normal             # normal/verbose/quiet
ROLE=monolith              # monolith/single/worker

# PostgreSQL Development Database
POSTGRES_USER=postgres
POSTGRES_PASSWORD=jg4XMmDJYEWVD_Lzv5cVI4ynxniqPTZW
POSTGRES_DB=smart_todos
POSTGRES_PORT=5432
POSTGRES_HOST=postgres

# PostgreSQL Test Database
POSTGRES_TEST_USER=postgres
POSTGRES_TEST_PASSWORD=pvHt_A4DvbqS7cGAOnPXKJYXCthx8c_X
POSTGRES_TEST_DB=smart_todos_test
POSTGRES_TEST_PORT=5432
POSTGRES_TEST_HOST=postgres_test

# Server Portlari
SERVER_PORT=8080           # Asosiy API port
INSIGHTS_PORT=8081         # Insights port
WEB_PORT=8082              # Web server port

# Docker Compose Portlari
POSTGRES_EXTERNAL_PORT=8090      # PostgreSQL tashqi port
POSTGRES_TEST_EXTERNAL_PORT=9090 # Test PostgreSQL tashqi port
```

### Serverpod Konfiguratsiya Fayllari

`config/` katalogida quyidagi fayllar mavjud:

- `development.yaml` - Development muhiti
- `production.yaml` - Production muhiti
- `staging.yaml` - Staging muhiti
- `test.yaml` - Test muhiti
- `passwords.yaml` - Parollar va tokenlar
- `generator.yaml` - Kod generator konfiguratsiyasi

## 🐳 Docker Konfiguratsiyasi

### Dockerfile Tahlili

```dockerfile
# Build bosqichi
FROM dart:3.8.0 AS build
WORKDIR /app
COPY . .
RUN dart pub get
RUN dart compile exe bin/main.dart -o bin/server

# Final bosqichi
FROM alpine:latest
RUN apk add --no-cache postgresql-client bash

# Ishchi katalog
WORKDIR /app

# Muhit o'zgaruvchilari
ENV RUNMODE=production
ENV SERVERID=default
ENV LOGGING=normal
ENV ROLE=monolith

# Kerakli fayllarni nusxalash
COPY --from=build /app/bin/server /app/server
COPY --from=build /app/config/ /app/config/
COPY --from=build /app/web/ /app/web/
COPY --from=build /app/migrations/ /app/migrations/
COPY --from=build /app/pubspec.* /app/
COPY --from=build /usr/local/bin/dart /usr/local/bin/dart
COPY --from=build /usr/local/bin/pub /usr/local/bin/pub
COPY --from=build /app/lib/src/generated/protocol.yaml /app/lib/src/generated/protocol.yaml

# Entrypoint skripti
COPY docker-entrypoint.sh /app/docker-entrypoint.sh
RUN chmod +x /app/docker-entrypoint.sh

# Portlarni ochish
EXPOSE 8080 8081 8082

# Ishga tushirish
ENTRYPOINT ["/app/docker-entrypoint.sh"]
```

### docker-compose.yaml Tahlili

```yaml
services:
  postgres:
    image: pgvector/pgvector:pg16
    container_name: smart_todos_postgres
    ports:
      - "${POSTGRES_EXTERNAL_PORT:-8090}:5432"
    environment:
      POSTGRES_USER: ${POSTGRES_USER:-postgres}
      POSTGRES_DB: ${POSTGRES_DB:-smart_todos}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD:-jg4XMmDJYEWVD_Lzv5cVI4ynxniqPTZW}
    volumes:
      - smart_todos_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER:-postgres} -d ${POSTGRES_DB:-smart_todos}"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - smart_todos_network

  serverpod:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: smart_todos_server
    ports:
      - "${SERVER_PORT:-8080}:8080"
      - "${INSIGHTS_PORT:-8081}:8081"
      - "${WEB_PORT:-8082}:8082"
    environment:
      RUNMODE: ${RUNMODE:-production}
      SERVERID: ${SERVERID:-default}
      LOGGING: ${LOGGING:-normal}
      ROLE: ${ROLE:-monolith}
      POSTGRES_HOST: ${POSTGRES_HOST:-postgres}
      POSTGRES_USER: ${POSTGRES_USER:-postgres}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD:-jg4XMmDJYEWVD_Lzv5cVI4ynxniqPTZW}
      POSTGRES_DB: ${POSTGRES_DB:-smart_todos}
      POSTGRES_PORT: ${POSTGRES_PORT:-5432}
    depends_on:
      postgres:
        condition: service_healthy
    networks:
      - smart_todos_network
    restart: unless-stopped

volumes:
  smart_todos_data:
  smart_todos_test_data:

networks:
  smart_todos_network:
    driver: bridge
```

### docker-entrypoint.sh Skripti

```bash
#!/bin/bash
set -e

echo "Waiting for PostgreSQL to be ready..."
until PGPASSWORD="$POSTGRES_PASSWORD" psql -h "$POSTGRES_HOST" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c '\q' 2>/dev/null; do
  echo "PostgreSQL is unavailable - sleeping"
  sleep 1
done

echo "PostgreSQL is up - executing migrations..."

# Run Serverpod migrations
dart pub get
dart run serverpod_cli:cli migrate --mode production

echo "Migrations completed - starting server..."

# Start the server with environment variables
exec ./server \
  --mode=${RUNMODE:-production} \
  --server-id=${SERVERID:-default} \
  --logging=${LOGGING:-normal} \
  --role=${ROLE:-monolith}
```

## 🔧 Ishlab Chiqish Jarayoni

### Kod O'zgarishlaridan Keyin

```bash
# Serverni qayta qurish
docker compose up -d --build

# Faqat server imageni qayta qurish
docker compose build --no-cache serverpod
docker compose up -d serverpod
```

### Ma'lumotlar Bazasi Migratsiyalari

```bash
# Migratsiyalarni qo'lda bajarish
docker compose exec serverpod dart run serverpod_cli:cli migrate --mode production

# Yangi migratsiya yaratish
docker compose exec serverpod dart run serverpod_cli:cli create-migration
```

### Loglarni Kuzatish

```bash
# Server loglari
docker compose logs -f serverpod

# Barcha xizmatlar loglari
docker compose logs -f

# Oxirgi 100 qator log
docker compose logs --tail=100 serverpod
```

## 🛠️ Xatoliklarni Tuzatish

### Ma'lumotlar Bazasi Ulanish Muammolari

```bash
# PostgreSQL holatini tekshirish
docker compose ps postgres

# PostgreSQL loglarini ko'rish
docker compose logs postgres

# PostgreSQL shellga kirish
docker compose exec postgres psql -U postgres -d smart_todos

# Ma'lumotlar bazasi ulanishini test qilish
docker compose exec serverpod PGPASSWORD="$POSTGRES_PASSWORD" psql -h postgres -U postgres -d smart_todos -c "SELECT version();"
```

### Server Ishlamayotgan Holatda

```bash
# Server konteynerini qayta ishga tushirish
docker compose restart serverpod

# Server konteyneriga kirish
docker compose exec serverpod sh

# Server jarayonini tekshirish
docker compose exec serverpod ps aux | grep server

# Serverni qayta qurish
docker compose build --no-cache serverpod
docker compose up -d serverpod
```

### Portlar Band Bo'lsa

```bash
# Qaysi portlar bandligini tekshirish
lsof -i :8080
lsof -i :8090

# .env faylida portlarni o'zgartirish
SERVER_PORT=8083
POSTGRES_EXTERNAL_PORT=8091
```

### Xotira yoki CPU Muammolari

```bash
# Konteyner resurslarini tekshirish
docker stats

# Docker Compose resurslarini cheklash
services:
  serverpod:
    deploy:
      resources:
        limits:
          memory: 1G
          cpus: '1.0'
```

## 📊 Monitoring va Kuzatish

### Serverpod Insights

Server Insights `http://localhost:8081` da mavjud:

- API so'rovlari statistikasi
- Xatoliklar va ishlash vaqti
- Ma'lumotlar bazasi so'rovlari
- Xotira va CPU foydalanish

### Sog'liqni Tekshirish

```bash
# Barcha xizmatlar holati
docker compose ps

# PostgreSQL sog'liq tekshiruvi
docker compose exec postgres pg_isready -U postgres -d smart_todos

# Server javob berayotganini tekshirish
curl http://localhost:8080/health
```

## 🚀 Production Deploy

### Production .env Konfiguratsiyasi

```env
RUNMODE=production
LOGGING=normal
ROLE=monolith

# Xavfsiz parollar
POSTGRES_PASSWORD=YOUR_SECURE_DB_PASSWORD
POSTGRES_TEST_PASSWORD=YOUR_SECURE_TEST_PASSWORD

# Production portlari
SERVER_PORT=80
WEB_PORT=443
POSTGRES_EXTERNAL_PORT=5432
```

### Production Docker Compose

```yaml
services:
  serverpod:
    environment:
      - RUNMODE=production
    restart: always
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

### SSL/TLS Konfiguratsiyasi

```yaml
services:
  serverpod:
    ports:
      - "443:8082"
    environment:
      - HTTPS=true
      - CERT_PATH=/path/to/cert.pem
      - KEY_PATH=/path/to/key.pem
    volumes:
      - ./ssl:/ssl:ro
```

## 🔄 Backup va Restore

### Ma'lumotlar Bazasi Backup

```bash
# PostgreSQL backup
docker compose exec postgres pg_dump -U postgres smart_todos > backup.sql

# Docker volume backup
docker run --rm -v smart_todos_smart_todos_data:/data -v $(pwd):/backup alpine tar czf /backup/postgres_backup.tar.gz -C /data .
```

### Ma'lumotlar Bazasi Restore

```bash
# PostgreSQL restore
docker compose exec -T postgres psql -U postgres -d smart_todos < backup.sql

# Docker volume restore
docker run --rm -v smart_todos_smart_todos_data:/data -v $(pwd):/backup alpine sh -c "cd /data && tar xzf /backup/postgres_backup.tar.gz"
```

## 📝 Foydali Kommandalar

### Docker Compose

```bash
# Barcha xizmatlarni to'xtatish
docker compose down

# Barcha xizmatlarni to'xtatish va ma'lumotlarni o'chirish
docker compose down -v

# Faqat serverni qayta ishga tushirish
docker compose restart serverpod

# Resurslarni tozalash
docker system prune -a
```

### Serverpod CLI

```bash
# Yangi endpoint yaratish
docker compose exec serverpod dart run serverpod_cli:cli create endpoint

# Ma'lumotlar modeli yaratish
docker compose exec serverpod dart run serverpod_cli:cli create model

# Kodlarni qayta yaratish
docker compose exec serverpod dart run serverpod_cli:cli generate
```

### Ma'lumotlar Bazasi

```bash
# Ma'lumotlar bazasiga ulanish
docker compose exec postgres psql -U postgres -d smart_todos

# Jadvallarni ko'rish
docker compose exec postgres psql -U postgres -d smart_todos -c "\dt"

# Ma'lumotlarni ko'rish
docker compose exec postgres psql -U postgres -d smart_todos -c "SELECT * FROM table_name LIMIT 10;"
```

## 🔐 Xavfsizlik

### Parollar

- Productionda kuchli, noyob parollar ishlatish
- `.env` faylini `.gitignore` ga qo'shish
- Docker secrets ishlatish

### Tarmoq Xavfsizligi

```yaml
services:
  postgres:
    networks:
      - internal
  serverpod:
    networks:
      - internal
      - external

networks:
  internal:
    internal: true
  external:
```

### HTTPS

```yaml
services:
  serverpod:
    environment:
      - HTTPS=true
    volumes:
      - ./ssl:/ssl:ro
```

## 📚 Qo'shimcha Resurslar

- [Serverpod Documentation](https://docs.serverpod.dev)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [pgvector Documentation](https://github.com/pgvector/pgvector)

## 🆘 Yordam

Agar muammoga duch kelsangiz:

1. Loglarni tekshiring: `docker compose logs -f`
2. Xizmatlar holatini tekshiring: `docker compose ps`
3. Docker Desktop da konteynerlarni tekshiring
4. Serverpod Discord yoki GitHub issues ga murojaat qiling

Bu qo'llanma sizga Serverpod serverini to'liq boshqarish uchun kerakli barcha ma'lumotlarni beradi. Muvaffaqiyatlar! 🚀
