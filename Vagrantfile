# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  
  # Client machine for ansible and kubectl
  config.vm.define "client" do |client|
    client.vm.box = "centos/7"
    client.vm.hostname = "client"
    client.vm.network "private_network", type: "dhcp"
    client.vm.provider "libvirt" do |libvirt|
      libvirt.qemu_use_session = false
      libvirt.memory = 512
      libvirt.cpus = 1
    end
  end

end
