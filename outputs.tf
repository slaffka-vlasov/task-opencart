output "external_ip_address" {
  value = yandex_compute_instance.vm01.network_interface.0.nat_ip_address
}

output "db_cluster_host" {
  value = yandex_mdb_postgresql_cluster.psql-cl-01.host.0.fqdn
}

output "k8s_external_address" {
  value = yandex_kubernetes_cluster.k8s-cl-01.master.0.external_v4_address
}

output "k8s_internal_address" {
  value = yandex_kubernetes_cluster.k8s-cl-01.master.0.internal_v4_address
}
