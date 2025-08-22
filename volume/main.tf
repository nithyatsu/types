provider "kubernetes" {
  config_path = var.kubeconfig
}

resource "kubernetes_persistent_volume" "pv" {
  metadata {
    name = var.name
    labels = {
      app      = "redis"
      resource = var.name
      "radapp.io/application" = var.application != "" ? var.application : "someting"
    }
  }

  spec {
    storage_class_name = var.storage_class

    capacity = {
      storage = var.size
    }

    access_modes = [var.access_mode]

    persistent_volume_source {
      host_path {
        path = var.host_path
        type = "DirectoryOrCreate"
      }
    }
  }
}

output "result" {
  value = {
    kind         = "persistent"
    storageClass = kubernetes_persistent_volume.pv.spec[0].storage_class_name
    capacity     = kubernetes_persistent_volume.pv.spec[0].capacity["storage"]
    accessModes  = kubernetes_persistent_volume.pv.spec[0].access_modes
    hostPath     = kubernetes_persistent_volume.pv.spec[0].persistent_volume_source[0].host_path[0].path
    name         = kubernetes_persistent_volume.pv.metadata[0].name
  }
}
