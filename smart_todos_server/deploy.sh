#!/bin/bash

# Smart Todos Server Deployment Script
# Bu skript serverni to'liq deploy qilish uchun ishlatiladi

set -e

echo "🚀 Smart Todos Server Deployment Script"
echo "========================================"

# Ranglar
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Funksiyalar
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Kerakli katalogni tekshirish
if [ ! -f "docker-compose.yaml" ]; then
    log_error "docker-compose.yaml fayli topilmadi. smart_todos_server katalogida ekanligingizni tekshiring."
    exit 1
fi

# .env faylini tekshirish
if [ ! -f ".env" ]; then
    log_warning ".env fayli topilmadi. .env.example dan nusxalanadi..."
    if [ -f ".env.example" ]; then
        cp .env.example .env
        log_success ".env fayli yaratildi"
    else
        log_error ".env.example fayli topilmadi"
        exit 1
    fi
fi

log_info "Docker Compose versiyasini tekshirish..."
docker compose version

log_info "Eski konteynerlarni to'xtatish..."
docker compose down || true

log_info "Docker imagelarni qurish va xizmatlarni ishga tushirish..."
docker compose up -d --build

log_info "Xizmatlar ishga tushishini kutish..."
sleep 10

log_info "Xizmatlar holatini tekshirish..."
docker compose ps

log_info "PostgreSQL sog'liq tekshiruvi..."
if docker compose exec -T postgres pg_isready -U postgres -d smart_todos >/dev/null 2>&1; then
    log_success "PostgreSQL ishlamoqda"
else
    log_error "PostgreSQL ishlamayapti"
    exit 1
fi

log_info "Serverpod server holatini tekshirish..."
if docker compose exec -T serverpod curl -f http://localhost:8080/health >/dev/null 2>&1; then
    log_success "Serverpod server ishlamoqda"
else
    log_warning "Serverpod server hali ishga tushmagan bo'lishi mumkin"
fi

log_success "🎉 Deployment muvaffaqiyatli yakunlandi!"
echo ""
echo "📊 Xizmatlar:"
echo "   - Serverpod API: http://localhost:8080"
echo "   - Serverpod Insights: http://localhost:8081"
echo "   - PostgreSQL: localhost:8090"
echo ""
echo "📋 Foydali kommandalar:"
echo "   - Loglarni ko'rish: docker compose logs -f"
echo "   - To'xtatish: docker compose down"
echo "   - Qayta ishga tushirish: docker compose restart"
echo ""
echo "📖 Qo'llanma uchun: cat README.md"