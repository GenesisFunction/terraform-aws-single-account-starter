<!-- BEGIN_TF_DOCS -->
# terraform-aws-single-account-starter

GitHub: [StratusGrid/terraform-aws-single-account-starter](https://github.com/StratusGrid/terraform-aws-single-account-starter)

### Template Documentation

This is to showcase the use of many StratusGrid and Community modules working together to configure a single account architecture using terraform version 1.x or higher.

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

1. Update `state.tf` using the output values from a successful `terraform apply`. Then rename to `state.tf`.
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

---

Note: Before reading, uncomment the code for the environment that you
wish to apply the code to. This goes for both the init-tfvars and apply-tfvars
folders.

---

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.63 |

## Resources

| Name | Type |
|------|------|
| [aws_api_gateway_account.apigw_logging_us_east_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_account) | resource |
| [aws_cloudwatch_event_rule.required_tags](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.aws_backup_to_sns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_iam_account_password_policy.strict](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_account_password_policy) | resource |
| [aws_iam_role.apigw_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.apigw_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_sns_topic.infrastructure_alerts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_append_name_suffix"></a> [append\_name\_suffix](#input\_append\_name\_suffix) | String to append to the name\_suffix used on object names. This is optional, so start with dash if using like so: -mysuffix. This will result in prefix-objectname-env-mysuffix | `string` | `""` | no |
| <a name="input_currency"></a> [currency](#input\_currency) | This defines the currency in the monthly\_billing\_threshold | `string` | `"USD"` | no |
| <a name="input_env_name"></a> [env\_name](#input\_env\_name) | Environment name string to be used for decisions and name generation. Appended to name\_suffix to create full\_suffix | `string` | n/a | yes |
| <a name="input_monthly_billing_threshold"></a> [monthly\_billing\_threshold](#input\_monthly\_billing\_threshold) | The maximum amount that can be billed after which a cloudwatch alarm triggers | `string` | `"10000"` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | String to use as prefix on object names | `string` | n/a | yes |
| <a name="input_override_name_suffix"></a> [override\_name\_suffix](#input\_override\_name\_suffix) | String to completely override the name\_suffix | `string` | `""` | no |
| <a name="input_prepend_name_suffix"></a> [prepend\_name\_suffix](#input\_prepend\_name\_suffix) | String to prepend to the name\_suffix used on object names. This is optional, so start with dash if using like so: -mysuffix. This will result in prefix-objectname-mysuffix-env | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region to target | `string` | n/a | yes |
| <a name="input_source_repo"></a> [source\_repo](#input\_source\_repo) | name of repo which holds this code | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_common_tags"></a> [common\_tags](#output\_common\_tags) | tags which should be applied to all taggable objects |
| <a name="output_iam_role_url_restricted_admin"></a> [iam\_role\_url\_restricted\_admin](#output\_iam\_role\_url\_restricted\_admin) | URL to assume restricted admin role in this account |
| <a name="output_iam_role_url_restricted_read_only"></a> [iam\_role\_url\_restricted\_read\_only](#output\_iam\_role\_url\_restricted\_read\_only) | URL to assume restricted read only role in this account |
| <a name="output_log_bucket_ids"></a> [log\_bucket\_ids](#output\_log\_bucket\_ids) | ID of logging bucket |
| <a name="output_name_prefix"></a> [name\_prefix](#output\_name\_prefix) | string to prepend to all resource names |
| <a name="output_name_suffix"></a> [name\_suffix](#output\_name\_suffix) | string to append to all resource names |
| <a name="output_terraform_state_bucket"></a> [terraform\_state\_bucket](#output\_terraform\_state\_bucket) | s3 bucket to store terraform state |
| <a name="output_terraform_state_config_s3_key"></a> [terraform\_state\_config\_s3\_key](#output\_terraform\_state\_config\_s3\_key) | key to use for terraform state key configuration - this is the s3 object key where the config will be stored |
| <a name="output_terraform_state_dynamodb_table"></a> [terraform\_state\_dynamodb\_table](#output\_terraform\_state\_dynamodb\_table) | dynamodb table to control terraform locking |
| <a name="output_terraform_state_kms_key_arn"></a> [terraform\_state\_kms\_key\_arn](#output\_terraform\_state\_kms\_key\_arn) | kms key to use for encrytption when storing/reading terraform state configuration |

---

Note, manual changes to the README will be overwritten when the documentation is updated. To update the documentation, run `terraform-docs -c .config/.terraform-docs.yml`
<!-- END_TF_DOCS -->