# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Vagrant Host Specs:
  # Fedora 31 & libvirt provider
  # Intel® Core™ i7-8850H CPU @ 2.60GHz × 12 
  # 64GB RAM

  # Private Network Subnet for all Nodes
  SUBNET_PREFIX = "10.0.0" # 10.0.0.0/24 private network
  VIRTUAL_NETWORK_NAME = "kubernetes"

  # HAProxy Node Specs
  LOAD_BALANCER_COUNT = 2 # active/passive HA with keepalived
  LOAD_BALANCER_MEMORY = 2048
  LOAD_BALANCER_CPUS = 1

  # Kubernetes Master Node Specs
  MASTER_NODE_COUNT = 3 # should an be odd number for etcd quorum
  MASTER_NODE_MEMORY = 4096 # atleast 2048
  MASTER_NODE_CPUS = 2 # atleast 2

  # Kubernetes Worker Node Specs
  WORKER_NODE_COUNT = 3 
  WORKER_NODE_MEMORY = 4096 # atleast 1024
  WORKER_NODE_CPUS = 1 # atleast 1

  # HAProxy Nodes (Active/Standby High Availability)
  (0...(LOAD_BALANCER_COUNT)).each do |i|
    config.vm.define "haproxy-#{i}" do |haproxy_i|
      haproxy_i.vm.box = "centos/7"
      haproxy_i.vm.box_version = "1905.1"
      haproxy_i.vm.hostname = "haproxy-#{i}"
      haproxy_i.vm.network "private_network",
        ip: "#{SUBNET_PREFIX}.#{50 + i}",
        libvirt__network_name: VIRTUAL_NETWORK_NAME,
        virtualbox__intnet: VIRTUAL_NETWORK_NAME
      haproxy_i.vm.provider "libvirt" do |libvirt|
        libvirt.qemu_use_session = false
        libvirt.memory = LOAD_BALANCER_MEMORY
        libvirt.cpus = LOAD_BALANCER_CPUS
      end
      haproxy_i.vm.provider "virtualbox" do |virtualbox|
        virtualbox.memory = LOAD_BALANCER_MEMORY 
        virtualbox.cpus = LOAD_BALANCER_CPUS
      end
      haproxy_i.vm.synced_folder ".", "/vagrant", disabled: true
    end
  end

  # Kubernetes Master Nodes
  (0...(MASTER_NODE_COUNT)).each do |i|
    config.vm.define "master-#{i}" do |master_i|
      master_i.vm.box = "centos/7"
      master_i.vm.box_version = "1905.1"
      master_i.vm.hostname = "master-#{i}"
      master_i.vm.network "private_network", 
        ip: "#{SUBNET_PREFIX}.#{100 + i}",
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
      master_i.vm.synced_folder ".", "/vagrant", disabled: true
    end
  end

  # Kubernetes Worker Nodes
  (0...(WORKER_NODE_COUNT)).each do |i|
    config.vm.define "worker-#{i}" do |worker_i|
      worker_i.vm.box = "centos/7"
      worker_i.vm.box_version = "1905.1"
      worker_i.vm.hostname = "worker-#{i}"
      worker_i.vm.network "private_network", 
        ip: "#{SUBNET_PREFIX}.#{200 + i}",
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
      worker_i.vm.synced_folder ".", "/vagrant", disabled: true
    end
  end

end
