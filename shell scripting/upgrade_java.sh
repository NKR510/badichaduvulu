#!/bin/bash

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to get the installed Java version
get_java_version() {
    if type -p java > /dev/null; then
        java_version=$(java -version 2>&1 | awk -F[\".] 'NR==1 {print $2}')
        echo "$java_version"
    else
        echo "0" # Java is not installed
    fi
}

# Get the current Java version
current_version=$(get_java_version)

# Check if Java is installed and determine action
if [ "$current_version" -eq 0 ]; then
    echo -e "${RED}Java is not installed.${NC} ${BLUE}Installing the latest version...${NC}"
    sudo yum update -y
    sudo yum install -y java-11-openjdk-devel
    echo -e "${GREEN}Java has been installed.${NC}"
elif [ "$current_version" -le 8 ]; then
    echo -e "${YELLOW}Java version is $current_version.${NC} ${BLUE}Upgrading to the latest version...${NC}"
    sudo yum update -y
    sudo yum install -y java-11-openjdk-devel
    echo -e "${GREEN}Java has been upgraded.${NC}"
else
    echo -e "${GREEN}Java version is $current_version. No upgrade needed.${NC}"
fi
