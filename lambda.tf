
resource "aws_lambda_function" "receipt_lambda" {
  function_name = "receipt_lambda"
  filename      = "lambdas/receipt_lambda.zip"
  role          = "fake_role"
  handler       = "receipt_lambda"
  runtime       = "go1.x"
  timeout       = 30
  environment {
    variables = {
      SERVICE_NAME = "receipt_lambda"

      SETTINGSDB_USE_REDIS = "true"
      SETTINGSDB_ENDPOINT = "rayj2.dev.tilia-inc.com:6379"
      SETTINGSDB_PASSWORD = "kj298dh29fball4hbrfa98"
      LOG_FLUENT_ENDPOINT = "rayj2.dev.tilia-inc.com:24224"
      LOG_FLUENT_SUFFIX = ".log"
      LOG_AUGMENT_LIST = "ENVIRONMENT"
      ENVIRONMENT = "sandbox"

    }
  }
}

resource "aws_lambda_function" "webhook_lambda" {
  function_name = "webhook_lambda"
  filename      = "lambdas/webhook_lambda.zip"
  role          = "fake_role"
  handler       = "webhook_lambda"
  runtime       = "go1.x"
  timeout       = 30
  environment {
    variables = {
      SERVICE_NAME = "webhook_lambda"

      SETTINGSDB_USE_REDIS = "true"
      SETTINGSDB_ENDPOINT = "rayj2.dev.tilia-inc.com:6379"
      SETTINGSDB_PASSWORD = "kj298dh29fball4hbrfa98"
      LOG_FLUENT_ENDPOINT = "rayj2.dev.tilia-inc.com:24224"
      LOG_FLUENT_SUFFIX = ".log"
      LOG_AUGMENT_LIST = "ENVIRONMENT"
      ENVIRONMENT = "sandbox"

    }
  }
}

resource "aws_lambda_function" "rebilly_lambda" {
  function_name = "rebilly_lambda"
  filename      = "lambdas/rebilly_lambda.zip"
  role          = "fake_role"
  handler       = "rebilly_lambda"
  runtime       = "go1.x"
  timeout       = 30
  environment {
    variables = {
      SERVICE_NAME = "rebilly_lambda"

      DB_CONNECTION="root:password@tcp(rayj2.dev.tilia-inc.com:33306)/payments?charset=utf8&parseTime=True"
      DB_MAX_IDLE_CONN=32
      DB_MAX_OPEN_CONN=32
      SETTINGSDB_USE_REDIS = "true"
      SETTINGSDB_ENDPOINT = "rayj2.dev.tilia-inc.com:6379"
      SETTINGSDB_PASSWORD = "kj298dh29fball4hbrfa98"
      LOG_FLUENT_ENDPOINT = "rayj2.dev.tilia-inc.com:24224"
      LOG_FLUENT_SUFFIX = ".log"
      HTTP_CLIENT_CC_CLIENT_TIMEOUT_SECONDS=6
      HTTP_CLIENT_PSP_CLIENT_TIMEOUT=15
      HTTP_CLIENT_PSP_CLIENT_MAX_RETRIES=3
      HTTP_CLIENT_PSP_CLIENT_RETRY_WAIT_TIME="250ms"
      HTTP_CLIENT_PSP_CLIENT_LOGGING_ENABLED=true
      HTTP_CLIENT_INSECURE_TRANSPORT=true
      LOG_AUGMENT_LIST = "ENVIRONMENT"
      ENVIRONMENT = "sandbox"

    }
  }
}

