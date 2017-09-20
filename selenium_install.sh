#!/bin/bash

#Variables
GREEN='\033[0;32m'
NC='\033[0m' # No Color

#Need to run this script as a root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root (with sudo command)"
  exit
fi

#Update packages and install required ones
apt-get -y update
apt-get install -y unzip

#Install Java runtime
if [ ! -n `which java` ]; 
    then apt-get install -y default-jre
fi

#Download and install Chrome web driver
VERSION="$(uname -m)"

if [ "${VERSION}" == "x86_64:" ]; then
	CHR_DRIVER="https://chromedriver.storage.googleapis.com/2.32/chromedriver_linux32.zip"
else
	CHR_DRIVER="https://chromedriver.storage.googleapis.com/2.32/chromedriver_linux64.zip"
fi

TEMP_PATH="/tmp/chromedriver"
mkdir $TEMP_PATH && pushd $TEMP_PATH
wget $CHR_DRIVER -P $TEMP_PATH
unzip ${TEMP_PATH}/chromedriver_linux64.zip
sudo mv -f ./chromedriver /usr/local/bin/chromedriver
sudo chown root:root /usr/local/bin/chromedriver
sudo chmod 0755 /usr/local/bin/chromedriver

printf "${GREEN}Installed Chrome web driver.\n${NC}"

#download and install selenium server
SELENIUM_VERSION="3.5.3"
SELENIUM_JAR_FILE=selenium-server-standalone-$SELENIUM_VERSION.jar
wget http://selenium-release.storage.googleapis.com/$(echo $SELENIUM_VERSION | cut -d'.' -f-2)/$SELENIUM_JAR_FILE -P $TEMP_PATH
mv -f $TEMP_PATH/$SELENIUM_JAR_FILE /usr/local/bin
chown root:root /usr/local/bin/$SELENIUM_JAR_FILE
chmod 755 /usr/local/bin/$SELENIUM_JAR_FILE

printf "${GREEN}Installed Selenium server.\n${NC}"

# Get back to current directory
popd

# Setup init script
cp ./selenium /usr/local/bin/selenium
chmod +x /usr/local/bin/selenium

printf "${GREEN}Installation is successful.\n${NC}"
