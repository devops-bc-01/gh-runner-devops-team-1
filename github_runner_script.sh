#!/bin/bash

## Variables de colores
COLOR_VERDE=$(tput setaf 2)
COLOR_AMARILLO=$(tput setaf 3)
COLOR_AZUL=$(tput setaf 4)
COLOR_BLANCO=$(tput setaf 7)

#Args
RUNNER_URL=$1
RUNNER_HASH=$2
RUNNER_REPO=$3
RUNNER_TOKEN=$4
RUNNER_NAME=$5

FILE=actions-runner-linux-x64-2.296.2.tar.gz

#cd actions-runner || exit

setNormalColor(){
    printf "%s" "$COLOR_BLANCO"
}

message(){
    printf "\n******************************************\n%s" "$COLOR_AMARILLO"
    echo "$1"
    echo "******************************************"
    setNormalColor
}

# Step 0
check_service(){
    message "CHECK SERVICE STATUS"
    string="$(systemctl list-units --full -all | grep 'actions.runner')"
    subString='inactive'

    echo "$string"

    if [[ -n "$string" && "$string" != *"$subString"* ]]; then
        echo "Service active."
        return 1
    else
        echo "Up's service inactive."
        return 0        
    fi
}

# Step 1
create_actions_folder(){
    if [ ! -d "actions-runner" ]; then
        message "1. CREATING 'actions-runner' FOLDER"
        mkdir -p actions-runner
    else
        message "1. 'actions-runner' FOLDER ALREADY CREATED"
    fi
}

# Step 0
entering_folder(){
    if cd actions-runner; then 
        echo "Ok: Entering 'actions_runner folder'"; 
    else 
        echo "Fail: Actions folder doesn't exist" exit; 
    fi
}

download_runner_package(){
    message "RUNNER PACKAGE CHECKING"
    if test -f "$FILE"; then
        echo "$FILE already exists. Escaping download"
    else
        echo "$FILE doesn't exists. Downloading..."
        curl -o actions-runner-linux-x64-2.296.2.tar.gz -L "$RUNNER_URL"
    fi
}

hash_validation(){
    message "HASH VALIDATION"
    echo "$RUNNER_HASH  actions-runner-linux-x64-2.296.2.tar.gz" | shasum -a 256 -c
}

extract_installer(){
    message "EXTRACTING FILE: $FILE"
    tar xzf ./"$FILE"
}

start_configuration(){
    message "CONFIGURATION OF: $FILE"
    #export RUNNER_ALLOW_RUNASROOT="1"
    echo "Configuring runner with...."
    echo ./config.sh --unattended \
        --name "$RUNNER_NAME" \
        --url "$RUNNER_REPO" \
        --token "********************************"
    # Config command
    ./config.sh --unattended \
        --name "$RUNNER_NAME" \
        --url "$RUNNER_REPO" \
        --token "$RUNNER_TOKEN"
}

check_service_file(){
    message "CHECK SERVICE FILE"
    svcFile=./svc.sh
    if test -f "$svcFile"; then
        echo "$svcFile exists. Continuing...."
        return 1 # Correct installation
    else
        echo "$svcFile doesn't exists. Something went wrong. Exiting..."
        return 0 # Error
    fi

}

install_service(){
    message "INSTALLING SERVICE"
    sudo ./svc.sh install
}

start_service(){
    message "START SERVICE"
    sudo ./svc.sh start
}

installation_process(){
    download_runner_package
    hash_validation
    extract_installer
    start_configuration
    install_service
    start_service
}

main(){
    check_service
    if [ "$?" != 1 ]; then
        create_actions_folder
        entering_folder
        
        check_service_file
        if [ "$?" == 1 ]; then
            echo "File presente. Trying to start..."
            start_service
        else
            installation_process
        fi

        check_service
        if [ "$?" != 1 ]; then
            echo "Service still inactive. Trying installation..."
            installation_process
        fi
        
    else
        echo "Service is up and running"
        echo "Nothing to do here :)"
    fi
}

main