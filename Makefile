.PHONY: all clean build

all: clean build

build:
	packer init .
	packer validate -var-file=variables.pkrvars.hcl code_server_vm.pkr.hcl
	packer build -force -on-error=cleanup -var-file=variables.pkrvars.hcl code_server_vm.pkr.hcl

clean:
	rm -rf dist/
	rm -rf output/
