# ultradns-ansible-roles

[A collection of Ansible roles](https://galaxy.ansible.com/ui/repo/published/ultradns/dnsops/) for managing UltraDNS zones and records efficiently. Designed for **automation, scalability, and seamless integration** into DevOps workflows.

## Dependencies

These roles depend on the [UltraDNS Ansible collection](https://galaxy.ansible.com/ui/repo/published/ultradns/ultradns/), which includes **plugins** that extend Ansible’s core functionality to integrate with the UltraDNS API.

While **plugins** serve as extensions to Ansible's core functionality, **collections** can include **both plugins and roles**. In this case, the UltraDNS collection provides plugins, while this repository provides structured roles for automating DNS workflows.

The only other **required** dependency is Python's `requests` module. However, if you plan to install Docker using Ansible, we recommend [Jeff Geerling's standalone Docker role](https://galaxy.ansible.com/ui/standalone/roles/geerlingguy/docker/).

## Setup

Pull the role directly from Ansible Galaxy:

```bash
ansible-galaxy collection install ultradns.dnsops
```

Alternatively, clone this repository, then package and install the collection.

```bash
git clone https://github.com/ultradns/ultradns-ansible-roles
ansible-galaxy collection build
ansible-galaxy collection install ultradns-dnsops-x.x.x.tar.gz
```

## Usage

* [Creating a DDNS Client](roles/ddns_client/README.md) - Installs a Docker container on your target host to synchronize the host's public IP address with an UltraDNS A record.
* [Bulk Record Updates](roles/bulk_record_update/README.md) - Automates the creation and management of DNS records across multiple UltraDNS zones.
* [Ephemeral DSN Records (XRR)](roles/create_xrr/README.md) - Allows the creation of expiring DNS records that automatically delete after a specified period.

## License

[GPL-3.0-only](LICENSE)