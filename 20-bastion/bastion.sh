#!/bin/bash
USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1 )
LOG_FILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log


R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e " $2  $R Failure.... $N"
        exit 1
    else
        echo -e " $2 $G Success.... $N"
    fi

}
VALIDATE(){
    if [ $USERID -ne 0 ]
    then 
        echo -e " $R You should have root access.... $N"
        exit 1
    else
        echo -e " $G Success You are a root user.... $N"
    fi
}


# docker installation 
dnf -y install dnf-plugins-core
dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user
VALIDATE $? "Docker Insstallation"

# eksctl 
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
mv /tmp/eksctl /usr/local/bin
eksctl version
VALIDATE $? "eksctl installation"

# Kubectl
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.30.14/2025-09-19/bin/linux/amd64/kubectl
sudo chmod +x ./kubectl
sudo mv kubectl /usr/local/bin/kubectl
VALIDATE $? "kubectl installation"

# Helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/refs/heads/main/scripts/get-helm-3
chmod +700 get_helm.sh
./get_helm.sh
VALIDATE $? "Helm installation"

# Mysql installation
dnf install mysql -y
VALIDATE $? "mysql installation"

# kubens installation
git clone https://github.com/ahmetb/kubectx.git /opt/kubectx
mv /opt/kubectx/kubens /usr/local/bin/kubens
VALIDATE $? "kubens installation"


