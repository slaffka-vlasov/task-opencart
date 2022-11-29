resource "yandex_mdb_postgresql_cluster" "psql-cl-01" {
  name        = var.psqlcl_name
  environment = "PRESTABLE"
  network_id  = yandex_vpc_network.vpc-task-01.id
  labels      = var.tags

  config {
    version = 15
    resources {
      resource_preset_id = "s2.micro"
      disk_type_id       = "network-ssd"
      disk_size          = 16
    }

    postgresql_config = {
      max_connections                = 395
      enable_parallel_hash           = true
      autovacuum_vacuum_scale_factor = 0.34
      default_transaction_isolation  = "TRANSACTION_ISOLATION_READ_COMMITTED"
      shared_preload_libraries       = "SHARED_PRELOAD_LIBRARIES_AUTO_EXPLAIN"
    }
  }

  maintenance_window {
    type = "WEEKLY"
    day  = "SAT"
    hour = 12
  }

  host {
    zone      = "ru-central1-a"
    subnet_id = yandex_vpc_subnet.sn-task-01.id
  }
}

resource "yandex_mdb_postgresql_database" "psql-db-01" {
  cluster_id = yandex_mdb_postgresql_cluster.psql-cl-01.id
  name       = var.psqldb_name
  owner      = yandex_mdb_postgresql_user.opencart.name
  lc_collate = "en_US.UTF-8"
  lc_type    = "en_US.UTF-8"
  extension {
    name = "uuid-ossp"
  }
  extension {
    name = "xml2"
  }
}

resource "yandex_mdb_postgresql_user" "opencart" {
  cluster_id = yandex_mdb_postgresql_cluster.psql-cl-01.id
  name       = "opencart"
  password   = var.psqldb_user_password
}
