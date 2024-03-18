function_name   = "dev-eu-west-2-ec2-stop"
path_to_lambda  = "../lambda/ec2-stop"
region          = "eu-west-2"
match_substring = "rowden"
lambda_cron     = "cron(0 19 ? * * *)" # Every day at 7PM

default_tags = {
  Name        = "dev-eu-west-2-ec2-stop"
  Environment = "dev"
  Service     = "TechTest"
  BillingUnit = "platform"
}
