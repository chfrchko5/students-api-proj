#!/bin/bash

# install git if not present
if which git &> /dev/null; then
    echo "git is present"
else
    sudo apt-get install git -y
fi

# clone the repo of the project
cd /home/vagrant
git clone -b dev https://github.com/chfrchko5/students-api-proj.git
sudo chown -R vagrant:vagrant students-api-proj/
# FOR TESTING
# cd /home/vagrant/students-api-proj
#git checkout dev