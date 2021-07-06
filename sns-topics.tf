# infrastructure_alerts is used to alert on infrastructure monitoring alarms etc.
resource "aws_sns_topic" "infrastructure_alerts" {
  name = "${var.name_prefix}-infrastructure-alerts${local.name_suffix}"
  tags = merge(local.common_tags, {})
}

resource "aws_sns_topic_policy" "acm_sns_permissions" {
  arn    = aws_sns_topic.infrastructure_alerts.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = var.account_numbers
    }

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      aws_sns_topic.infrastructure_alerts.arn
    ]

    sid = "__default_statement_ID"
  }
}



