# Create development vm 

## Tech stack 
Install these tools 
- Make 
- Packer 
- Terraform 
- aws-vault
- awscli 

## Prepare

### AWS
Prepare by setting up the `home` target in aws-vault , you need a key and secret for your account on aws. The account needs to be able to create, alter, and delete vpc and subnets. 
`aws-vault add home` and follow the instructions 

### SSH keys 

Createa new key by running 

```
ssh-keygen.exe -t ed25519 -b 521
```
note that you can no longer use rsa keys with the latest Amazon Linnux and Ubuntu 22.04 as rsa is phased out. 

## Run by

```
make init
```

Then build the image with 

```
make build_image 
```

Note it may ask you to subscribe to the image first, if so follow the link and approve the for hte account you have here. 
First login with `aws-vault login home` and then follow this url:

https://aws.amazon.com/marketplace/pp?sku=47xbqns9xujfkkjt189a13aqe

# Alternatives

As packer has issues with setting up correctly we can look into an alternative: 

AWS EC2 image builder. this is a pipeline building images from recipies and seem to work better than packer. 

