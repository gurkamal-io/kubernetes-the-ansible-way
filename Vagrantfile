# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # HAProxy loadbalancer
  config.vm.define "loadbalancer" do |loadbalancer|
    loadbalancer.vm.box = "centos/7"
    loadbalancer.vm.box_version = "1905.1"
    loadbalancer.vm.hostname = "loadbalancer"
    loadbalancer.vm.network "private_network", type: "dhcp"
    loadbalancer.vm.provider "libvirt" do |libvirt|
      libvirt.qemu_use_session = false
      libvirt.memory = 2048
      libvirt.cpus = 1
    end
    loadbalancer.vm.provision "shell", inline: <<-SHELL
      yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
      yum install -y ansible
    SHELL
  end

  # Kubernetes Master Nodes / Control Plane
  MASTER_NODE_COUNT = 3
  (0...(MASTER_NODE_COUNT)).each do |i|
    config.vm.define "master#{i}" do |master|
      master.vm.box = "centos/7"
      master.vm.box_version = "1905.1"
      master.vm.hostname = "master#{i}"
      master.vm.network "private_network", type: "dhcp"
      master.vm.provider "libvirt" do |libvirt|
        libvirt.qemu_use_session = false
        libvirt.memory = 4096
        libvirt.cpus = 2
      end
      master.vm.synced_folder ".", "/vagrant", disabled: true
    end
  end

end
