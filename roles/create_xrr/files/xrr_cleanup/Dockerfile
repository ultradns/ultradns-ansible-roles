FROM python:3.11-slim

# Install system utilities
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    cron \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /cleanup

# Copy entrypoint script
COPY entrypoint.sh /cleanup/entrypoint.sh
RUN chmod +x /cleanup/entrypoint.sh

# Start cleanup script
CMD ["/cleanup/entrypoint.sh"]
