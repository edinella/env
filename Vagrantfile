# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.box = "thasmo/ubuntu-13.04"
  config.vm.network :private_network, ip: "192.168.33.10"
  config.vm.synced_folder ".", "/nodejs"
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1024"]
    vb.customize ["modifyvm", :id, "--name", "env"]
  end
  config.vm.provision :shell, :path => "install.sh"
end
