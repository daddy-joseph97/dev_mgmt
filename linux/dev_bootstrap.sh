#!/bin/sh
# initial bootstrap script to setup the environment and system for development
# this file is downloaded directly from:
#   https://raw.github.com/daddy-joseph97/dev_mgmt/master/linux/base_environment/dev_bootstrap.sh
# and pulls down the rest and setups accordingly
# NOTE: no sanity checks in place, it just blissfully installs and brutally
# assumes it knows best... for now
PKGS="git"
PATHS=(/var/local/forge/dump
/var/local/forge/non_proj_src
/var/local/forge/py_virtenvs
/var/local/forge/others_src
/var/local/forge/virtenv_proj_src)
SYMLINKS=(~/dev_dump
~/dev-mysrc
~/dev-pyvenvs
~/dev-oss_src
~/dev-venv_repos)

sudo apt-get update
sudo apt-get install $PKGS

sudo groupadd devs
sudo usermod -a -G devs `whoami`
newgrp devs

# create dirs and symlinks
for idx in ${#PATHS[*]}
do
	sudo mkdir -p ${PATHS[$idx]}
	sudo chmod g+w ${PATHS[$idx]}
	sudo chown :devs ${PATHS[$idx]}
	ln -s ${PATHS[$idx]} ${SYMLINKS[$idx]}
done

# backup dir (if not using a home profile / custom etc-keeper like app
sudo mkdir -p /var/local/backup/system_only
sudo mkdir -p /var/local/backup/users/`whoami`
# yeah, many evil assumptions...
sudo chown `whoami`:`whoami` /var/local/backup/users/`whoami`
ln -s /var/local/backup/users/`whoami` ~/backup

cd ~/dev-mysrc/
git clone https://github.com/daddy-joseph97/dev_mgmt.git
cd ~/dev_mgmt/linux/base_environment
exec setup-dev_script.sh
