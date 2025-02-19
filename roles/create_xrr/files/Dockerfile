# Use Python image to avoid package conflicts
FROM python:3.11-slim

# Install necessary system packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ansible \
    cron \
    curl \
    jq && \
    rm -rf /var/lib/apt/lists/*

# Install required Python packages
RUN pip install --no-cache-dir requests ansible

# Install the UltraDNS Ansible collection
RUN ansible-galaxy collection install ultradns.ultradns

# Set working directory
WORKDIR /ansible

# Copy entrypoint script
COPY entrypoint.sh /ansible/entrypoint.sh
RUN chmod +x /ansible/entrypoint.sh

# Copy UltraDNS vault file and vault password file
COPY ultra_vault.yml /ansible/ultra_vault.yml
COPY .ansible-vault-pass /ansible/.ansible-vault-pass

# Start the entrypoint script
CMD ["/ansible/entrypoint.sh"]
