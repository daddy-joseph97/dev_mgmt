#!/bin/bash
# initial bootstrap script to setup the environment and system for development
# this file is downloaded directly from:
#   https://raw.github.com/daddy-joseph97/dev_mgmt/master/linux/base_environment/dev_bootstrap.sh
# and pulls down the rest and setups accordingly
# NOTE: no sanity checks in place, it just blissfully installs and brutally
# assumes it knows best... for now
#PKGS="git mercurial"
PATHS=(/var/local/forge/dump
/var/local/forge/py_virtenvs
/var/local/forge/code_repos)
SYMLINKS=(~/dev-dump
~/dev-py_venvs
~/dev-code_repos)

#sudo apt-get update
#sudo apt-get install $PKGS

#sudo groupadd devs
#sudo usermod -a -G devs `whoami`
#newgrp devs

# create dirs and symlinks
for (( idx=0; idx<${#PATHS[*]}; idx++ ))
do
	echo -e "Debug values.\n\t idx: $idx"
	echo -e "\t 'PATHS' value at index $idx: ${PATHS[$idx]}"
	echo -e "\t 'SYMLINKS' value at index $idx: ${SYMLINKS[$idx]}\n\n"
	if [ ! -d ${PATHS[$idx]} ]
	then
		sudo mkdir -p ${PATHS[$idx]}
    fi
	sudo chmod g+w ${PATHS[$idx]}
	sudo chown :devs ${PATHS[$idx]}
	if [ ! -d ${SYMLINKS[$idx]} ]
	then
		ln -sf ${PATHS[$idx]} ${SYMLINKS[$idx]}
	fi
done

# backup dir (if not using a home profile / custom etc-keeper like app
sudo mkdir -p /var/local/backup/system_only
sudo mkdir -p /var/local/backup/users/`whoami`
# yeah, many evil assumptions...
sudo chown `whoami`:`whoami` /var/local/backup/users/`whoami`
src_file=/var/local/backup/users/`whoami`
trgt_link=~/backup
if [ -e $src_file ] && [ ! -e $trgt_link ]
then
	ln -sf /var/local/backup/users/`whoami` ~/backup
fi

sudo apt-get update && sudo apt-get --assume-yes install git
if [ ! -e ~/dev-code_repos/dev_mgmt ]
then
	cd ~/dev-code_repos/
	git clone https://github.com/daddy-joseph97/dev_mgmt.git
fi
cd ~/dev-code_repos/dev_mgmt/linux/base_environment
#exec bash setup-dev_script.sh
echo "Initial bootstrap completed, run ~/dev-code_repos/dev_mgmt/linux/base_environment/setup-dev_script.sh for next steps."
