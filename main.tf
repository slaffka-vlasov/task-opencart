terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.82.0"
    }
  }

  backend "s3" {
    endpoint                    = "storage.yandexcloud.net"
    bucket                      = "terraform-task-01"
    region                      = "ru-central1"
    key                         = "terraform/terraform.tfstate"
    access_key                  = ""
    secret_key                  = ""
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = "ru-central1-a"
}
