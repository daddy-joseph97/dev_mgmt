#!/bin/bash
# Script to setup the environment and system for development
# Uses separate files for packages, instructions, environment vars, etc
# NOTE: no sanity checks in place, it just blissfully installs and brutally
# assumes it knows best... for now
# also, there is sadly a need for a lot of complexity for security reasons
# and just basic sanity with BASH regarding resolving the ACTUAL path
# the script run is in, see http://stackoverflow.com/a/246128 for details
# but here we will just make assumptions for now
# also assuming an OS that uses coreutils thus use of realpath
# besides, we are already assuming Ubuntu here... yes, yes I know, that
# is something to fix
sudo apt-get install realpath

REAL_PATH=$(realpath $0)
REAL_BASE_DIR=$(dirname $REAL_PATH)
cd ${REAL_BASE_DIR}
source ../functions.sh

BACKUP_FILES="$HOME/.bashrc
$HOME/.bash_aliases"

for trgt in $BACKUP_FILES
do
	copy_smrt "$trgt" "$HOME/backup/"
done

# test if this is needed since exec used
#newgrp devs

cd ~/dev-code_repos/dev_mgmt/linux/base_environment
cat bashrc_stub >> ~/.bashrc
cp bash_myaliases ~/.bash_myaliases
cp bash_myschtuff ~/.bash_myschtuff
. ~/.bashrc

#newgrp devs

# for now, just one at a time ('module') setup, not concatenated
for base_file in setup-base setup-mmedia_dev setup-python
do
	. "$base_file"
	sudo apt-get install -y $PKGS
done

# XXX put this stuff in the setup-python file
mkdir ~/Downloads/bootstrappers
cd ~/Downloads/bootstrappers
# get-pip installs setuptools, thanks to Kevin for pointing out what was
# painfully obvious for quite some time!
#curl -O https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py
#python ez_setup.py --user

curl -O https://raw.github.com/pypa/pip/master/contrib/get-pip.py
# FIXME while not broke, research needed to see if user mode installation
# works cleanly now ('user mode' ==> local, non system wide)
#python get-pip.py --user
sudo python get-pip.py

# same FIXME as above regarding user mode installation
#pip install --install-option="--user" virtualenvwrapper
sudo pip install virtualenvwrapper
. ~/.bashrc

# in case you are wondering, pythonz is designed for user mode / local install
curl -kLO https://raw.github.com/saghul/pythonz/master/pythonz-install
chmod u+x pythonz-install
./pythonz-install

#. ~/.bashrc
#pythonz install 2.7.5
