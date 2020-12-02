#!/bin/sh

cd /app

echo "waiting for localstack.."
until $(nc -zv localstack 4566); do
	printf '.'
	sleep 1
done

terraform init

terraform plan -out=tfplan 

# If you need to debug set this for lots more info
# export TF_LOG=DEBUG
terraform apply tfplan
