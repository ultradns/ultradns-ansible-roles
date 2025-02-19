#!/bin/bash

# Ensure environment variables are set
if [ -z "$ZONE" ] || [ -z "$HOST" ]; then
    echo "ERROR: Missing environment variables. Set ZONE and HOST in docker-compose.yml."
    exit 1
fi

# Default CRON expression if not set
CRON_EXPRESSION=${CRON_EXPRESSION:-"* * * * *"}

echo "Using Zone: $ZONE, Host: $HOST"
echo "Using Cron Schedule: $CRON_EXPRESSION"

# Create Ansible inventory
echo -e "[test_servers]\nlocalhost ansible_connection=local" > /ansible/inventory

# Generate the Ansible playbook dynamically
cat > /ansible/ddns-client.yml <<EOF
- name: Update Dynamic DNS Record
  hosts: localhost
  gather_facts: false
  vars_files:
    - /ansible/ultra_vault.yml
  tasks:
    - name: Get current public IP
      uri:
        url: http://icanhazip.com
        return_content: yes
      register: public_ip

    - name: Sanitize public IP
      set_fact:
        sanitized_ip: "{{ public_ip.content | trim }}"

    - name: Update A record with current IP (only if changed)
      ultradns.ultradns.record:
        zone: $ZONE
        name: $HOST
        type: A
        data: "{{ sanitized_ip }}"
        ttl: 300
        solo: true
        state: present
        provider: "{{ ultra_provider }}"
EOF

echo "Ansible playbook generated at /ansible/ddns-client.yml"

# Setup cron job with configurable frequency and direct output to stdout/stderr
echo "$CRON_EXPRESSION ansible-playbook --vault-password-file /ansible/.ansible-vault-pass -i /ansible/inventory /ansible/ddns-client.yml >> /proc/1/fd/1 2>&1" > /etc/cron.d/ansible-ddns
chmod 0644 /etc/cron.d/ansible-ddns
crontab /etc/cron.d/ansible-ddns

echo "Cron job set up with schedule: $CRON_EXPRESSION. Starting cron..."

# Start cron in the foreground and pipe output to Docker logs
cron -f
