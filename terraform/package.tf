resource "null_resource" "install_requirements" {
  triggers = {
    redeploy = timestamp()
  }
  provisioner "local-exec" {
    working_dir = var.path_to_lambda
    command = join(" ", [
      "if [ -f requirements.txt ];",
      "then",
      "  pip3 download --only-binary :all: --platform manylinux1_x86_64 --python-version 39 --dest . -r requirements.txt;",
      "  for FILE in *.whl; do unzip $FILE; done;",
      "  rm -rf *.whl *.dist-info;",
      "fi"
    ])
  }
}

data "archive_file" "package" {
  depends_on  = [null_resource.install_requirements]
  type        = "zip"
  source_dir  = var.path_to_lambda
  output_path = "${var.path_to_lambda}/lambda.zip"
}

resource "null_resource" "delete_zip" {
  depends_on = [aws_lambda_function.lambda]
  triggers = {
    redeploy = timestamp()
  }
  provisioner "local-exec" {
    working_dir = var.path_to_lambda
    command     = "rm -rf lambda.zip"
  }
}

resource "null_resource" "delete_requirements" {
  depends_on = [aws_lambda_function.lambda]
  triggers = {
    redeploy = timestamp()
  }
  provisioner "local-exec" {
    working_dir = var.path_to_lambda
    command     = "rm -rf $(ls | grep -v -E \".*.py|requirements.txt\")"
  }
}
