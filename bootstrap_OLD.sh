#!/usr/bin/env bash

apt-get update
apt-get upgrade -y

#Download Cloud Foundry CLI
wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | sudo apt-key add -
echo "deb http://packages.cloudfoundry.org/debian stable main" | sudo tee /etc/apt/sources.list.d/cloudfoundry-cli.list

sudo apt-get update

#Install Cloud Foundry CLI
sudo apt-get install cf-cli

#Install Docker Compose
apt install docker-compose -y

#Clone Steven Thellen's (thells176) repository inside the Concourse CI VM and run the install script
git clone https://github.com/thells176/Install-concourseci.git
cd Install-concourseci
./Do_install.sh 192.168.99.101

