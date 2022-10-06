# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'json'

Vagrant.configure("2") do |config|

  keys = File.read('./keys.json')
  parameters = JSON.parse(keys)

  vm_docker = parameters['vm_docker']
  (1..vm_docker['node_count']).each do |i|
    config.vm.define "docker-#{i}" do |dockerConfig|
      dockerConfig.vm.box = vm_docker['image']
      dockerConfig.vm.hostname = "devops-runner-team-1-#{i}"
      dockerConfig.vm.synced_folder ".", "/vagrant"
      
      dockerConfig.vm.provider :virtualbox do |vb|
        vb.gui = false
        vb.memory = vm_docker['ram']
        vb.cpus = vm_docker['cpus']

      end
      
      # Installing docker and docker-compose
      plugins_dependencies = %w( vagrant-docker-compose )
      plugin_status = false
      plugins_dependencies.each do |plugin_name|
        unless Vagrant.has_plugin? plugin_name
          print "  You dont have the neccesary plugins\n"
          print "  Don't worry, installing...\n"
          print "  ---------------------------------------------\n"

          system("vagrant plugin install #{plugin_name}")
          plugin_status = true
          puts " #{plugin_name}  Dependencies installed"
        end
      end

      # Restart Vagrant if any new plugin installed
      if plugin_status === true
        exec "vagrant #{ARGV.join' '}"
      else
        puts "All Plugin Dependencies allready installed"
      end

      dockerConfig.vm.provision :docker
      dockerConfig.vm.provision :docker_compose

    end
  end

  # PODMAN
  vm_podman = parameters['vm_podman']
  (1..vm_podman['node_count']).each do |i|
    config.vm.define "podman-#{i}" do |podmanConfig|
      podmanConfig.vm.box = vm_podman['image']
      podmanConfig.vm.hostname = "devops-runner-team-1-#{i}"
      podmanConfig.vm.synced_folder ".", "/vagrant"
      
      podmanConfig.vm.provider :virtualbox do |vb|
        vb.gui = false
        vb.memory = vm_podman['ram']
        vb.cpus = vm_podman['cpus']

      end

      podmanConfig.vm.provision :docker
      #podmanConfig.vm.provision :podman
      podmanConfig.vm.provision :docker_compose

      podmanConfig.vm.provision "shell", inline: <<-SHELL
        sudo apt-get install -y podman
      SHELL

      podmanConfig.vm.provision "sonarqube", type: "shell" do |s|
        s.path= "sonarqube.sh"
      end
    end
  end


end
