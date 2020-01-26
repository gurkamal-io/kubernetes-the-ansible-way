# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Private Network Subnet for all Nodes
  SUBNET_PREFIX= "10.0.0"

  # HAProxy Nodes (Active/Standby High Availability)
  LOAD_BALANCER_COUNT = 2
  (0...(LOAD_BALANCER_COUNT)).each do |i|
    config.vm.define "haproxy-#{i}" do |haproxy_i|
      haproxy_i.vm.box = "centos/7"
      haproxy_i.vm.box_version = "1905.1"
      haproxy_i.vm.hostname = "haproxy-#{i}"
      haproxy_i.vm.network "private_network",
        ip: "#{SUBNET_PREFIX}.#{50 + i}",
        libvirt__network_name: "kubernetes"
      haproxy_i.vm.provider "libvirt" do |libvirt|
        libvirt.qemu_use_session = false
        libvirt.memory = 1024
        libvirt.cpus = 1
      end
      haproxy_i.vm.synced_folder ".", "/vagrant", disabled: true
      if i == 0
        haproxy_i.vm.synced_folder "./.vagrant/machines", "/vagrant_machines", disabled: false
      end
    end
  end

  # Kubernetes Master Nodes
  MASTER_NODE_COUNT = 3
  (0...(MASTER_NODE_COUNT)).each do |i|
    config.vm.define "master-#{i}" do |master_i|
      master_i.vm.box = "centos/7"
      master_i.vm.box_version = "1905.1"
      master_i.vm.hostname = "master-#{i}"
      master_i.vm.network "private_network", 
        ip: "#{SUBNET_PREFIX}.#{100 + i}",
        libvirt__network_name: "kubernetes"
      master_i.vm.provider "libvirt" do |libvirt|
        libvirt.qemu_use_session = false
        libvirt.memory = 4096
        libvirt.cpus = 2
      end
      master_i.vm.synced_folder ".", "/vagrant", disabled: true
    end
  end

  # Kubernetes Worker Nodes
  WORKER_NODE_COUNT = 3
  (0...(WORKER_NODE_COUNT)).each do |i|
    config.vm.define "worker-#{i}" do |worker_i|
      worker_i.vm.box = "centos/7"
      worker_i.vm.box_version = "1905.1"
      worker_i.vm.hostname = "worker-#{i}"
      worker_i.vm.network "private_network", 
        ip: "#{SUBNET_PREFIX}.#{200 + i}",
        libvirt__network_name: "kubernetes"
      worker_i.vm.provider "libvirt" do |libvirt|
        libvirt.qemu_use_session = false
        libvirt.memory = 2048
        libvirt.cpus = 1
      end
      worker_i.vm.synced_folder ".", "/vagrant", disabled: true
    end
  end

end
