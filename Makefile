init:
	ssh-keygen.exe -t rsa -b 4096 
	aws-vault exec home --region ap-southeast-2 -- terraform init 
	aws-vault exec home --region ap-southeast-2 -- terraform plan -out vpc.plan
	aws-vault exec home --region ap-southeast-2 -- terraform apply vpc.plan
packer_init:
	aws-vault exec home --region ap-southeast-2 -- packer init .\dev-machine.pkr.hcl
build_image:
	aws-vault exec home --region ap-southeast-2 -- packer build .\dev-machine.pkr.hcl
cleanup:
	aws-vault exec home --region ap-southeast-2 -- terraform destroy