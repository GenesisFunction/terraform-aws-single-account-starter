# Single-Account-Starter

This is to showcase the use of many GenesisFunction and Community modules working together to configure a single account architecture using terraform version 0.12 or higher.

### ToDo
- Wrap with templating language to output a custom from GUI.
-- Primary Region and which Regions to add
-- Whether to do vm import role and bucket

### Init:
```
awsudo -u \<profile\> terraform init
```

### Apply:
```
awsudo -u \<profile\> terraform apply -var region=us-east-1 -var name_prefix=\<prefix\> -var env_name=\<env\> -var source_repo=\<repo\>
```

## Recommended first steps if using this as the account code

- Enable IAM Billing access while logged in as root under My Account
- Delete the default VPCs in all regions you will be using (at least all regions with config rules...)
- Tag the default RDS DB Security Groups in all regions with your required tags (cli to do so is below)

```
awsudo -u \<profile\> aws rds add-tags-to-resource --resource-name "arn:aws:rds:us-east-1:<account_number>:secgrp:default" --tags Key=Environment,Value=prd,Key=Customer,Value=Shared --region us-east-1

awsudo -u \<profile\> aws rds add-tags-to-resource --resource-name "arn:aws:rds:us-east-2:<account_number>:secgrp:default" --tags Key=Environment,Value=prd,Key=Customer,Value=Shared --region us-east-2

awsudo -u \<profile\> aws rds add-tags-to-resource --resource-name "arn:aws:rds:us-west-1:<account_number>:secgrp:default" --tags Key=Environment,Value=prd,Key=Customer,Value=Shared --region us-west-1

awsudo -u \<profile\> aws rds add-tags-to-resource --resource-name "arn:aws:rds:us-west-2:<account_number>:secgrp:default" --tags Key=Environment,Value=prd,Key=Customer,Value=Shared --region us-west-2
```
- Enable updated account features for ECS
```
awsudo -u \<profile\> aws ecs put-account-setting-default --name serviceLongArnFormat --value enabled --region us-east-1
awsudo -u \<profile\> aws ecs put-account-setting-default --name taskLongArnFormat --value enabled --region us-east-1
awsudo -u \<profile\> aws ecs put-account-setting-default --name containerInstanceLongArnFormat --value enabled --region us-east-1
awsudo -u \<profile\> aws ecs put-account-setting-default --name awsvpcTrunking --value enabled --region us-east-1
awsudo -u \<profile\> aws ecs put-account-setting-default --name containerInsights --value enabled --region us-east-1
```

## Recommended final steps
### Change Terraform backend to S3

1. Update `-state.tf` using the output values from a successful `terraform apply`. Then rename to `-state.tf`.
2. Run `terraform init` to update Terrafrom to use S3 bucket as a backend:
```
awsudo -u \<profile\> terraform init
```

### Add existing IAM users to new groups

1. From the AWS Management Console, open Identity and Access Management.
2. Add all existing users who will require admin access to the new restricted-admin group. 

## Tools to Use

- awsudo
- tfenv (if using multiple versions of terraform)
