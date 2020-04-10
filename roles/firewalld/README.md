# firewalld

Provisions firewalld rules for public and internal network zones for a CentOS based Kubernetes cluster.

## Requirements

CentOS/RHEL/Fedora

## Role Variables

| Variable            | Type          | Description                                          |
| ------------------- | ------------- | ---------------------------------------------------- |
| public_interfaces   | Array<String> | network interfaces to bind public zone to            |
| public_ports        | Array<String> | ports to open in public zone                         |
| public_sources      | Array<String> | source IPs to allow into public zone                 |
| public_rich_rules   | Array<String> | rich-rules for public zone (specific to firewalld)   |
| -----------------   | ------------- | --------------------------------------------------   |
| internal_interfaces | Array<String> | network interfaces to bind internal zone to          |
| internal_ports      | Array<String> | ports to open in internal zone                       |
| internal_sources    | Array<String> | source IPs to allow into internal zone               |
| internal_rich_rules | Array<String> | rich-rules for internal zone (specific to firewalld) |

## Dependencies

None

## Example Playbook

```yaml
- hosts: servers
  roles:
    # haproxy example for keepalived HA loadbalancer setup for kubernetes
    - role: firewalld
      vars:
        public_interfaces:
          - eth0
        public_ports:
          - 80/tcp
          - 443/udp
        public_sources:
          - 0.0.0.0/0
        internal_interfaces:
          - eth1
        internal_ports:
          - 6443/tcp
        internal_sources:
          - 10.0.0.0/24
        internal_rich_rules:
          - rule protocol value="vrrp" accept

    # kubernetes master node
    - role: firewalld
      vars:
        internal_interfaces:
          - eth1
        internal_ports:
          - 6443/tcp # Kubernetes API server
          - 2379-2380/tcp # etcd server client API
          - 10250/tcp # Kubelet API
          - 10251/tcp # kube-scheduler
          - 10252/tcp # kube-controller-manager
        internal_sources:
          - 10.0.0.0/24 # cluster CIDR block

    # kubernetes worker node
    - role: firewalld
      vars:
        public_interfaces:
          - eth0
        public_orts:
          - 30000-32767/tcp # NodePorts
        public_sources:
          - 0.0.0.0/0
        internal_interfaces:
          - eth1
        internal_ports:
          - 10250/tcp # Kubelet API
        internal_sources:
          - 10.0.0.0/24 # cluster CIDR block
```

## License

MIT

## Author Information

Gurkamal Singh
Sr. DevOps Consultant @ Red Hat
info@gurkamal.io
