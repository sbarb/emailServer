#!/usr/bin/env bash

setDefaults() {
    EMAIL_CMD=email

    setROOT

    USR_BIN=/usr/bin

    EMAIL_SCRIPT=$ROOT_DIR/bin/email.sh
    APP_DIR=/usr/share/Email
}

setROOT() {
    if [[ ${0%/$(basename $BASH_SOURCE)} == *"setupMailServer"* ]]; then
        ROOT_DIR=$PWD
    else
        ROOT_DIR=${0%/$(basename $BASH_SOURCE)}
    fi

    ROOT_DIR=$(readlink -f $ROOT_DIR)
    ROOT_DIR=${ROOT_DIR%"/init"}
}

modifyFile()
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

isCorrect() {
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
            isCorrect
            ;;
    esac
}

getEmail() {
    read -p "What's your gmail account? " EMAIL_ADDRESS
    isCorrect
}

getPassword() {
    read -s -p "Enter Password: " EMAIL_PASS
    echo -e "\nIf you need to change this modify\n-- /etc/ssmtp.conf"
}

setupMailServer()
{
    # read -n1 -p "Would you like to set up a mail server? [y,n]" BEGIN_SETUP
    BEGIN_SETUP=y
    echo -e "\n"
    case $BEGIN_SETUP in
        y|Y)
            debconf-set-selections <<< "postfix postfix/main_mailer_type string 'No configuration'"

            sudo apt-get update
            sudo DEBIAN_FRONTEND=noninteractive apt-get install -y mailutils
            sudo DEBIAN_FRONTEND=noninteractive apt-get install -y ssmtp mutt

            modifyFile /etc/ssmtp/ssmtp.conf "FromLineOverride=YES\nAuthUser=email.sending.server@gmail.com\nAuthPass=*Email@2020\nmailhub=smtp.gmail.com:587\nUseSTARTTLS=YES"
            # getEmail
            # modifyFile /etc/ssmtp/ssmtp.conf "FromLineOverride=YES\nAuthUser=$EMAIL_ADDRESS\nAuthPass=$EMAIL_PASS\nmailhub=smtp.gmail.com:587\nUseSTARTTLS=YES"
            # echo -e "\nIf you need to change your email and/or password\n-- /etc/ssmtp.conf"
            ;;
        n|N)
            echo -e "NOT Setting up Mail Server.\nGoodBye"
            exit 1
            ;;
        *)
            echo "Unknown Answer"
            setupMailServer
            ;;
    esac
}

makeAvailable() {
    # EMAIL_SCRIPT=$ROOT_DIR/bin/email.sh
    # EMAIL_CMD=email
    # APP_DIR=/usr/share/Email

    # mkdir ~/.Email
    #
    # cp -R ${0%/$(basename $BASH_SOURCE)}/* ~/.Email
    #
    # echo "alias email=\"bash ~/.Email/email.sh\"" >> ~/.bashrc

    sudo cp $EMAIL_SCRIPT $USR_BIN/$EMAIL_CMD

    sudo mkdir $APP_DIR

    sudo cp -R $ROOT_DIR/* $APP_DIR

    mkdir ~/.email

    sudo ln -s $APP_DIR/conf ~/.email/config

    sudo ln -s $APP_DIR/templates ~/.email/templates

    sudo chown -R $USER:$USER ~/.email

    sudo chown -R $USER:$USER ~/.email/config

    sudo chown -R $USER:$USER ~/.email/templates
}

main() {
    setDefaults

    setupMailServer

    makeAvailable

    exit 1
}

main
