#!/usr/bin/env bash

#Install Docker Compose
apt install docker-compose -y

#Clone Steven Thellen's (thells176) repository inside the Concourse CI VM and run the install script
git clone https://github.com/thells176/Install-concourseci.git
cd Install-concourseci
./Do_install.sh 192.168.99.102

