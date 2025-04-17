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

