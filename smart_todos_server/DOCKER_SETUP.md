# Docker Setup Guide

## Overview

This setup uses Docker Compose to run the complete Serverpod stack with:
- PostgreSQL database (development)
- PostgreSQL database (test)
- Serverpod server (with automatic migrations)
- All configurations managed via `.env` file

## Quick Start

### 1. Set Up Environment Variables

Copy the example file:
```bash
cp .env.example .env
```

Edit `.env` to customize settings (optional - defaults are pre-configured):
```bash
nano .env
```

### 2. Start Everything with One Command

This will build and start all services with automatic database migrations:

```bash
docker compose up -d --build
```

The command will:
- Build the Docker image for the Serverpod server
- Start PostgreSQL databases
- Wait for databases to be ready
- Run all database migrations automatically
- Start the Serverpod server

### 3. Verify Everything is Running

Check the status:
```bash
docker compose ps
```

View server logs:
```bash
docker compose logs -f serverpod
```

View PostgreSQL logs:
```bash
docker compose logs postgres
```

## Configuration

All environment variables are defined in `.env`:

### Server Configuration
- `RUNMODE`: Server mode (production/development/test)
- `SERVERID`: Server identifier
- `LOGGING`: Logging level (normal/verbose/quiet)
- `ROLE`: Server role (monolith/single/worker)

### Database Configuration
- `POSTGRES_USER`: Database user
- `POSTGRES_PASSWORD`: Database password
- `POSTGRES_DB`: Database name
- `POSTGRES_HOST`: Database host (use `postgres` for Docker network)
- `POSTGRES_PORT`: Database port (5432 default)
- `POSTGRES_EXTERNAL_PORT`: Port to expose on host (8090 default)

### Test Database Configuration
- `POSTGRES_TEST_USER`: Test database user
- `POSTGRES_TEST_PASSWORD`: Test database password
- `POSTGRES_TEST_DB`: Test database name
- `POSTGRES_TEST_EXTERNAL_PORT`: Test database exposed port (9090 default)

### Server Ports
- `SERVER_PORT`: Main API port (8080)
- `INSIGHTS_PORT`: Insights port (8081)
- `WEB_PORT`: Web server port (8082)

## Common Commands

### Stop All Services
```bash
docker compose down
```

### Stop and Remove All Data (includes volumes)
```bash
docker compose down -v
```

### Rebuild After Code Changes
```bash
docker compose up -d --build
```

### Run Migrations Manually
```bash
docker compose exec serverpod dart run serverpod_cli:cli migrate --mode production
```

### Access PostgreSQL Shell
```bash
docker compose exec postgres psql -U postgres -d smart_todos
```

### View Server Logs
```bash
docker compose logs -f serverpod
```

### Rebuild Only the Server Image
```bash
docker compose build --no-cache serverpod
```

## Development Workflow

1. **Local Development**: Edit files in your editor
2. **Rebuild**: Run `docker compose up -d --build` after code changes
3. **View Logs**: Use `docker compose logs -f serverpod` to monitor
4. **Debug**: Access logs and database as needed

## Database Migrations

Migrations run automatically when the server starts:
1. Script waits for PostgreSQL to be healthy
2. Runs: `dart run serverpod_cli:cli migrate --mode production`
3. Starts the server once migrations complete

## Troubleshooting

### Migrations not running?
- Check database health: `docker compose logs postgres`
- Verify database credentials in `.env`
- Check migration files in `migrations/` directory

### Port conflicts?
- Change ports in `.env`
- Or stop other services on those ports

### Database connection errors?
- Ensure database is healthy: `docker compose ps`
- Check PostgreSQL logs: `docker compose logs postgres`
- Verify `POSTGRES_HOST` is set to `postgres` (not localhost)

### Server won't start?
- Check logs: `docker compose logs serverpod`
- Verify all environment variables are set
- Ensure migrations completed successfully

## Production Deployment

For production deployment, modify `.env`:

```env
RUNMODE=production
LOGGING=normal
POSTGRES_PASSWORD=YOUR_SECURE_PASSWORD_HERE
```

Then run:
```bash
docker compose up -d --build
```

The server will auto-start and auto-restart on failures.
