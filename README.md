# Project Title

Multi-VM configuration using Vagrant that comprises of the following:
- One jumpbox/development Xenial64 VM with the Cloud Foundry and Concourse FLY CLI's installed
- One VM that installs Concourse CI using Docker Compose 

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

- Virtualbox
- Vagrant

### Installing

How to get the environment up and running

Clone this repository to your local machine

```
git clone https://github.com/jolsenatx/install-concourseci
```

cd into the cloned repository and vagrant up

```
vagrant up --provider virtualbox
```

After the provision is complete, ssh into the jumpbox which will be used to interact with Concourse and Cloud Foundry (if desired)

```
vagrant ssh jumpbox
```

Once you've ssh'd into the jumbox VM, you will want to switch to root

Use the Fly CLI to login to the Concourse VM

```
fly -t tutorial login -c http://192.168.99.101:8080
```
You will be prompted for a username and password
Username:
```
concourse
```
Password:
```
changeme
```
The last step is to Sync up Fly by running the following command:
```
fly -t tutorial sync
```


End with an example of getting some data out of the system or using it for a little demo

## Running the tests

Explain how to run the automated tests for this system

### Break down into end to end tests

Explain what these tests test and why

```
Give an example
```

### And coding style tests

Explain what these tests test and why

```
Give an example
```

## Parting Thoughts

* Thank you to Steven Thellen (thells176) for writing the script that installs Concourse
* And I know you are wondering why not just use the official Concourse Vagrant box? 
1. Because that would have been too easy
2. I plan on expanding this project to include additional tools and capabilities to help better understand CI/CD process on a local environment.  
