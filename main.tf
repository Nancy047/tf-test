
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  credentials = file("service-accounts.json")
  project     = "abc"
}

resource "google_container_cluster" "default" {
  name     = "gcp-kubernetes-cluster"
  location = "us-central1"
  initial_node_count = 3
  node_config {
    machine_type = "e2-medium"
  }
  master_auth {
    username = "admin"
  }
  network = "default"
  subnetwork = "projects/gcp-project-id/regions/us-central1/subnetworks/default"
}

resource "google_cloudfunctions_function" "default" {
  name     = "gcp-cloud-function"
  runtime  = "nodejs16"
  entry_point = "helloHTTP"
  source_archive_bucket = "gcp-cloud-function-bucket"
  source_archive_object = "gcp-cloud-function.zip"
  trigger_http = true
  region = "us-central1"
}

resource "google_app_engine_application" "default" {
  location_id = "us-central1"
  name        = "gcp-app-engine-app"
}

resource "google_app_engine_service" "default" {
  name     = "gcp-app-engine-service"
  location = "us-central1"
  application = google_app_engine_application.default.name
  runtime = "nodejs16"
  entry_point = "app.js"
  env = "standard"
  scaling {
    manual_scaling {
      instances = 1
    }
  }
}
