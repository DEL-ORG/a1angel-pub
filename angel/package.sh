#!/bin/bash
################# Getting the OS of your machine ################################
echo "First checking the OS...please wait"
sleep 2
OS_NAME=$(cat /etc/*release |grep -w NAME |awk -F'"' '{print$2}')
echo "You are using $OS_NAME operating system...installation next"
sleep 2
################## Defining functions for installation ##########################
 function yum_pkg {
    echo "installing packages for $OS_NAME Operating system"
    ############# list of packages to be installed #########
    packages=(
        curl
        wget
        git 
        gnupg 
        jq 
        openssh-client 
        postgresql-client 
        python3 
        nodejs 
        npm                         
        vim 
        wget 
        pip 
        net-tools 
        iputils-ping 
        awscli 
        default-jre 
        default-jdk 
        maven 
        ufw 
        linux-headers-generic
        golang  
        make 
        ansible 
        python3-pip 
        openssl 
        rsync  
        mariadb-client 
        mysql-client 
        unzip 
        tree   
    )
    sudo yum update -y

    # Install packages
    for package in "${packages[@]}"; do
        echo "Installing $package Please wait ................."
        sleep 3
        sudo yum install -y "$package"
    done
    echo "Package installation completed."
 }

 function apt_pkg {
    echo "installing packages for $OS_NAME Operating system"
    ############# list of packages to be installed #########
    packages=(
        curl
        wget
        git 
        gnupg 
        jq 
        openssh-client 
        postgresql-client 
        python3 
        nodejs 
        npm                         
        vim 
        wget 
        pip 
        net-tools 
        iputils-ping 
        awscli 
        default-jre 
        default-jdk 
        maven 
        ufw 
        linux-headers-generic
        golang  
        make 
        ansible 
        python3-pip 
        openssl 
        rsync  
        mariadb-client 
        mysql-client 
        unzip 
        tree 
        lsb-release
        sshpass  
             
    )
    sudo apt update -y

    # Install packages
    for package in "${packages[@]}"; do
        echo "Installing $package Please wait ................."
        sleep 3
        sudo apt install -y "$package"
    done
    echo "Package installation completed."
 }



if [[ $OS_NAME == "Red Hat Enterprise Linux" ]] || [[ $OS_NAME == "CentOS Linux" ]] || [[ $OS_NAME == "Amazon Linux" ]] 
then
    yum_os
elif [[ $OS_NAME == "Ubuntu" ]] 
then
    apt_os
    apt_software
else
    echo "Sorry...unable to  find packages for your OS"
    exit
fi


      #########  Installling kubectl ####################################################
      curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
      curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
      echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
      install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl &&  \
      chmod +x kubectl  &&  \
      mkdir -p ~/.local/bin && \
      mv ./kubectl ~/.local/bin/kubectl
 
R    ###### Installing kubectx and kubens #################################################
      git clone https://github.com/ahmetb/kubectx /usr/local/kubectx && \
      ln -s /usr/local/kubectx/kubectx /usr/local/bin/kubectx  && \
      ln -s /usr/local/kubectx/kubens /usr/local/bin/kubens

     ######### Installing ##################################################################
      apt-get update &&  apt-get install -y gnupg software-properties-common 
      wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
      gpg --no-default-keyring  --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg  --fingerprint


      echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
      https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
      tee /etc/apt/sources.list.d/hashicorp.list
      apt update &&  apt install  -y terraform



      curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && \  
      chmod 700 get_helm.sh && \
      ./get_helm.sh









   



   
function apt_software {
    ##### Installing aws cli ###########################################
    which aws
    if [ "$?" -eq 0 ]; then
        echo "AWS ClI is intalled already. Noting to do"
    else
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
        unzip awscliv2.zip
        sudo ./aws/install
        rm -rf awscliv2.zip
        rm -rf aws
    fi

    ##### Installing Terraform version 1.0.0 ##############################
    TERRAFORM_VERSION="1.0.0"
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
    mv terraform /usr/local/bin/
    terraform --version
    rm -rf terraform_${TERRAFORM_VERSION}_linux_amd64.zip

    ###### Installing grype  ###############################################
    GRYPE_VERSION="0.66.0"
    wget https://github.com/anchore/grype/releases/download/v${GRYPE_VERSION}/grype_${GRYPE_VERSION}_linux_amd64.tar.gz
    tar -xzf grype_${GRYPE_VERSION}_linux_amd64.tar.gz
    chmod +x grype
    sudo mv grype /usr/local/bin/
    grype version

    ##### Installing Gradle ###############################################
    GRADLE_VERSION="4.10"
    sudo apt install openjdk-11-jdk -y
    wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip
    unzip gradle-${GRADLE_VERSION}-bin.zip
    mv gradle-${GRADLE_VERSION} /opt/gradle-${GRADLE_VERSION}
    /opt/gradle-${GRADLE_VERSION}/bin/gradle --version

    ##### Installing kubectl ###############################################
    sudo curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.17.9/2020-08-04/bin/linux/amd64/kubectl 
    sudo chmod +x ./kubectl 
    sudo mv kubectl /usr/local/bin/

    ####### INSTALL KUBECTX AND KUBENS ######################################
    sudo wget https://raw.githubusercontent.com/ahmetb/kubectx/master/kubectx 
    sudo wget https://raw.githubusercontent.com/ahmetb/kubectx/master/kubens 
    sudo chmod +x kubectx kubens 
    sudo mv kubens kubectx /usr/local/bin

    #######  Install Helm 3 ################################################
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
    sudo  chmod 700 get_helm.sh
    sudo ./get_helm.sh
    sudo helm version

    ####### Install Docker Coompose ########################################
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    docker-compose --version

    ######## TERRAGRUNT INSTALLATIN  ########################################
    TERRAGRUNT_VERSION="v0.38.0"
    sudo wget https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 
    sudo mv terragrunt_linux_amd64 terragrunt 
    sudo chmod u+x terragrunt 
    sudo mv terragrunt /usr/local/bin/terragrunt
    terragrunt --version

    ######## Installing Packer  #############################################
    sudo wget https://releases.hashicorp.com/packer/1.7.4/packer_1.7.4_linux_amd64.zip -P /tmp
    sudo unzip /tmp/packer_1.7.4_linux_amd64.zip -d /usr/local/bin
    chmod +x /usr/local/bin/packer
    packer --version

    ######## Installing Docker #############################################
    sudo apt-get remove docker docker-engine docker.io containerd runc -y
    sudo apt-get update
    sudo apt-get install \
        ca-certificates \
        #curl \
        #gnupg \
        #lsb-release
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    sudo apt-get update
    sudo apt install docker-ce docker-ce-cli containerd.io -y
    sudo systemctl start docker
    sudo systemctl enable docker
}






