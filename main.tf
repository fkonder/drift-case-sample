terraform {
  backend "gcs" {
    bucket  = "fkonder-drift-case"
    prefix  = "drift-detect-case/terraform/state"
  }
}

provider "google" {
  project = "fkonder"
  region  = "europe-west1"
}

resource "google_compute_instance" "example" {
  name         = "example-instance"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
}