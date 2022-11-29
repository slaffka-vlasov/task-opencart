resource "yandex_compute_instance" "vm01" {
  name        = var.vm_name
  platform_id = "standard-v3"
  zone        = "ru-central1-a"
  labels      = var.tags

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd8kb72eo1r5fs97a1ki" # ubuntu 22-04
      size     = 15
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.sn-task-01.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
