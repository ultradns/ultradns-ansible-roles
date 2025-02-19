# ddns_client

An Ansible role for setting up ephemeral DNS records using UltraDNS and Docker.

## Requirements

* [UltraDNS](https://portal.ultradns.com) credentials
* [Docker](https://docs.docker.com/engine/install/)

## Variables

* `xrr_base_dir` _(string)_ – The directory where the Docker setup files will be stored.
* `records` _(list)_ – A list of record values to apply to be created.
  - `zone` _(string)_ - The name of the zone.
  - `name` _(string)_ – The record hostname.
  - `type` _(string)_ – The record type (e.g., A, TXT, MX).
  - `data` _(string)_ – The record data.
  - `ttl` _(int)_ – The time-to-live (TTL) value.
* `expire_in` _(string)_ – The timeframe after which the record will expire.
* `vault_file` _(string)_ - Path to your vault file.
* `vault_pass_file` _(string)_ – Path to your vault password file.

## Dependencies

* [UltraDNS Ansible Modules](https://galaxy.ansible.com/ui/repo/published/ultradns/ultradns/)
* Python's `requests` module
* _(Recommended)_ [Jeff Geerling's Docker role](https://galaxy.ansible.com/ui/standalone/roles/geerlingguy/docker/)

## Example Playbook

```yaml
---
# This role will handle the setup of Docker on the host machine
- name: Run Docker Setup On Host
  hosts: localhost
  gather_facts: yes
  become: yes
  roles:
    - role: geerlingguy.docker
      vars:
        docker_edition: 'ce'
        docker_service_state: started
        docker_service_enabled: true
        docker_packages:
          - "docker-{{ docker_edition }}"
          - "docker-{{ docker_edition }}-cli"
          - "docker-{{ docker_edition }}-rootless-extras"
        docker_packages_state: present
        docker_install_compose_plugin: true
        docker_compose_package: docker-compose-plugin
        docker_compose_package_state: present
        docker_users:
          - "{{ ansible_user }}"

# This role will handle the setup of the XRR client
- name: Create Expiring Resource Records
  hosts: localhost
  gather_facts: no
  vars_files:
    - ../vars/ultradns.yml
  roles:
    - role: ultradns.dnsops.create_xrr
      vars:
        xrr_base_dir: "~/xrr_records" # Directory to create for Docker files
        records: # List of records to add
          - name: "temp1"
            type: "TXT"
            data: "Temporary record"
            ttl: 300
            zone: "example-0001.xyz"
          - name: "temp2"
            type: "A"
            data: "192.168.1.100"
            ttl: 600
            zone: "example-0001.xyz"
        expire_in: "10m" # Expire time in minutes (m), hours (h), days (d), weeks (w), or months (M)
        vault_file: "../vars/ultradns.yml" # Path to the vault file
        vault_pass_file: "../vars/.ultradns-pass" # Path to the vault password file
```

## License

GPL-3.0-only