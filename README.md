WORK IN PROGRESS

Install-concourseci

This is a quick and automated setup of concourseci-compose that works well with the 'starkandwayne councourse-tutorail'
The tutorial is located at https://github.com/starkandwayne/concourse-tutorial

Files:
 * Do_install.sh
 * USEdocker-compose.yml
 * Dockerfile
 * fly_linux_amd64
 * README.md
 
 To Use:  
 1) clone this git repo to your system / VM
 2) cd to directory
 3) run    ./Do_install.sh
 
 Note: This was constructed to run as 'root' on an ubuntu 16 VM. Your mileage may vary...
 
 It's kinda that simple...
The script will check environment and requirements and ask for the IP-Address to use to connect to concourse.
 
 As for requirements...
 1) docker-compose
 2) docker
 3) openssh
 

 It is our hope that you find this easy to get started and explore the value that a CI pipeline can deliver.
 
 Enjoy!
