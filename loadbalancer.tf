data "yandex_compute_instance_group" "k8s_ig" {
  instance_group_id = yandex_kubernetes_node_group.k8s-ngroup-01.instance_group_id
  depends_on = [
    yandex_kubernetes_node_group.k8s-ngroup-01
  ]
}

locals {
  k8s_node_ip_addresses = data.yandex_compute_instance_group.k8s_ig.instances.*.network_interface.0.ip_address
}

resource "yandex_lb_target_group" "lb-tg-01" {
  name      = "tg-01"
  region_id = "ru-central1"


  dynamic "target" {
    for_each = local.k8s_node_ip_addresses
    content {
      subnet_id = yandex_vpc_subnet.sn-task-01.id
      address   = target.value
    }
  }

  depends_on = [
    yandex_kubernetes_node_group.k8s-ngroup-01
  ]
}

resource "yandex_lb_network_load_balancer" "lb-01" {
  name   = "lb-01"
  labels = var.tags

  listener {
    name = "my-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }
  attached_target_group {
    target_group_id = yandex_lb_target_group.lb-tg-01.id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}
