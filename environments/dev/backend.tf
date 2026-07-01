terraform {
  backend "s3" {
    bucket         = "mytf-ithomelab-state-file-bucket"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    use_lockfile   = true
  }
}
