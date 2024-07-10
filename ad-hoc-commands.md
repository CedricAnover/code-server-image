
## Packer Commands
```bash
# packer validate -var-file=variables.pkrvars.hcl .
# packer build -force -var-file=variables.pkrvars.hcl .

# Build
packer init .
packer validate code_server_vm.pkr.hcl
packer build -force -on-error=cleanup code_server_vm.pkr.hcl

# Debug Mode
packer build -debug -force -var-file=variables.pkrvars.hcl .
```

## Vagrant Commands
```bash
vagrant up

vagrant destroy -f
vagrant destroy -f <vagrant-machine-id-or-name>
```