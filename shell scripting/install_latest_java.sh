#!/bin/bash

# Define color codes
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if yum or dnf is available
if type -p yum > /dev/null; then
    package_manager="yum"
elif type -p dnf > /dev/null; then
    package_manager="dnf"
else
    echo -e "${RED}Neither yum nor dnf is available on this system.${NC}"
    exit 1
fi

# Search for Java packages and pick the latest version
echo -e "${BLUE}Searching for the latest Java packages...${NC}"
latest_java_package=$($package_manager search java | grep -iE 'jdk.*devel' | sort -r | head -n 1 | awk '{print $1}')

if [ -z "$latest_java_package" ]; then
    echo -e "${RED}No Java JDK packages found.${NC}"
    exit 1
fi

echo -e "${YELLOW}The latest Java package found: ${latest_java_package}${NC}"
echo -e "${BLUE}Installing ${latest_java_package}...${NC}"
sudo $package_manager install -y "$latest_java_package"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Successfully installed ${latest_java_package}.${NC}"
else
    echo -e "${RED}Failed to install ${latest_java_package}.${NC}"
fi
