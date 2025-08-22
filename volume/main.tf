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
      app      = "redis"
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
        path = var.host_path
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
      storageClass = var.storage_class
      capacity     = var.context.resource.properties.size
      accessModes  = [var.context.resource.properties.accessMode == null ? var.access_mode : var.context.resource.properties.accessMode]
      hostPath     = var.host_path
      name         = var.context.resource.name
    }
  }
}
