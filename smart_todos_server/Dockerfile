# Build stage
FROM dart:3.8.0 AS build
WORKDIR /app
COPY . .

# Install dependencies and compile the server executable
RUN dart pub get
RUN dart compile exe bin/main.dart -o bin/server

# Final stage
FROM alpine:latest

# Install PostgreSQL client for migration checks
RUN apk add --no-cache postgresql-client bash

# Set working directory
WORKDIR /app

# Environment variables with defaults
ENV RUNMODE=production
ENV SERVERID=default
ENV LOGGING=normal
ENV ROLE=monolith

ENV POSTGRES_HOST=pgsql
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=qaz123++
ENV POSTGRES_DB=smart_todos
ENV POSTGRES_PORT=5432

# Copy runtime dependencies
COPY --from=build /runtime/ /

# Copy compiled server executable
COPY --from=build /app/bin/server /app/server

# Copy configuration files and resources
COPY --from=build /app/config/ /app/config/
COPY --from=build /app/web/ /app/web/
COPY --from=build /app/migrations/ /app/migrations/
COPY --from=build /app/pubspec.* /app/

# Copy dart SDK tools for migrations (needed for migration execution)
COPY --from=build /usr/local/bin/dart /usr/local/bin/dart
COPY --from=build /usr/local/bin/pub /usr/local/bin/pub

# This file is required to enable the endpoint log filter in Insights.
COPY --from=build /app/lib/src/generated/protocol.yaml /app/lib/src/generated/protocol.yaml

# Copy and set permissions for entrypoint script
COPY docker-entrypoint.sh /app/docker-entrypoint.sh
RUN chmod +x /app/docker-entrypoint.sh

# Expose ports
EXPOSE 8080
EXPOSE 8081
EXPOSE 8082

# Define the entrypoint command
ENTRYPOINT ["/app/docker-entrypoint.sh"]
