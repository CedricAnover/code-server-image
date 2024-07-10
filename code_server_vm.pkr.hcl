packer {
  required_plugins {
    vagrant = {
      version = "~> 1"
      source = "github.com/hashicorp/vagrant"
    }
  }
}

# Note: This file is for Variable Declaration
variable "source_path" {
  type = string
  default = "bento/ubuntu-22.04"
}

variable "box_name" {
  type = string
  default = "code-server-box"
}

#variable "box_version" {
#  type = string
#  default = "<= 202401.31.0"
#}

variable "new_vagrant_passwd" {
  type = string
  default = "testpass"
}

variable "sysbox_version" {
  type = string
  default = "0.6.4"
}


source "vagrant" "base-code-server" {
  # ========================== Build Configs
  source_path = "${var.source_path}"
  #box_version = "${var.box_version}"
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
  #provisioner "file" {source = "..." destination = ""}

  provisioner "shell" {
    scripts = [
      "scripts/setup_applications.sh",
      "scripts/setup_sysbox.sh",
      "scripts/modify_credentials.sh"
    ]
  }

  # ========================== Post-Processing
  post-processors {
    post-processor "shell-local" {
      # Commands: 
      # tar -xvf path/to/package.box -C path/to/folder
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
        artifact_version = "0.1.0"
      }
    }

    post-processor "shell-local" {
      # Cleanup
      inline = [
        "rm -rf output"
      ]
    }

    #post-processor "artifice" {
    #  files = [
    #    "dist/${var.box_name}.tar.gz",
    #    "dist/${var.box_name}.zip"
    #  ]
    #  keep_input_artifact = true
    #}

    #post-processor "checksum" {
    #  checksum_types = ["md5", "sha1", "sha256"]
    #  output = "dist/${var.box_name}.checksum"
    #}
  }
}
