#!/usr/bin/env bash
#
# Title              :setupMailServer.sh
# Description        :install and set up a basic email server
#                       and provide an easy to use mutt-wraper
# Author             :Steven Barber
# Email              :steven.barber@eagles.usm.edu
# Date               :01-23-2016
# Version            :0.1
# Usage              :bash setupMailServer.sh
# Notes              :Only run 1 time without modifying
# bash_version       :4.3.11(1)-release
#========================================================================

setDefaults() {
    setROOT

    EMAIL_CMD=email

    HOME_LINK=~/.email

    EMAIL_CONFIG_FILE=$ROOT_DIR/conf/install.conf

    USR_BIN=/usr/bin

    EMAIL_SCRIPT=$ROOT_DIR/bin/email.sh

    APP_DIR=/usr/share/Email

    START_SERVER=""

    NODE_INSTALL_SCRIPT=$ROOT_DIR/init/t # node.sh
}

setROOT() {
    if [[ ${0%/$(basename $BASH_SOURCE)} == *"install"* ]]; then
        ROOT_DIR=$PWD
    else
        ROOT_DIR=${0%/$(basename $BASH_SOURCE)}
    fi

    ROOT_DIR=$(readlink -f $ROOT_DIR)
    ROOT_DIR=${ROOT_DIR%"/init"}
}

defineSetup() {
cat <<choices

    1)  Install package onto host machine
        -   This option will install files in
            /usr/bin/email
            /usr/share/Email
            $HOME_LINK    (this is just a link for easy access)
    2)  Run from the script file in the current location
        -   This option will set up everything to run
            bin/email.sh
            it will also create an alias to run as \$(email)
    3)  Run from the script file in the current location
        -   Same as option 2 but does not set alias
    4)  Exit

choices
    read -n1 -p "Enter Selection: " SETUP_TYPE
    echo -e "\n"

    case $SETUP_TYPE in
        1)
            runInstall
            ;;\
        2)
            START_SERVER=Y
            runInstall
            ;;
        3)
            useBinaries
            ;;
        4)
            return 1
            ;;
        5)
            echo -e "\n\nGood-Bye.\n\n"
            ;;
        *)
            echo "Invalid Option"
            defineSetup
            ;;
    esac
}

installDependencies() {
    debconf-set-selections <<< "postfix postfix/main_mailer_type string 'No configuration'"

    sudo apt-get update
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y mailutils
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y ssmtp mutt
}

sudoAppend()
{
    ORIGINAL=$1
    TMP=$ORIGINAL.tmp
    if [ $3 ]; then
        CHMOD_VAR=$3
    else
        CHMOD_VAR=644
    fi

    echo chmod: $CHMOD_VAR

    echo original: $ORIGINAL

    sudo cp $ORIGINAL $TMP

    sudo chmod 777 $TMP

    sudo echo -e $2 >> $TMP

    echo -e "\nCopying $ORIGINAL to $ORIGINAL.bak\n"

    sudo cp $ORIGINAL $ORIGINAL.bak

    echo -e "\nAdding email conf to $ORIGINAL\n"

    sudo cp $TMP $ORIGINAL

    sudo chmod 644 $ORIGINAL
}

isCorrectEmail() {
    read -n1 -p "Is $EMAIL_ADDRESS correct?" correct
    echo -e "\n" $CORRECT_EMAIL
    case $CORRECT_EMAIL in
        y|Y)
            getPassword
            ;;
        n|N)
            echo "Try Again."
            getEmail
            ;;
        *)
            echo "Unknown Answer"
            isCorrectEmail
            ;;
    esac
}

getEmail() {
    read -p "What's your gmail account? " EMAIL_ADDRESS
    isCorrectEmail
}

getPassword() {
    read -s -p "Enter Password: " EMAIL_PASS
    echo -e "\nIf you need to change this modify\n-- /etc/ssmtp.conf"
}

configureMailServer() {
    if [ $EMAIL_CONFIG_FILE ]; then
        . $EMAIL_CONFIG_FILE
    fi

    if [ $EMAIL_ADDRESS ] && [ $EMAIL_PASS ]; then
        echo "PreConfigured"
    else
        getEmail
    fi

    APPEND_STRING="FromLineOverride=YES\nAuthUser=$EMAIL_ADDRESS\nAuthPass=$EMAIL_PASS\nmailhub=smtp.gmail.com:587\nUseSTARTTLS=YES"

    sudoAppend /etc/ssmtp/ssmtp.conf $APPEND_STRING
}

useBinaries() {
    echo "alias email=\"bash $ROOT_DIR/bin/email.sh\"" >> ~/.bashrc
}

runInstall() {
    sudo cp $EMAIL_SCRIPT $USR_BIN/$EMAIL_CMD

    sudo mkdir $APP_DIR

    sudo cp -R $ROOT_DIR/* $APP_DIR

    mkdir $HOME_LINK

    sudo ln -s $APP_DIR/conf $HOME_LINK/config

    sudo ln -s $APP_DIR/templates $HOME_LINK/templates

    sudo chown -R $USER:$USER $HOME_LINK

    sudo chown -R $USER:$USER $HOME_LINK/config

    sudo chown -R $USER:$USER $HOME_LINK/templates
}

main() {
    setDefaults

    defineSetup

    installDependencies

    configureMailServer

    if [[ $START_SERVER != "" ]]; then
        . $NODE_INSTALL_SCRIPT
    fi

    exit 1
}

main
