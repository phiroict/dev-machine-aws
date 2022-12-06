# Create development vm 

## Tech stack 
Install these tools 
- Make 
- Packer 
- Terraform 
- aws-vault
- awscli 

# Prepare

## AWS
Prepare by setting up the `home` target in aws-vault , you need a key and secret for your account on aws. The account needs to be able to create, alter, and delete vpc and subnets. 
`aws-vault add home` and follow the instructions 

## SSH keys 

Create a new key by running you need it for instantiating the system later.
Note that you cannot use rsa type ssh keys here as Ubuntu 22.04 we use as a template OS no longer supports it without explicit allow. 


```
ssh-keygen.exe -t ed25519 -b 521
```
save it as id_ed25519 in the infra/vpc folder. It is ignored by git so you need to generate these yourselves. 

<font color=red>note that you can no longer use rsa keys with the latest Amazon Linux and Ubuntu 22.04 as rsa is phased out.</font> 

# Implementation

## Using packer
### initialize the vpc 

This will create the vpc the image builder will run in. This a terraform script in `infra/vpc`


```
make init
```
The vpc will have the name `dev-vpc` and a subnet `dev-vpc-subnet` the packer builder select on these names. 


Then build the image with 

```
make packer_init
make build_image 
```

Note it may ask you to subscribe to the image first, if so follow the link and approve the for hte account you have here. 
First login with `aws-vault login home` and then follow this url:

https://aws.amazon.com/marketplace/pp?sku=47xbqns9xujfkkjt189a13aqe

The build_image task returns a reference to the build ami image like 

```text
==> dev-machine.amazon-ebs.ubuntu: Creating AMI dev-machine-linux-aws-20221206-091613 from instance i-000133b06308fad8c
    dev-machine.amazon-ebs.ubuntu: AMI: ami-0cd9d05c0067ab3b8
==> dev-machine.amazon-ebs.ubuntu: Waiting for AMI to become ready...
==> dev-machine.amazon-ebs.ubuntu: Skipping Enable AMI deprecation...
==> dev-machine.amazon-ebs.ubuntu: Terminating the source AWS instance...
==> dev-machine.amazon-ebs.ubuntu: Cleaning up any extra volumes...
==> dev-machine.amazon-ebs.ubuntu: No volumes to clean up, skipping
==> dev-machine.amazon-ebs.ubuntu: Deleting temporary security group...
==> dev-machine.amazon-ebs.ubuntu: Deleting temporary keypair...
Build 'dev-machine.amazon-ebs.ubuntu' finished after 5 minutes 32 seconds.

==> Wait completed after 5 minutes 32 seconds

==> Builds finished. The artifacts of successful builds are:
--> dev-machine.amazon-ebs.ubuntu: AMIs were created:
ap-southeast-2: ami-0cd9d05c0067ab3b8
```
(Note your ami id will be different)

## Alternative - AWS image builder

*AWS EC2 image builder*. this is a pipeline building images from recipies and seem to work better than packer.
In the `infra/builder` we create a pipeline that builds the image pipeline. It has the advantage of a shake and bake 

