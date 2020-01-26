# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|


  # Client machine for ansible and kubectl
  config.vm.define "client" do |client|
    client.vm.box = "centos/7"
    client.vm.box_version = "1905.1"
    client.vm.hostname = "client"
    client.vm.network "private_network", type: "dhcp"
    client.vm.provider "libvirt" do |libvirt|
      libvirt.qemu_use_session = false
      libvirt.memory = 1024
      libvirt.cpus = 1
    end
    client.vm.provision "shell", inline: <<-SHELL
      yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
      yum install -y ansible
    SHELL
  end


  # HAProxy node for load balancing kube-apiserver instances
  config.vm.define "haproxy" do |haproxy|
    haproxy.vm.box = "centos/7"
    haproxy.vm.box_version = "1905.1"
    haproxy.vm.hostname = "haproxy"
    haproxy.vm.network "private_network", type: "dhcp"
    haproxy.vm.provider "libvirt" do |libvirt|
      libvirt.qemu_use_session = false
      libvirt.memory = 1024
      libvirt.cpus = 1
    end
    haproxy.vm.synced_folder ".", "/vagrant", disabled: true
  end


end
