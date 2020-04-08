# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Vagrant Host Specs:
  # Fedora 31 & libvirt provider
  # Intel® Core™ i7-8850H CPU @ 2.60GHz × 12 
  # 64GB RAM (adjust memory allocations below as needed)


  ################################################################################
  ## Configuration
  ################################################################################
  ## Vagrant Provider Configuration
  PROVIDER = "libvirt"
  # PROVIDER = "virtualbox"

  ## Node Configuration
  VAGRANT_BOX         = "centos/7"
  VAGRANT_BOX_VERSION = "1905.1"
  VAGRANT_FILE_PATH = "/home/vagrant/.vagrant.import" # location to copy ./.vagrant

  ## Private Network Subnet for all Nodes
  SUBNET_PREFIX        = "10.0.0" # 10.0.0.0/24 private network
  VIRTUAL_NETWORK_NAME = "kubernetes"

  ## HAProxy Load Balancers
  HAPROXY_NODE_HOSTNAME_PREFIX = 'haproxy-'
  HAPROXY_NODE_SUBNET_SUFFIX   = 50 # 10.0.0.50 series
  HAPROXY_NODE_COUNT           = 2 # active/passive HA - keepalived VIP @ 10.0.0.10
  HAPROXY_NODE_MEMORY          = 2048 # atleast 1024
  HAPROXY_NODE_CPUS            = 1 # atleast 1

  ## Kubernetes Masters
  MASTER_NODE_HOSTNAME_PREFIX  = 'master-'
  MASTER_NODE_SUBNET_SUFFIX    = 100 # 10.0.0.100 series
  MASTER_NODE_COUNT            = 3 # should an be odd number for etcd quorum
  MASTER_NODE_MEMORY           = 4096 # atleast 1024
  MASTER_NODE_CPUS             = 2 # atleast 1

  ## Kubernetes Workers
  WORKER_NODE_HOSTNAME_PREFIX  = 'worker-'
  WORKER_NODE_SUBNET_SUFFIX    = 200 # 10.0.0.200 series
  WORKER_NODE_COUNT            = 3
  WORKER_NODE_MEMORY           = 4096 # atleast 1024
  WORKER_NODE_CPUS             = 2 # atleast 1


  ################################################################################
  # HAProxy Load Balancers (Active/Standby High Availability)
  ################################################################################
  (0...(HAPROXY_NODE_COUNT)).each do |i|
    config.vm.define "#{HAPROXY_NODE_HOSTNAME_PREFIX}#{i}" do |haproxy_i|
      haproxy_i.vm.box = VAGRANT_BOX
      haproxy_i.vm.box_version = VAGRANT_BOX_VERSION
      haproxy_i.vm.hostname = "#{HAPROXY_NODE_HOSTNAME_PREFIX}#{i}"
      haproxy_i.vm.network "private_network",
        ip: "#{SUBNET_PREFIX}.#{HAPROXY_NODE_SUBNET_SUFFIX + i}",
        libvirt__network_name: VIRTUAL_NETWORK_NAME,
        virtualbox__intnet: VIRTUAL_NETWORK_NAME
      haproxy_i.vm.provider "libvirt" do |libvirt|
        libvirt.qemu_use_session = false
        libvirt.memory = HAPROXY_NODE_MEMORY
        libvirt.cpus = HAPROXY_NODE_CPUS
      end
      haproxy_i.vm.provider "virtualbox" do |virtualbox|
        virtualbox.memory = HAPROXY_NODE_MEMORY 
        virtualbox.cpus = HAPROXY_NODE_CPUS
      end
    end
  end


  ################################################################################
  # Kubernetes Master Nodes
  ################################################################################
  (0...(MASTER_NODE_COUNT)).each do |i|
    config.vm.define "#{MASTER_NODE_HOSTNAME_PREFIX}#{i}" do |master_i|
      master_i.vm.box = VAGRANT_BOX
      master_i.vm.box_version = VAGRANT_BOX_VERSION
      master_i.vm.hostname = "#{MASTER_NODE_HOSTNAME_PREFIX}#{i}"
      master_i.vm.network "private_network", 
        ip: "#{SUBNET_PREFIX}.#{MASTER_NODE_SUBNET_SUFFIX + i}",
        libvirt__network_name: VIRTUAL_NETWORK_NAME,
        virtualbox__intnet: VIRTUAL_NETWORK_NAME
      master_i.vm.provider "libvirt" do |libvirt|
        libvirt.qemu_use_session = false
        libvirt.memory = MASTER_NODE_MEMORY
        libvirt.cpus = MASTER_NODE_CPUS
      end
      master_i.vm.provider "virtualbox" do |virtualbox|
        virtualbox.memory = MASTER_NODE_MEMORY
        virtualbox.cpus = MASTER_NODE_CPUS
      end
    end
  end


  ################################################################################
  # Kubernetes Worker Nodes
  ################################################################################
  (0...(WORKER_NODE_COUNT)).each do |i|
    config.vm.define "#{WORKER_NODE_HOSTNAME_PREFIX}#{i}" do |worker_i|
      worker_i.vm.box = VAGRANT_BOX
      worker_i.vm.box_version = VAGRANT_BOX_VERSION
      worker_i.vm.hostname = "#{WORKER_NODE_HOSTNAME_PREFIX}#{i}"
      worker_i.vm.network "private_network", 
        ip: "#{SUBNET_PREFIX}.#{WORKER_NODE_SUBNET_SUFFIX + i}",
        libvirt__network_name: VIRTUAL_NETWORK_NAME,
        virtualbox__intnet: VIRTUAL_NETWORK_NAME
      worker_i.vm.provider "libvirt" do |libvirt|
        libvirt.qemu_use_session = false
        libvirt.memory = WORKER_NODE_MEMORY
        libvirt.cpus = WORKER_NODE_CPUS
      end
      worker_i.vm.provider "virtualbox" do |virtualbox|
        virtualbox.memory = WORKER_NODE_MEMORY
        virtualbox.cpus = WORKER_NODE_CPUS
      end
    end
  end


  ################################################################################
  # DNS Resolution and SSH Access - Note: Vagrant runs scripts as root
  ################################################################################
  $bootstrap_dns_and_ssh= <<-'SCRIPT'
    #!/bin/bash
    PROVIDER="${1}";            VAGRANT_FILE_PATH="${2}";             SUBNET_PREFIX="${3}";
    HAPROXY_NODE_COUNT="${4}";  HAPROXY_NODE_HOSTNAME_PREFIX="${5}";  HAPROXY_NODE_SUBNET_SUFFIX="${6}";
    MASTER_NODE_COUNT="${7}";   MASTER_NODE_HOSTNAME_PREFIX="${8}";   MASTER_NODE_SUBNET_SUFFIX="${9}";
    WORKER_NODE_COUNT="${10}";  WORKER_NODE_HOSTNAME_PREFIX="${11}";  WORKER_NODE_SUBNET_SUFFIX="${12}";

    # generate ssh keypair
    runuser -l vagrant -c "ssh-keygen -q -t rsa -N '' -f /home/vagrant/.ssh/id_rsa 2>/dev/null <<< y >/dev/null"
    readonly PUB_KEY="$(cat /home/vagrant/.ssh/id_rsa.pub)"

    # args: <count> <hostname_prefix> <subnet_suffix>
    bootstrap_node_type() {
      local node_count="${1}"
      local hostname_prefix="${2}"
      local subnet_suffix="${3}"

      local hostname_i
      local ip_address_i
      local vagrant_ssh_key
      local vagrant_key_exists

      for ((i = 0 ; i < node_count ; i++)); do
        hostname_i="${hostname_prefix}${i}"
        ip_address_i="${SUBNET_PREFIX}.$((subnet_suffix + i))"
        vagrant_ssh_key="${VAGRANT_FILE_PATH}/machines/${hostname_i}/${PROVIDER}/private_key"
        vagrant_key_exists="false"

        while [[ "${vagrant_key_exists}" == "false" ]]; do
          if [[ -f "${vagrant_ssh_key}" ]]; then
            vagrant_key_exists="true"
          fi
        done

        echo "${ip_address_i} ${hostname_i}" >> "/etc/hosts"
        ssh \
          -o "StrictHostKeyChecking=no" \
          -i "${vagrant_ssh_key}" \
          "vagrant@${ip_address_i}" \
          "echo ${PUB_KEY} >> /home/vagrant/.ssh/authorized_keys"
      done
    }

    bootstrap_node_type "${HAPROXY_NODE_COUNT}" "${HAPROXY_NODE_HOSTNAME_PREFIX}" "${HAPROXY_NODE_SUBNET_SUFFIX}"
    bootstrap_node_type "${MASTER_NODE_COUNT}"  "${MASTER_NODE_HOSTNAME_PREFIX}"  "${MASTER_NODE_SUBNET_SUFFIX}"
    bootstrap_node_type "${WORKER_NODE_COUNT}"  "${WORKER_NODE_HOSTNAME_PREFIX}"  "${WORKER_NODE_SUBNET_SUFFIX}"
    rm -rf "${VAGRANT_FILE_PATH}"
  SCRIPT

  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.provision "file", source: ".vagrant", destination: VAGRANT_FILE_PATH
  config.vm.provision "bootstrap_dns_and_ssh", type: "shell" do |s|
    s.inline = $bootstrap_dns_and_ssh
    s.args = [
      PROVIDER,           VAGRANT_FILE_PATH,            SUBNET_PREFIX,
      HAPROXY_NODE_COUNT, HAPROXY_NODE_HOSTNAME_PREFIX, HAPROXY_NODE_SUBNET_SUFFIX,
      MASTER_NODE_COUNT,  MASTER_NODE_HOSTNAME_PREFIX,  MASTER_NODE_SUBNET_SUFFIX,
      WORKER_NODE_COUNT,  WORKER_NODE_HOSTNAME_PREFIX,  WORKER_NODE_SUBNET_SUFFIX
    ]
  end
end