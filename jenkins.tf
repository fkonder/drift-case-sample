resource "google_compute_instance" "jenkins_server" {
  name         = "jenkins-server"
  machine_type = "e2-medium"
  zone         = "europe-west1-b"
  tags         = ["jenkins",]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata_startup_script = <<-EOT
      #!/bin/bash
    
      set -e
    
      log() {
          echo -e "\\n\\e[1;34m>>> $1\\e[0m\\n"
      }
    
      log "Updating system and installing Java 21"
      apt-get update
      apt-get install -y fontconfig openjdk-21-jre wget gnupg2
    
      log "Adding Jenkins repository and key"
      wget -q -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
      echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | tee /etc/apt/sources.list.d/jenkins.list > /dev/null
    
      log "Installing Jenkins"
      apt-get update
      apt-get install -y jenkins
    
      log "Enabling and starting Jenkins service"
      systemctl daemon-reexec
      systemctl enable jenkins
      systemctl start jenkins

      #installing terraform
      sudo apt-get update
      sudo apt-get install -y unzip wget
      wget https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_linux_amd64.zip
      unzip terraform_1.6.6_linux_amd64.zip
      sudo mv terraform /usr/local/bin/
      terraform -v
      
    EOT
}
