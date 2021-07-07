module "aws_config_rules_us_east_1" {
  count = var.acm_certificate_expiration_check ? 1 : 0
  source                        = "/Users/jason.drouhard/Projects/source/terraform-aws-config-rules"
  # version                       = "1.0.1"
  include_global_resource_rules = true #only include global resource on one region to prevent duplicate rules
  source_recorder               = module.aws_config_recorder_us_east_1.aws_config_configuration_recorder_id
  required_tags_enabled         = true
  sns_notifications = true
  acm_certificate_expiration_check = true
  required_tags = {
    tag1Key = "Environment" # Yes, the actual required format is tag#Key and the required key
  }

  # tag1Key   = "Provisioner"
  # tag1Value = "Terraform"
  # tag2Key   = "Customer"
  # tag3Key   = "Application"

  providers = {
    aws = aws.us-east-1
  }
    topic_arn = aws_sns_topic.infrastructure_alerts.arn
    automation_role = aws_iam_role.automation_role.id
    message = "Your ACM certificates are expiring soon!"
}


//
//module "aws_config_rules_us_east_2" {
//  source                = "StratusGrid/config-rules/aws"
//  version               = "1.0.1"
//  source_recorder       = module.aws_config_recorder_us_east_2.aws_config_configuration_recorder_id
//  required_tags_enabled = true
//  required_tags = {
//    tag1Key = "Environment" # Yes, the actual required format is tag#Key and the required key
//  }
//
//  providers = {
//    aws = aws.us-east-2
//  }
//}
//
//module "aws_config_rules_us_west_1" {
//  source                = "StratusGrid/config-rules/aws"
//  version               = "1.0.1"
//  source_recorder       = module.aws_config_recorder_us_west_1.aws_config_configuration_recorder_id
//  required_tags_enabled = true
//  required_tags = {
//    tag1Key = "Environment" # Yes, the actual required format is tag#Key and the required key
//  }
//
//  providers = {
//    aws = aws.us-west-1
//  }
//}
//
//module "aws_config_rules_us_west_2" {
//  source                = "StratusGrid/config-rules/aws"
//  version               = "1.0.1"
//  source_recorder       = module.aws_config_recorder_us_west_2.aws_config_configuration_recorder_id
//  required_tags_enabled = true
//  required_tags = {
//    tag1Key = "Environment" # Yes, the actual required format is tag#Key and the required key
//  }
//
//  providers = {
//    aws = aws.us-west-2
//  }
//}

//resource "aws_config_config_rule" "acm-certificate-expiration-check" {
//  name        = "acm_certificate_expiration_check"
//  description = "Checks to see if the ACM certificate has expired."
//  source {
//    owner             = "AWS"
//    source_identifier = "ACM_CERTIFICATE_EXPIRATION_CHECK"
//  }
//
////  depends_on                  = [aws_config_configuration_recorder.sns_recorder]
//  maximum_execution_frequency = "TwentyFour_Hours"
//  input_parameters            = jsonencode({ daysToExpiration : "14" })
//
//  scope {
//    compliance_resource_types = ["AWS::ACM::Certificates"]
//  }
//}


//resource "aws_config_delivery_channel" "sns" {
//  s3_bucket_name = aws_s3_bucket.aws_config_history.id
//  sns_topic_arn  = aws_sns_topic.acm_check.arn
//}

//resource "aws_config_configuration_recorder" "sns_recorder" {
//  role_arn = aws_iam_role.config.arn
//}
//
//resource "aws_config_configuration_recorder_status" "sns_recorder" {
//  is_enabled = true
//  name       = aws_config_configuration_recorder.sns_recorder.name
//  depends_on = [aws_config_delivery_channel.sns]
//}

resource "aws_iam_role" "automation_role" {
  name = "aws_config"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "config" {
  name = "automation_role"
  role = aws_iam_role.automation_role.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.testing_config.arn}",
        "${aws_s3_bucket.testing_config.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": "sns:Publish",
      "Resource": "arn:aws:sns:us-east-1:973081273628:testing-acm-check-test"
    },
    {
      "Effect": "Allow",
      "Action": [
        "acm:*"
      ],
      "Resource": [
        "arn:aws:acm:us-east-1:973081273628:certificate/*",
        "arn:aws:acm:us-east-1:973081273628:*"
      ]
    }
  ]
}

POLICY
}

resource "aws_s3_bucket" "testing_config" {
  bucket = "aws-config-test123"
}
