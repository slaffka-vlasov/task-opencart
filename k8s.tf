data "yandex_resourcemanager_folder" "vpc01" {
  folder_id = var.folder_id
}

resource "yandex_iam_service_account" "sa-k8s" {
  name        = "sa-k8s"
  description = "service account to manage k8s"
}

resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id = data.yandex_resourcemanager_folder.vpc01.id
  role   = "editor"
  member = "serviceAccount:${yandex_iam_service_account.sa-k8s.id}"
}

resource "yandex_kubernetes_cluster" "k8s-cl-01" {
  name        = var.k8s_cl_name
  description = "Test K8s cluster"

  network_id = yandex_vpc_network.vpc-task-01.id

  master {
    version = "1.22"
    zonal {
      zone      = yandex_vpc_subnet.sn-task-01.zone
      subnet_id = yandex_vpc_subnet.sn-task-01.id
    }

    public_ip = false

    maintenance_policy {
      auto_upgrade = true

      maintenance_window {
        start_time = "15:00"
        duration   = "3h"
      }
    }
  }

  service_account_id      = yandex_iam_service_account.sa-k8s.id
  node_service_account_id = yandex_iam_service_account.sa-k8s.id

  labels = var.tags

  release_channel         = "RAPID"
  network_policy_provider = "CALICO"

}

resource "yandex_kubernetes_node_group" "k8s-ngroup-01" {
  cluster_id  = yandex_kubernetes_cluster.k8s-cl-01.id
  name        = var.k8s_ng_name
  description = "Test NodeGroup"
  version     = "1.20"

  labels = var.tags

  instance_template {
    platform_id = "standard-v3"

    network_interface {
      nat                = true
      subnet_ids         = ["${yandex_vpc_subnet.sn-task-01.id}"]
    }

    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 64
    }

    scheduling_policy {
      preemptible = false
    }

    container_runtime {
      type = "containerd"
    }
  }

  scale_policy {
    fixed_scale {
      size = var.node_count
    }
  }

  allocation_policy {
    location {
      zone = "ru-central1-a"
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      day        = "monday"
      start_time = "15:00"
      duration   = "3h"
    }

    maintenance_window {
      day        = "friday"
      start_time = "10:00"
      duration   = "4h30m"
    }
  }
}