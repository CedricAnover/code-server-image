# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.hostname = "code-server-host"

  config.vm.define "source", autostart: false do |source|
    source.vm.box = "{{.SourceBox}}"
    config.ssh.insert_key = {{.InsertKey}}
  end

  config.vm.define "output" do |output|
    output.vm.box = "{{.BoxName}}"
    output.vm.box_url = "file://package.box"
    config.ssh.insert_key = {{.InsertKey}}
  end

  config.vm.network "forwarded_port", guest: 80, host: 8080

  config.vm.provider "virtualbox" do |vb|
    # vb.name = "code-server-vm"
    vb.gui = false
    vb.memory = "4000"
    vb.cpus = 2

    # Enable nested virtualization for Sysbox and Docker
    vb.customize ["modifyvm", :id, "--nested-hw-virt", "on"]
    # TODO: Modify Disk Size
  end

  {{ if ne .SyncedFolder "" -}}
  		config.vm.synced_folder "{{.SyncedFolder}}", "/vagrant"
  {{- else -}}
  		config.vm.synced_folder ".", "/vagrant", disabled: true
  {{- end}}

  config.vm.provision "docker", images: ["nginx"]
end
