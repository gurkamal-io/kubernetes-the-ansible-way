# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Vagrant Host Specs:
  # Fedora 31 & libvirt provider
  # Intel® Core™ i7-8850H CPU @ 2.60GHz × 12 
  # 64GB RAM

  # Node Configuration
  VAGRANT_BOX = "generic/ubuntu1804"
  VAGRANT_BOX_VERSION = "2.0.6"

  # Private Network Subnet for all Nodes
  SUBNET_PREFIX = "10.240.0" # 10.240.0.0/24 private network
  VIRTUAL_NETWORK_NAME = "kubernetes"

  # Kubernetes Controller Node Specs
  CONTROLLER_NODE_COUNT = 3 # should an be odd number for etcd quorum
  CONTROLLER_NODE_MEMORY = 4096 # atleast 2048
  CONTROLLER_NODE_CPUS = 2 # atleast 2

  # Kubernetes Worker Node Specs
  WORKER_NODE_COUNT = 3
  WORKER_NODE_MEMORY = 4096 # atleast 1024
  WORKER_NODE_CPUS = 1 # atleast 1

  # HAProxy Node Specs
  LOAD_BALANCER_COUNT = 1 # active/passive HA with keepalived
  LOAD_BALANCER_MEMORY = 2048
  LOAD_BALANCER_CPUS = 1

  # Kubernetes Controller Nodes
  (0...(CONTROLLER_NODE_COUNT)).each do |i|
    config.vm.define "controller-#{i}" do |controller_i|
      controller_i.vm.box = VAGRANT_BOX
      controller_i.vm.box_version = VAGRANT_BOX_VERSION
      controller_i.vm.hostname = "controller-#{i}"
      controller_i.vm.network "private_network", 
        ip: "#{SUBNET_PREFIX}.#{10 + i}",
        libvirt__network_name: VIRTUAL_NETWORK_NAME,
        virtualbox__intnet: VIRTUAL_NETWORK_NAME
      controller_i.vm.provider "libvirt" do |libvirt|
        libvirt.qemu_use_session = false
        libvirt.memory = CONTROLLER_NODE_MEMORY
        libvirt.cpus = CONTROLLER_NODE_CPUS
      end
      controller_i.vm.provider "virtualbox" do |virtualbox|
        virtualbox.memory = CONTROLLER_NODE_MEMORY
        virtualbox.cpus = CONTROLLER_NODE_CPUS
      end
      controller_i.vm.synced_folder ".", "/vagrant", disabled: true
    end
  end

  # Kubernetes Worker Nodes
  (0...(WORKER_NODE_COUNT)).each do |i|
    config.vm.define "worker#-{i}" do |worker_i|
      worker_i.vm.box = VAGRANT_BOX
      worker_i.vm.box_version = VAGRANT_BOX_VERSION
      worker_i.vm.hostname = "worker-#{i}"
      worker_i.vm.network "private_network", 
        ip: "#{SUBNET_PREFIX}.#{20 + i}",
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

  # HAProxy Nodes (Active/Standby High Availability)
  (0...(LOAD_BALANCER_COUNT)).each do |i|
    config.vm.define "haproxy#-{i}" do |haproxy_i|
      haproxy_i.vm.box = VAGRANT_BOX
      haproxy_i.vm.box_version = VAGRANT_BOX_VERSION
      haproxy_i.vm.hostname = "haproxy-#{i}"
      haproxy_i.vm.network "private_network",
        ip: "#{SUBNET_PREFIX}.#{30 + i}",
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

end
