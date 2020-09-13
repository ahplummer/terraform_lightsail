# Instructions for Lightsail

## Create .env file
```
#!/bin/bash
export TF_VAR_VPS_NAME="<name of VPS>"
export TF_VAR_REGION="us-east-1"
export TF_VAR_AVAIL_ZONE="us-east-1b"
#openssl rand -hex 10
export TF_VAR_BUCKET_NAME="<globally unique>"
export TF_VAR_BUCKET_KEY="tfstate-key"
export TF_VAR_KEYS_NAME="lightsailkeys"
```
## S3 Setup for remote state

* Login to AWS CLI
```
rm  -rf ~/.aws/credentials
aws configure
```

* Create S3 bucket for TF State.
```
 aws s3api  create-bucket --bucket $TF_VAR_BUCKET_NAME --region $TF_VAR_REGION
```

## Configure keys
* Create keys, saving output.
```
aws lightsail create-key-pair --key-pair-name $TF_VAR_KEYS_NAME > $TF_VAR_KEYS_NAME.txt
```
* Now, snag the private key into a file:
```
cat $TF_VAR_KEYS_NAME.txt | jq -r '.privateKeyBase64' > $TF_VAR_KEYS_NAME.pem 
```
* Adjust perms for private key:
```
chmod 600 $TF_VAR_KEYS_NAME.pem
```

## Init TF Backend

```
terraform init --backend-config "bucket=$TF_VAR_BUCKET_NAME" --backend-config "key=$TF_VAR_BUCKET_KEY" --backend-config "region=$TF_VAR_REGION"
```

## Execing TF
* Plan:
```
terraform plan
```
* Execute, taking note of the IP at the end.
```
terraform -auto-approve
```

## Logging in
```
ssh -i $TF_VAR_KEYS_NAME.pem ec2-user@$(tf output static_ip_addr) 
```


## Adding ports to firewall:
```
aws lightsail open-instance-public-ports --instance-name jenks --region us-east-1 --port-info fromPort=8080,toPort=8080,protocol=tcp
```