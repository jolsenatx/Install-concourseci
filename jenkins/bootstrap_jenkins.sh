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