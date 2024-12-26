#!/bin/bash

# Define color codes
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Variables
JENKINS_LIB_DIR="/usr/lib/jenkins"
BACKUP_DIR="/backup/jenkins_$(date +%F_%T)"
JENKINS_WAR_URL="https://get.jenkins.io/war-stable/2.414.1/jenkins.war" # Replace with the desired version URL

# Function to check for errors
check_error() {
    if [ $? -ne 0 ]; then
        echo -e "${RED}An error occurred. Exiting.${NC}"
        exit 1
    fi
}

# Step 1: Take backup of required files
echo -e "${BLUE}Creating backup directory at ${BACKUP_DIR}...${NC}"
mkdir -p "$BACKUP_DIR"
check_error

echo -e "${YELLOW}Backing up Jenkins configuration and data...${NC}"
cp -r /var/lib/jenkins/* "$BACKUP_DIR/"
check_error

# Step 2: Take backup of the jenkins.war file
echo -e "${YELLOW}Backing up the current jenkins.war file...${NC}"
cp "$JENKINS_LIB_DIR/jenkins.war" "$BACKUP_DIR/"
check_error

# Step 3: Rename the current jenkins.war file
echo -e "${BLUE}Renaming the current jenkins.war to jenkins.war.bak...${NC}"
mv "$JENKINS_LIB_DIR/jenkins.war" "$JENKINS_LIB_DIR/jenkins.war.bak"
check_error

# Step 4: Download the new jenkins.war file
echo -e "${YELLOW}Downloading the new jenkins.war from ${JENKINS_WAR_URL}...${NC}"
wget -O "$JENKINS_LIB_DIR/jenkins.war" "$JENKINS_WAR_URL"
check_error

# Step 5: Verify the new jenkins.war file
if [ -f "$JENKINS_LIB_DIR/jenkins.war" ]; then
    echo -e "${GREEN}Successfully downloaded and replaced the jenkins.war file.${NC}"
else
    echo -e "${RED}Failed to download the new jenkins.war file. Restoring the backup...${NC}"
    mv "$JENKINS_LIB_DIR/jenkins.war.bak" "$JENKINS_LIB_DIR/jenkins.war"
    exit 1
fi

# Step 6: Restart Jenkins
echo -e "${YELLOW}Restarting Jenkins service...${NC}"
sudo systemctl restart jenkins
check_error

echo -e "${GREEN}Jenkins upgrade process completed successfully!${NC}"
