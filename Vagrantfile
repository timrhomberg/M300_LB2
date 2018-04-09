# -*- mode: ruby -*-
# vi: set ft=ruby :

#
#   Ubuntu Version 16.x 64-bit Linux mit Docker
#

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/xenial64"

  # Create a public network, which generally matched to bridged network.
  #config.vm.network "public_network"
  config.vm.network "private_network", ip:"192.168.60.101" 
  config.vm.network "forwarded_port", guest:8080, host:8080, auto_correct: true
  
  # Share an additional folder to the guest VM.
  # config.vm.synced_folder "../data", "/vagrant_data"

  config.vm.provider "virtualbox" do |vb|
     vb.memory = "2048"
  end

  # Docker Provisioner
  config.vm.provision "docker" do |d|
   d.pull_images "mysql"
   d.pull_images "nextcloud"
   d.run "nextcloud_mysql", image: "mysql", args: "-e MYSQL_ROOT_PASSWORD=secret -e MYSQL_USER=nextcloud -e MYSQL_PASSWORD=secret -e MYSQL_DATABASE=nextcloud --restart=always"
   d.run "nextcloud", image: "nextcloud", args: "--link nextcloud_mysql:mysql -p 8080:80 --restart=always"
  end
end