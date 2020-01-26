# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # HAProxy loadbalancer
  config.vm.define "load-balancer" do |load_balancer|
    load_balancer.vm.box = "centos/7"
    load_balancer.vm.box_version = "1905.1"
    load_balancer.vm.hostname = "load-balancer"
    load_balancer.vm.network "private_network", type: "dhcp"
    load_balancer.vm.provider "libvirt" do |libvirt|
      libvirt.qemu_use_session = false
      libvirt.memory = 2048
      libvirt.cpus = 1
    end
    load_balancer.vm.provision "shell", inline: <<-SHELL
      yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
      yum install -y ansible
    SHELL
  end

  # Kubernetes Master Nodes / Control Plane
  MASTER_NODE_COUNT = 3
  (0...(MASTER_NODE_COUNT)).each do |i|
    config.vm.define "master-#{i}" do |master_i|
      master_i.vm.box = "centos/7"
      master_i.vm.box_version = "1905.1"
      master_i.vm.hostname = "master-#{i}"
      master_i.vm.network "private_network", type: "dhcp"
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
      worker_i.vm.network "private_network", type: "dhcp"
      worker_i.vm.provider "libvirt" do |libvirt|
        libvirt.qemu_use_session = false
        libvirt.memory = 2048
        libvirt.cpus = 1
      end
      worker_i.vm.synced_folder ".", "/vagrant", disabled: true
    end
  end


end
