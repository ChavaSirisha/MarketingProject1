sudo apt update
sudo apt upgrade -y

#Jenkins Installation

sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo apt install openjdk-17-jdk -y
sudo apt-get install jenkins -y
sudo systemctl enable jenkins
sudo systemctl status jenkins

# add jenkins user in sudoers file
jenkins ALL=(ALL) NOPASSWD:ALL

#Docker Installation

curl https://get.docker.com | bash
sudo usermod -aG docker jenkins
newgrp docker
sudo systemctl enable docker
#######################
sudo systemctl stop jenkins
sudo systemctl start jenkins

######Start SonarQube as Docker Container################
mkdir sonar
chmod 777 sonar
docker run -d --name sonar -p 9000:9000 -v /home/ubuntu/sonar:/opt/sonarqube/data \
                                        -v /home/ubuntu/sonar/extension:/opt/sonarqube/extension \
                                        -v /home/ubuntu/sonar/logs:/opt/sonarqube/logs \
                                        sonarqube:lts-community

#Install Aws cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

#switch to jenkins user
sudo su - jenkins

#EKSCTL Install
# for ARM systems, set ARCH to: `arm64`, `armv6` or `armv7`
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
# (Optional) Verify checksum
curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | grep $PLATFORM | sha256sum --check
tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz
sudo mv /tmp/eksctl /usr/local/bin

#Kubectl Install
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  chmod +x ./kubectl 
  sudo mv ./kubectl /usr/local/bin

#Install EKS
eksctl create cluster \
  --name demo-cluster \
  --region us-east-1 \
  --version 1.28 \
  --nodegroup-name ng-high-ip \
  --node-type t3.small \
  --nodes 2 \  
  --nodes-min 1 \
  --nodes-max 2 \
  --max-pods-per-node 20 \
  --ssh-access \
  --ssh-public-key AWSHYD  # Replace with your SSH key name

  ---to integrate kubectl with jenkins run below command
  aws eks update-kubeconfig --region us-east-1 --name demo-cluster 

#Plugins Installed
Eclipse Temurin JDK
Pipeline Maven
Sonarqube Scanner
Docker
Docker Pipeline
Kubernetes

kubectl get deploy
kubectl get pods -o wide
kubectl get svc
