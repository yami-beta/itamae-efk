# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  # config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "private_network", ip: "192.168.33.100"
  config.vm.synced_folder ".", "/home/vagrant/itamae-efk", create: true
  config.vm.provider "virtualbox" do |vb|
    vb.customize [ 'modifyvm', :id, '--paravirtprovider', 'kvm' ]
    vb.memory = "1024"
    vb.linked_clone = true
  end

  config.vm.provision "shell", inline: <<-SHELL
    echo 'deb https://dl.bintray.com/itamae/itamae trusty contrib' | sudo tee /etc/apt/sources.list.d/itamae.list
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv D401AB61
    sudo apt-get update
    sudo apt-get install -y itamae
    sudo apt-get autoclean
  SHELL
end
