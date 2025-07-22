#!/bin/bash

echo "---------- This will install Jennkins RHEL / Ubuntu based on OS---------------"
osfound=0
os=$(awk -F '=' '$1 == "NAME" { gsub(/"/, "", $2); print $2 }' /etc/os-release)
if [[ $os == 'Ubuntu' ]]; then
	echo "-----------------This is Ubuntu system--------------------"

	echo "*************************** STEP 1:Updating the system  *******************"
		sudo apt-get update -y

	echo "*************************** STEP 2: Adding Jnekins to apt list ***************** "
		sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
		echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
		sudo apt-get update -y

	echo "**************************** STEP 3: Installing Java ****************************** "
		sudo apt install -y fontconfig openjdk-21-jre	
		java -version

	echo "**************************** STEP 4: Installing Java ***************************"
		sudo apt install -y jenkins
		osfound=1

elif [[ $os == "Red Hat Enterprise Linux" ]]; then
	echo "-----------------This is Red Hat Enterprise Linux system--------------------"

        echo "************************ STEP 1: Updating the system  *******************"
                sudo yum upgrade

        echo "************************ STEP 2: Adding Jnekins to apt list ***************** "
		sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
		sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
		sudo yum upgrade	
	
	echo "************************** STEP 3: Installing Java ****************************** "
                sudo apt install -y fontconfig openjdk-21-jre
                java -version

        echo "************************** STEP 4: Installing jenkins ****************************** "
                sudo apt install -y jenkins
		sudo systemctl daemon-reload
		osfound=1
else
	echo "----------------------- Not Ubuntu / RED Hat Enterprise Linux -----------------------"

fi
if [[ $osfound == 1 ]]; then
	echo "************************** STEP 5: Starting and enabling the jenkins service *************** "
                sudo systemctl start jenkins
                sudo systemctl enable jenkins

        echo " Bellow is the intial Admin Password - copy the password and use it login "
                sudo cat /var/lib/jenkins/secrets/initialAdminPassword

        echo " ******************************** Enable the jenkins default port 8080 and additional port 50000 ******************"
        echo " ******************************** After enabling use the bellow URL to go to jenkins ***********************8******"
        url=$(curl -s https://ifconfig.me)
        echo "http://$url:8080/"
fi
