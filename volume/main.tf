terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0"
    }
  }
}

variable "context" {
  description = "Radius-provided object containing information about the resource calling the Recipe."
  type = any
}

locals {
  uniqueName = var.context.resource.name
  namespace = var.context.runtime.kubernetes.namespace
}

resource "kubernetes_persistent_volume" "pv" {
  metadata {
    name = var.context.resource.name
    labels = {
      resource = var.context.resource.name
      # Label pods with the application name so `rad run` can find the logs.
      "radapp.io/application" = var.context.application != null ? var.context.application.name : ""
    }
  }

  spec {
    storage_class_name = "manual"
    
    capacity = {
      storage = var.context.resource.properties.size
    }
    
    access_modes = ["ReadWriteOnce"]
    
    persistent_volume_source {
      host_path {
        path = "/mnt/data"
        type = "DirectoryOrCreate"
      }
    }
  }
}

output "result" {
  value = {
    resources = [
      "/planes/kubernetes/local/providers/core/PersistentVolume/${var.context.resource.name}"
    ]
    values = {
      kind         = "persistent"
      name         = var.context.resource.name
    }
  }
}
