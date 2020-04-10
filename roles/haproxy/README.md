# haproxy

A brief description of the role goes here.

## Requirements

Any pre-requisites that may not be covered by Ansible itself or the role should be mentioned here. For instance, if the role uses the EC2 module, it may be a good idea to mention in this section that the boto package is required.

## Role Variables

| Variable                        | Type        | Description                                                       |
| ------------------------------- | ----------- | ----------------------------------------------------------------- |
| load_balancers                  | Array<Dict> | list of TCP Layer 4 load balancers to deploy                      |
| load_balancers[i].name          | String      | name of load balancer passed to haproxy frontend and backend name |
| load_balancers[i].listener_port | Number      | port load balancer will listen on for incomming traffic           |
| load_balancers[i].target_port   | Number      | port load balancer will proxy traffic to                          |
| load_balancers[i].target_group  | String      | the exact name of the group in ansible inventory to target        |

A description of the settable variables for this role should go here, including any variables that are in defaults/main.yml, vars/main.yml, and any variables that can/should be set via parameters to the role. Any variables that are read from other roles and/or the global scope (ie. hostvars, group vars, etc.) should be mentioned here as well.

## Dependencies

A list of other roles hosted on Galaxy should go here, plus any details in regards to parameters that may need to be set for other roles, or variables that are used from other roles.

## Example Playbook

```ini
; Example Ansible Inventory

[kubernetes: children]
kubernetes_load_balancers
kubernetes_master_nodes
kubernetes_worker_nodes

[kubernetes_load_balancers]
haproxy-0
haproxy-1

[kubernetes_master_nodes]
master-0
master-1
master-2

[kubernetes_worker_nodes]
worker-0
worker-1
worker-2

```

```yaml
# Exmaple playbook
- hosts: kubernetes_load_balancers
  roles:
    - role: haproxy
      vars:
        load_balancers:
          - name: kube_apiserver
            listener_port: 6443
            target_port: 6443
            target_group: "kubernetes_master_nodes"
          - name: ingress_controller_http
            listener_port: 80
            target_port: 30080
            target_group: "kubernetes_worker_nodes"
          - name: ingress_controller_https
            listener_port: 443
            target_port: 30443
            target_group: "kubernetes_worker_nodes"
```

## License

MIT

## Author Information

Gurkamal Singh
Sr. DevOps Consultant
Red Hat
info@gurkamal.io
