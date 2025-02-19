# bulk_record_update

An Ansible role for bulk updating DNS records across multiple zones using the UltraDNS API.

## Requirements

* [UltraDNS](https://portal.ultradns.com) credentials

## Variables

* `zones` _(list)_ – A list of zones to update.
* `records` _(list)_ – A list of record values to apply to each zone.
  - `name` _(string)_ – The record hostname.
  - `type` _(string)_ – The record type (e.g., A, TXT, MX).
  - `data` _(string)_ – The record data.
  - `ttl` _(int)_ – The time-to-live (TTL) value.
  - `solo` _(boolean)_ **(optional)** – Whether the record should replace (`true`) or be added to an existing `rrset` (`false`). Defaults to `false`.
* `create_zones` _(boolean)_ – Whether to create missing zones before applying records. Defaults to `false`.
* `account` _(string)_ – The UltraDNS account name, **required only** when `create_zones` is `true`.

## Dependencies

* [UltraDNS Ansible Modules](https://galaxy.ansible.com/ui/repo/published/ultradns/ultradns/)
* Python's `requests` module

## Example Playbook

```yaml
---
# Provision multiple DNS records in UltraDNS
- name: Bulk Update DNS Records
  hosts: localhost
  gather_facts: no
  vars_files:
    - ../vars/ultradns.yml
  roles:
    - role: ultradns.dnsops.bulk_record_update
      vars:
        create_zones: true # Create zones if they do not exist
        account: your_account_name # Account name
        zones: # List of zones to create
          - example-0002.xyz
          - example-0003.xyz
          - example-0004.xyz
        records: # List of records to add
          - name: test1 # Record name
            type: TXT # Record type
            data: "hello world" # Record data
            ttl: 300 # Record TTL
          - name: test2
            type: A
            solo: true # Only one record of this type (alternatively, it will create an RD pool)
            data: 192.168.1.1
            ttl: 900
```

## License

GPL-3.0-only