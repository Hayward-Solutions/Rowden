variable "region" {
  type = string
}

variable "role_arn" {
  type = string
}

variable "function_name" {
  type = string
}

variable "path_to_lambda" {
  type = string
}

variable "match_substring" {
  type = string
}

variable "lambda_cron" {
  type = string
}

variable "default_tags" {
  type = object({
    Name        = string
    Environment = string
    Service     = string
    BillingUnit = string
  })
}
