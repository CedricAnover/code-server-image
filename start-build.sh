#!/bin/bash


# Build Workflow
rm -rf output/

# packer init .
packer validate code_server_vm.pkr.hcl
packer build -force -on-error=cleanup code_server_vm.pkr.hcl
