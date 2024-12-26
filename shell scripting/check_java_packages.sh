#!/bin/bash

# Define color codes
BLUE='\033[0;34m'
GREEN='\033[0;32m'
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

# Search for Java packages
echo -e "${BLUE}Searching for available Java packages...${NC}"
$package_manager search java | grep -i jdk

echo -e "${GREEN}Above are the available Java packages.${NC}"
