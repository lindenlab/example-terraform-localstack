# Pin version if Terraform releases an aws providor that
# breaks on localstack - but this should only ever be temporary
terraform {
   required_providers {
     aws = "<= 3.18.0"
   }
}

provider "aws" {
  region                      = "us-west-2"
  access_key                  = "fake"
  secret_key                  = "fake"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    apigateway     = "http://localstack:4566"
    cloudformation = "http://localstack:4566"
    cloudwatch     = "http://localstack:4566"
    dynamodb       = "http://localstack:4566"
    es             = "http://localstack:4566"
    firehose       = "http://localstack:4566"
    iam            = "http://localstack:4566"
    kinesis        = "http://localstack:4566"
    lambda         = "http://localstack:4566"
    route53        = "http://localstack:4566"
    redshift       = "http://localstack:4566"
    s3             = "http://localstack:4566"
    secretsmanager = "http://localstack:4566"
    ses            = "http://localstack:4566"
    sns            = "http://localstack:4566"
    sqs            = "http://localstack:4566"
    ssm            = "http://localstack:4566"
    stepfunctions  = "http://localstack:4566"
    sts            = "http://localstack:4566"
  }
}

resource "aws_sns_topic" "sns-ecom-events" {
  name = "ecom-events-sandbox"
}

resource "aws_sns_topic_subscription" "ecom-events-webhook-target" {
  topic_arn = aws_sns_topic.sns-ecom-events.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.webhook_lambda.arn
}

resource "aws_sns_topic_subscription" "ecom-events-receipt-target" {
  topic_arn = aws_sns_topic.sns-ecom-events.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.receipt_lambda.arn

  filter_policy = <<EOF
  {
    "event_name": ["invoice-completed", "receipt-payout-execute-completed"]
  }
  EOF
}

resource "aws_sns_topic_subscription" "ecom-events-payments-target" {
  topic_arn = aws_sns_topic.sns-ecom-events.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.extraction-payments-events.arn

  filter_policy = <<EOF
  {
    "event_name": ["account-created"]
  }
  EOF
}

resource "aws_sns_topic_subscription" "ecom-events-payments-target-delay" {
  topic_arn = aws_sns_topic.sns-ecom-events.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.extraction-payments-events-delay.arn

  filter_policy = <<EOF
  {
    "event_name": ["rebilly-pm-added"]
  }
  EOF
}

resource "aws_sns_topic_subscription" "ecom-events-fraud-target" {
  topic_arn = aws_sns_topic.sns-ecom-events.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.extraction-fraud-events.arn

  filter_policy = <<EOF
  {
    "event_name": ["watchlist-manual-review"]
  }
  EOF
}

resource "aws_sns_topic_subscription" "ecom-events-payout-target" {
  topic_arn = aws_sns_topic.sns-ecom-events.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.extraction-payout-events.arn

  filter_policy = <<EOF
  {
    "event_name": ["payout-invoice-completed"]
  }
  EOF
}

resource "aws_sqs_queue" "extraction-payments-events" {
  name                      = "extraction-payments-events"
  receive_wait_time_seconds = 20
}


resource "aws_sqs_queue" "extraction-fraud-events" {
  name                      = "extraction-fraud-events"
  receive_wait_time_seconds = 20
}

resource "aws_sqs_queue" "extraction-payout-events" {
  name                      = "extraction-payout-events"
  receive_wait_time_seconds = 20
}

resource "aws_sqs_queue" "extraction-payments-events-delay" {
  name                      = "extraction-payments-events-delay"
  delay_seconds             = 1
  receive_wait_time_seconds = 20
}

resource "aws_lambda_event_source_mapping" "rebilly-lambda-event-source-mapping" {
  event_source_arn  = aws_sqs_queue.extraction-payments-events-delay.arn
  enabled           = true
  function_name     = aws_lambda_function.rebilly_lambda.arn
  batch_size        = 1
}

