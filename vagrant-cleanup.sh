#!/bin/bash
vagrant destroy -f
vagrant box remove bento/ubuntu-16.04
vagrant box remove bento/ubuntu-16.10-i386
vagrant box remove ubuntu/xenial64