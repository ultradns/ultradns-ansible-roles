#!/bin/bash

echo "Expiring record will be removed when timestamp in /expiration_time.json is reached..."

while true; do
    current_time=$(date +%s)
    
    # Read the expiration timestamp from JSON file
    expire_time=$(jq -r '.timestamp' /expiration_time.json)

    # If expiration time is in the past, delete records
    if [[ $current_time -ge $expire_time ]]; then
        echo "Expiration time reached. Removing record..."
        
        # Generate Ansible playbook to delete the record
        cat > /ansible/delete_records.yml <<EOF
- name: Remove Expired Resource Records
  hosts: localhost
  gather_facts: false
  vars_files:
    - /ansible/ultra_vault.yml
  tasks:
    - name: Delete each record
      ultradns.ultradns.record:
        zone: ${ZONE}
        name: "{{ item.name }}"
        type: "{{ item.type }}"
        state: absent
        provider: "{{ ultra_provider }}"
      loop: $(echo "${RECORDS}" | jq -c '.')
EOF

        # Run the playbook
        ansible-playbook --vault-password-file /ansible/.ansible-vault-pass /ansible/delete_records.yml

        echo "Record removed. Container will now exit."
        exit 0
    fi

    sleep 60
done
