username     = "admin"
password     = "xxxx"
endpoint     = "10.0.0.0"
insecure     = true
port         = 9440
wait_timeout = 10

vmname = {
  dev  = "terraform-dev-"
  prod = "terraform-prod-"
}

memory = {
  dev  = 2048
  prod = 4096
}

vmcount = {
  dev  = 1
  prod = 2
}

categories = {
  dev  = "dev_terraform"
  prod = "prod_terraform"
}