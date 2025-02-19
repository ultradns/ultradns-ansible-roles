# ddns_client

An Ansible role for setting up a DDNS client using UltraDNS and Docker.

## Requirements

* [UltraDNS](https://portal.ultradns.com) credentials
* [Docker](https://docs.docker.com/engine/install/)

## Variables

* `ddns_base_dir` _(string)_ – The directory where the Docker setup files will be stored.
* `zone` _(string)_ – The zone where the record will be managed.
* `host` _(string)_ – The record hostname (default is `ddns`).
* `vault_file` _(string)_ - Path to your vault file.
* `vault_pass_file` _(string)_ – Path to your vault password file.
* `state` _(string)_ - Either `present` (create) or `absent` (remove).

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

# This role will handle the setup of the DDNS client
- name: Deploy DDNS Client
  hosts: localhost
  gather_facts: no
  vars_files:
    - ../vars/ultradns.yml
  roles:
    - role: ultradns.dnsops.ddns_client
      vars:
        ddns_base_dir: "~/ddns_client" # Directory to create
        zone: "example-0001.xyz" # Zone to update
        host: "ddns" # Hostname to update
        # Default is every minute
        #cron_expression: "*/5 * * * *"
        vault_file: "../vars/ultradns.yml" # Path to the vault file
        vault_pass_file: "../vars/.ultradns-pass" # Path to the vault password file
        state: present
```

## License

GPL-3.0-only