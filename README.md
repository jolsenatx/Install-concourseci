Vagrant setup of a single Ubuntu jumpbox VM and a single VM that uses Docker Compose to deploy Concourse CI

Jumbox VM:
- Cloud Foundry CLI is installed and configured
- Concourse Fly CLI is installed and configured

Concourse VM:
- Docker Compose is installed
- git clone of repository that auto-installs Concourse CI using docker-compose

To Interact with Concourse CI
- vagrant ssh jumpbox
- switch to root
- fly -t tutorial login -c http://192.168.99.101:8080
	username: concourse
	password: changeme

Sync up Fly:
- fly -t tutorial sync


