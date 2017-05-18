#!/bin/bash
#
#  Script to install Concourse with Docker-compose
#
#####################################################
#
# Vars
#
########
#
 UDCYML=USEdocker-compose.yml
#
EX=0
#
##################
# Functions
clnz ()
{
   if test -f /tmp/z
   then
        rm /tmp/z
   fi
}
#################
#
# Verify envirorment
#
##############
#
# Test docker n docker compose installed
#
#########
#
 echo "  "
 echo " ######################################  "
 echo "   Starting installation of Concourse"
 echo " ######################################  "
 echo "  "
sleep 2
 echo " ######################################  "
 echo "   ...testing requirementst..."
 echo " ######################################  "
sleep 1
#
##################
docker-compose version &> /tmp/z 
DCinst=`grep -wc version /tmp/z`
if test $DCinst -eq 0
then
    echo " docker-compose -  needs to be installed!"
    echo " on ubuntu Execute: "
    echo "              apt install docker-compose"
    echo "  "
    echo " or similar to install on current platform.  "
    EX=1
fi
#
docker version &> /tmp/z 
DCk=`grep -wc version /tmp/z`
if test $DCk -eq 0
then
    echo "  "
    echo " docker  -  needs to be installed!"
    echo " on ubuntu Execute: "
    echo "              apt install docker.io"
    echo "  "
    echo " or similar to install on current platform.  "
    echo "  "
    EX=1
fi
#
# check for ssh-keygen
#
which ssh-keygen > /tmp/z
KG=`cat /tmp/z | wc -l`
if test $KG -eq 0
then
    echo "  "
    echo " openssh  -  needs to be installed!"
    echo " on ubuntu Execute: "
    echo "              apt install openssh-server"
    echo "  "
    echo " or similar to install on current platform.  "
    echo "  "
    EX=1

fi
#
###################
if test $EX -eq 1
then
     echo "  "
     echo " Try again when you are ready..."
     echo " Thanks "
     echo "  "
   clnz
  exit
fi
#
#########
#
# test for keys
#
if test -f /keys/web/authorized_worker_keys
then
    echo " "
    #echo "   Local /keys dir found..."
    #ls /keys/*
    echo "  "
    echo " ##################################### "
    echo "   Local ssh keys already created... "
    echo " ##################################### "
else
    echo "  "
    echo " Creating local /keys for concourse...."
    echo "  "
    mkdir -p /keys/web /keys/worker
    ssh-keygen -t rsa -f /keys/web/tsa_host_key -N '' && \
  ssh-keygen -t rsa -f /keys/web/session_signing_key -N '' && \
  ssh-keygen -t rsa -f /keys/worker/worker_key -N '' && \
  cp /keys/worker/worker_key.pub /keys/web/authorized_worker_keys && \
  cp /keys/web/tsa_host_key.pub /keys/worker
fi
#
##########################
#
# Edit USEdocker-compose.yml
#
if test -f ${UDCYML}
then
     echo "  "
     echo " ###################################################  "
     echo "  Begin configuration of 'concourse' environemnt... "
     echo " ###################################################  "
     echo "  "
else
    echo "  "
    echo "  USEdocker-compose.yml file MIA.  "
    echo "  files should be loaded with git clone "
    echo "  "
    echo "  Resolve and try again "
    echo "  "
fi
#
 echo "  "
 echo "  Please input the IP-address to be used to connect with	"
 echo "  the concourse web interface (i.e.  192.168.22.22) "
   read -p '=> ' CIP 

  if [ ${CIP}X = 'X' ]
  then
       echo "Sorry, can not be blank. Please use vailid IP-address"
       echo "  "
      clnz 
     exit
  else
     goodip=`ping -c 1 ${CIP} | grep -wc icmp_seq=1`
     if test $goodip -ge 1
     then
          echo "  "
          echo " Good IP: Using ${CIP} for concourse web"
          echo "  "
          echo " Collecting DNS IP . . .  "
          echo "  "
          DIP=`nslookup ${CIP} | grep Server: | awk '{ print $2 }'`
          echo "  Using:  ${DIP}  as DNS"
          echo "  "
          echo " ################################"
          echo "  Generating 'docker-compose.yml "
          echo " ################################"
          cat ${UDCYML} | sed s/XXXX/${CIP}/ > /tmp/zd
          cat /tmp/zd | sed s/YYYY/${DIP}/ > docker-compose.yml
    if test -f /tmp/zd
    then
        rm /tmp/zd
    fi
#
#  create ENV file
  export DOCKERHOST=${CIP} 
  export CONCOURSE_EXTERNAL_URL=http://${CIP}:8080
  echo "export DOCKERHOST=${CIP} " > DOCKERENV
  echo "export CONCOURSE_EXTERNAL_URL=http://${CIP}:8080 " >> DOCKERENV
 source DOCKERENV

         sleep 1
          echo "  "
          echo " #############################################"
          echo "  Starting 'concourse' with docker-compose..."
          echo " #############################################"
         sleep 1
#
# Code from Jeff Olsen
    docker volume create --name concourse-db
    docker volume create --name concourse-web-keys
    docker volume create --name concourse-worker-keys
    DOCKERHOST=${CIP} docker-compose up -d
#
############################
#
#  Testing . . . 
TESTDCUP=0
 sleep 2
  echo "  "
  echo " . . . testing containers up . . .  "
  echo "  "
docker ps > /tmp/z
webline=`grep web /tmp/z` 
workerline=`grep web /tmp/z` 
dbline=`grep web /tmp/z` 
Tweb=`echo $webline | awk '{ print $7 }'`
Tworker=`echo $workerline | awk '{ print $7 }'`
Tdb=`echo $dbline | awk '{ print $7 }'`

    if [ ${Tweb} = "Up" ]
    then
         echo " Concourse Web runnning..."
    else
         TESTDCUP=2
    fi
    if [ ${Tworker} = "Up" ]
    then
         echo " Concourse Worker runnning..."
    else
         TESTDCUP=2
    fi
    if [ ${Tdb} = "Up" ]
    then
         echo " Concourse Database runnning..."
    else
         TESTDCUP=2
    fi

    if test $TESTDCUP -ge 1
    then
         echo " "
         echo " Problem starting up... Trouble shooting required."
         echo " #################################################"
         cat /tmp/z
         echo " #################################################"
         echo " Sorry and best of luck..."
        clnz
        exit
    else
#
#  With councourse running, will install 'fly' to connect
#
which fly > /tmp/z
Tfly=`cat /tmp/z | wc -l`

 if test $Tfly -eq 0
 then
      # fly not installed, copying from repo dist
      Fdest=`echo $PATH | awk -F: '{ print $1 }'`
      if test -f fly_linux_amd64
      then
           cp fly_linux_amd64 ${Fdest}/fly
      else
           echo "  " 
           echo "  'fly' executable is MIA  " 
           echo "  Will need to download and install ..."
      fi
  fi
#####################
         echo " "
         echo " #################################################"
         echo " "
         echo "    Concourse appears to be running"
         echo " "
         echo "    DOCKERENV files created. "
         echo "        Containing ENV you might need"
         echo "         =>  source DOCKERENV"
         echo " "
         echo "  binary 'fly' installed ... "
         echo "        run:  fly -t tutorial login -c http://${CIP}"
         echo " uname: concourse "
         echo " passwd: changeme "
         echo " "
         echo "  And attempt to connect to site remote via browser"
         echo " "
         echo "     http://${CIP}:8080 "
         echo " "
         echo "  and login using information above"
         echo " "
         echo " "
         echo "   *** BEST OF LUCK *** "
         echo " "
         echo " #################################################"
         echo " "
  
     fi
#
#####################
     else
          echo "  "
          echo "  Sorry, but can not reach IP-address "
          echo "  Please try again with valid IP"
          echo "  "
         clnz
         exit
     fi
  fi
#
###################
#
#  Done
 clnz
#
#########



