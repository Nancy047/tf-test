
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

resource "google_app_engine_application" "default" {
  location_id = "us-central1"
  name        = "appengine-app"
}

resource "google_app_engine_service" "default" {
  name     = "default"
  location = "us-central1"
  application = google_app_engine_application.default.name
}

resource "google_container_cluster" "default" {
  name     = "gke-cluster"
  location = "us-central1-a"
  initial_node_count = 1
  node_config {
    machine_type = "e2-medium"
  }
  master_auth {
    username = "admin"
  }
  network = "default"
}

resource "google_dns_managed_zone" "default" {
  name     = "my-zone"
  dns_name = "example.com."
  description = "My DNS zone"
  project = "abc"
}
