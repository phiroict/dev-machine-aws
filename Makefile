init:
	cd infra/vpc && aws-vault exec home --region ap-southeast-2 -- terraform init
	cd infra/vpc && aws-vault exec home --region ap-southeast-2 -- terraform plan -out vpc.plan
	cd infra/vpc && aws-vault exec home --region ap-southeast-2 -- terraform apply vpc.plan
packer_init:
	aws-vault exec home --region ap-southeast-2 -- packer init .\dev-machine.pkr.hcl
build_image:
	aws-vault exec home --region ap-southeast-2 -- packer build .\dev-machine.pkr.hcl
cleanup:
	aws-vault exec home --region ap-southeast-2 -- terraform destroy
console:
	aws-vault login home --region ap-southeast-2