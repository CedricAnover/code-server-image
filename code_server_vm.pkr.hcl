packer {
  required_plugins {
    vagrant = {
      version = "~> 1"
      source = "github.com/hashicorp/vagrant"
    }
  }
}

variable "source_path" {
  type = string
  default = "bento/ubuntu-22.04"
}

variable "box_name" {
  type = string
  default = "code-server-box"
}

variable "box_version" {
  type = string
  default = "<= 202407.23.0"
}

variable "new_user" {
  type = string
}

variable "new_user_password" {
  type = string
}

variable "new_vagrant_password" {
  type = string
}

variable "sysbox_version" {
  type = string
  default = "0.6.4"
}

variable "box_artifact_version" {
  type = string
}


source "vagrant" "base-code-server" {
  # ========================== Build Configs
  source_path = "${var.source_path}"
  box_version = "${var.box_version}"
  output_dir = "output"
  box_name = "${var.box_name}"
  template = "./Vagrantfile.tpl"
  output_vagrantfile = "./output/Vagrantfile"

  provider = "virtualbox"
  #teardown_method = "destroy"
  add_force = true
  skip_add = true
  #add_clean = true
  #skip_package = false
  #package_include = ["", ""]

  # ========================== SSH Configs
  communicator = "ssh"
  #insert_key = false
}

build {
  sources = ["source.vagrant.base-code-server"]

  # ========================== Provisioning
  provisioner "shell" {
    script           = "scripts/modify_credentials.sh"
    execute_command  = "{{ .Path }} ${var.new_user} ${var.new_user_password} ${var.new_vagrant_password}"
  }

  # Supply Python Tools
  provisioner "shell" { 
    script          = "scripts/install_pyenv.sh" 
    execute_command = "sudo -u ${var.new_user} -S sh '{{ .Path }}'"
  }
  provisioner "shell" {
    script          = "scripts/install_pipx_and_poetry.sh" 
    execute_command = "sudo -u ${var.new_user} -S sh '{{ .Path }}'"
  }

  # Install Sysbox
  provisioner "shell" {
    script           = "scripts/setup_sysbox.sh"
    // execute_command  = "{{ .Path }} ${var.sysbox_version} ${var.new_user}"
    execute_command  = "sudo -u '${var.new_user}' -i sh -c '{{ .Path }} ${var.sysbox_version}'"
  }

  # ========================== Post-Processing
  post-processors {
    post-processor "shell-local" {
      inline = [
        "rm -rf dist",
        "mkdir dist",
        "tar -xvf output/package.box -C output/"
      ]
    }

    post-processor "artifice" {
      files = [
        "output/box.ovf",
        "output/box-disk001.vmdk"
      ]
      keep_input_artifact = true
    }

    # .box -> .{vmdk,ovf} -> .{zip,tar.gz}
    post-processor "compress" {
      output = "dist/${var.box_name}.zip"
      format = ".zip"
      keep_input_artifact = true
    }
    post-processor "compress" {
      output = "dist/${var.box_name}.tar.gz"
      format = ".tar.gz"
      keep_input_artifact = true
    }

    post-processor "manifest" {
      output = "dist/manifest.json"
      strip_path = false
      strip_time = true
      custom_data = {
        artifact_version = "${var.box_artifact_version}"
      }
    }

    # Cleanup
    post-processor "shell-local" {
      inline = [
        "rm -rf output"
      ]
    }

    #post-processor "checksum" {
    #  checksum_types = ["md5", "sha1", "sha256"]
    #  output = "dist/${var.box_name}.checksum"
    #}
  }
}
