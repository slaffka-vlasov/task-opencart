resource "yandex_vpc_network" "vpc-task-01" {
  name   = var.vpc_name
  labels = var.tags
}

resource "yandex_vpc_subnet" "sn-task-01" {
  zone           = "ru-central1-a"
  name           = var.sn_name
  network_id     = yandex_vpc_network.vpc-task-01.id
  v4_cidr_blocks = ["10.10.0.0/24"]
  labels         = var.tags
}