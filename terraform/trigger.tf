resource "aws_cloudwatch_event_rule" "cw_event" {
  name                = "${var.function_name}-trigger"
  schedule_expression = var.lambda_cron
  state               = "ENABLED"
}

resource "aws_cloudwatch_event_target" "cw_lambda_target" {
  arn  = aws_lambda_function.lambda.arn
  rule = aws_cloudwatch_event_rule.cw_event.name
}

resource "aws_lambda_permission" "cw_trigger_permission" {
  function_name = aws_lambda_function.lambda.function_name
  source_arn    = aws_cloudwatch_event_rule.cw_event.arn
  action        = "lambda:InvokeFunction"
  principal     = "events.amazonaws.com"
}
