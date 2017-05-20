#!/usr/bin/env bash

apt-get update
apt-get upgrade -y

#Download Cloud Foundry CLI
wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | sudo apt-key add -
echo "deb http://packages.cloudfoundry.org/debian stable main" | sudo tee /etc/apt/sources.list.d/cloudfoundry-cli.list

sudo apt-get update

#Install Cloud Foundry CLI
sudo apt-get install cf-cli

#Install Concourse Fly CLI
curl -L https://github.com/concourse/fly/releases/download/v2.5.1-rc.9/fly_linux_amd64 -o fly
chmod +x fly
sudo mv fly /usr/bin/fly 