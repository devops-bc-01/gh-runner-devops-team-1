# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'json'

Vagrant.configure("2") do |config|

  keys = File.read('./keys.json')
  parameters = JSON.parse(keys)
  runner_variables = parameters['runner'] # Runner variables

  vm_docker = parameters['vm_docker']
  (1..vm_docker['node_count']).each do |i|
    config.vm.define "docker-#{i}" do |dockerConfig|
      dockerConfig.vm.box = vm_docker['image']
      dockerConfig.vm.hostname = "devops-runner-team-1-#{i}"
      dockerConfig.vm.synced_folder ".", "/vagrant"
      dockerConfig.ssh.extra_args = ["-t", "cd /vagrant; bash --login"] #Entering directly to /vagrant
      
      dockerConfig.vm.network :forwarded_port, host: "#{(4*i) + 8996}", guest: 8080 #Sonarqube -> docker-compose.yml for 
      dockerConfig.vm.network :forwarded_port, host: "#{((4*i)+1) + 8996}", guest: 8081 #Portainer -> docker-compose.yml for 
      dockerConfig.vm.network :forwarded_port, host: "#{((4*i)+2) + 8996}", guest: 8082 #Nexus sonatype
      dockerConfig.vm.network :forwarded_port, host: "#{((4*i)+3) + 8996}", guest: 8083 #Jenkins
      #dockerConfig.vm.network :forwarded_port, host: "#{(5*i)+4 + 8995}", guest: 8084 #Jenkins controller port (only used with inbound jenkins agents)

      dockerConfig.vm.provider :virtualbox do |vb|
        vb.gui = false
        vb.memory = vm_docker['ram']
        vb.cpus = vm_docker['cpus']
        vb.customize ['modifyvm', :id, '--nested-hw-virt', 'on']
      end
      
      dockerConfig.vm.provision "sonarqube", type: "shell" do |s| # Sonarqube settings for Elasticsearch
        s.path= "sonarqube.sh"
      end

      dockerConfig.vm.provision :docker

      dockerConfig.vm.provision :docker_up, 
        type: "shell", 
        after: :docker,
        inline: "cd /vagrant && docker compose up -d", 
        privileged: false

      dockerConfig.vm.provision "shell" do |s| # Runner shell
        s.path= "github_runner_script.sh"
        s.args= [
          runner_variables["url"], 
          runner_variables["hash"], 
          runner_variables["repo"], 
          runner_variables["token"], 
          "devops-runner-team-1-docker-#{i}"
        ]
        s.privileged= false
      end
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

      podmanConfig.vm.provision "shell", inline: <<-SHELL # Installing podman
        sudo apt update
        sudo apt-get install -y podman
      SHELL

      podmanConfig.vm.provision "shell" do |s| # Runner shell
        s.path= "github_runner_script.sh"
        s.args= [
          runner_variables["url"], 
          runner_variables["hash"], 
          runner_variables["repo"], 
          runner_variables["token"], 
          "devops-runner-team-1-podman-#{i}"
        ]
        s.privileged= false
      end
    end
  end
end