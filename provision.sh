#!/usr/bin/env bash

sudo apt-get update
mkdir digitalrebar
git clone https://github.com/digitalrebar/digitalrebar
cd digitalrebar/deploy

# The repo version of ubuntu 16.04 is out of date, so we have to update it
sed -i 's/ubuntu-16.04.2-server-amd64.iso/ubuntu-16.04.3-server-amd64.iso/' compose/config-dir/provisioner/bootenvs/ubuntu-16.04.json
sed -i 's/737ae7041212c628de5751d15c3016058b0e833fdc32e7420209b76ca3d0a535/a06cd926f5855d4f21fb4bc9978a35312f815fbda0d0ef7fdc846861f4fc4600/' compose/config-dir/provisioner/bootenvs/ubuntu-16.04.json
git config user.name "Kirk Winkelman"
git config user.email "kirk.winkelman@ibm.com"
git add compose/config-dir/provisioner/bootenvs/ubuntu-16.04.json
git commit -m "committing the fix so the following ansible doesn't fail"

export IPA=$(ip -4 addr | grep inet | grep -v "host lo" | awk '{print $2}')
sudo ./run-in-system.sh --deploy-admin=local --access=host --admin-ip=$IPA
