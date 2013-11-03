#!/bin/sh
# Script to setup the environment and system for development
# Uses separate files for packages, instructions, environment vars, etc
# NOTE: no sanity checks in place, it just blissfully installs and brutally
# assumes it knows best... for now
BACKUP_FILES="~/.bashrc
~/.bash_aliases"

for trgt in $BACKUP_FILES
do
	cp $trgt ~/backup/
done

# test if this is needed since exec used
newgrp devs

cd ~/dev-mysrc/dev_mgmt/linux/base_environment
cat bashrc_stub >> `/.bashrc
cp bash_myaliases ~/.bash_myaliases
cp bash_myschtuff ~/.bash_myschtuff
. `/.bashrc

newgrp devs

# for now, just one at a time ('module') setup, not concatenated
for base_file in setup-base setup-mmedia_dev setup-python
do
	. $base_file
	sudo apt-get install -y $PKGS
done

# XXX put this stuff in the setup-python file
mkdir ~/Downloads/bootstrappers
cd ~/Downloads/bootstrappers
curl -O https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py
python ez_setup.py --user

curl -O https://raw.github.com/pypa/pip/master/contrib/get-pip.py
python get-pip.py --user

curl -kLO https://raw.github.com/saghul/pythonz/master/pythonz-install
chmod u+x pythonz-install
./pythonz-install

. ~/.bashrc
pythonz install 2.7.5
