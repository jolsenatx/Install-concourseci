#!/bin/bash
# Install JRE & JDK
sudo apt-get install openjdk-7-jre -y
sudo apt-get install openjdk-7-jdk -y

# Download the security key for the Jenkins repository
wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -

# Add the key to the trusted keys for apt-get
sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'

# Update the list of packages
sudo apt-get update

# Install Jenkins
sudo apt-get install jenkins -y

#Install Jenkins Plugins

#Build Pipeline Plugin
echo "jenkins-plugins: Installing plugin: build-pipeline-plugin"
su -l -c "java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080 install-plugin build-pipeline-plugin" jenkins

#Delivery Pipeline Plugin
echo "jenkins-plugins: Installing plugin: delivery-pipeline-plugin"
su -l -c "java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080 install-plugin delivery-pipeline-plugin" jenkins

#Docker Plugin
echo "jenkins-plugins: Installing plugin: docker-plugin"
su -l -c "java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080 install-plugin docker-plugin" jenkins