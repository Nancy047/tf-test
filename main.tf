
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  credentials = file("keys.json")
  project     = "abc"
}

resource "google_container_cluster" "default" {
  name     = "gcp-kubernetes-engine-cluster"
  location = "us-central1"
  initial_node_count = 1
  node_config {
    machine_type = "e2-medium"
  }
  master_auth {
    username = "admin"
  }
  network = "default"
  subnetwork = "projects/gcp-project-id/regions/us-central1/subnetworks/default"
}

resource "google_bigquery_data_exchange" "default" {
  dataset_id = "analytics_hub_dataset"
  display_name = "Analytics Hub Dataset"
  data_exchange_id = "analytics_hub_exchange"
  description = "Analytics Hub Data Exchange"
  primary_exchange_asset {
    asset_type = "dataset"
    dataset {
      dataset_id = "analytics_hub_dataset"
    }
  }
  location = "us"
}

resource "google_iap_web_type_app_engine_version" "default" {
  app_id = "gcp-iap-app-engine-app"
  version_id = "gcp-iap-app-engine-version"
  oauth2_client_id = "gcp-iap-client-id"
  oauth2_client_secret = "gcp-iap-client-secret"
  enabled = true
}
