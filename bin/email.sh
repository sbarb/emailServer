#!/usr/bin/env bash
#
# Title              :email.sh
# Description        :provides an easy to use mutt-wraper
# Author             :Steven Barber
# Email              :steven.barber@eagles.usm.edu
# Date               :01-23-2016
# Version            :0.1
# Usage              :bash email.sh
#                        -- or --
#                     email -h
# Notes              :Have Fun :-)
# bash_version       :4.3.11(1)-release
#========================================================================

if [[ ${0%/$(basename $BASH_SOURCE)} == *"email.sh"* ]]; then
    ROOT_DIR=$PWD
else
    ROOT_DIR=${0%/$(basename $BASH_SOURCE)}
fi

ROOT_DIR=$(readlink -f $ROOT_DIR)
ROOT_DIR=${ROOT_DIR%"/bin"}

if [ -d ~/.email/config ]; then
    default_conf_dir=~/.email/config
fi

if [[ $default_conf_file == "" ]] && [ -d $ROOT_DIR/conf ]; then
    default_conf_dir=$ROOT_DIR/conf
fi

if [[ $default_conf_file == "" ]] && [ -d /usr/share/Email/conf ]; then
    default_conf_dir=/usr/share/Email/conf
fi

default_conf_file=$default_conf_dir/default-mail.conf

# if default configuration file exist include it
if [ -f $default_conf_file ]; then
    . $default_conf_file
    echo "default_conf_file location:" $default_conf_file
else # Otherwise uncomment these options or copy them into a config file
    echo "DEFAULT CONFIG FILE NOT FOUND!!!"
    # Edit these variable to best suit your needs
    #
    # default_number=5555555555
    # default_carrier=mms.att.net
    # personal_email=email@domain.com
    # work_email=email@work.com
    #
    #
    # # Default values to be set when none are selected
    # default_phone=$default_number@$default_carrier
    # default_emails=($personal_email)
    # default_subject="email from email machine"
    # default_msg="Message not found\nPlease remember to send a message next time with the\n-m option"
    # # if no attachment is given it defaults to an empty string
    # default_attach=""
    #
    # html=false
fi

# show if inivalid option has been given when running script
displayInvalidOption() {
cat <<EOF

    Invalid option -$OPTARG

EOF

displayHelpInfo
}
# displays valid options and help information
displayHelpInfo() {
cat <<EOF
    Availiable Options:

    ######### Message Options #########
    -t  Send to address(s)
        [can be used multiple times]
    -n  Send to phone number
        ** Requires either extension
            @mms.att.net
        ** or -c option
    -c  number's carrier
        Options:
            am | AM | a | A | att | AT&T - AT&T MMS
            at | AT - AT&T TXT
            verizon | v | V - Verizon
            tmob | TM | tm - T-Mobile
            sprint | s | S - Sprint PCS
            virgin | virg | VIRG - Virgin Mobile
            uscc | USCC | us - US Cellular
            next | nextel | Next - Nextel
            boost | Boost | b | B - Boost
            alltel | all | All | AllTel - Alltel
    -s  Subject line
    -m  Message
    -H  HTML file to send as message
    -a  Attachment(s)
        [can be used multiple times]

    ------- Personal Options -----------
    -C  Config file
    -T  Send text message to default phone
    -W  Send default work_email
    -E  Email default personal_email
    -B  Send default text and email
    -A  Send default text, personal_email, and work_email

    ########## Help Options ###########
    -h      Displays help page
    -help   Displays help page


    If passing in a config file it will override the default
    Default configs are stored in
    $default_conf_file


EOF
}

# get the options passed into script and set variables accordingly
while getopts ":TEBWAt:s:m:H:a:C:n:c:h" opt; do
  case $opt in
    T)
        emails=(`echo ${emails[*]} | sed 's/[)(]//g'` $default_phone)
        ;;
    E)
        emails=(`echo ${emails[*]} | sed 's/[)(]//g'` $default_emails)
        ;;
    B)
        emails=(`echo ${emails[*]} | sed 's/[)(]//g'` $default_emails $default_phone)
        ;;
    W)
        emails=(`echo ${emails[*]} | sed 's/[)(]//g'` $work_email)
        ;;
    A)
        emails=(`echo ${emails[*]} | sed 's/[)(]//g'` ${default_emails[*]} $default_phone)
        ;;
    t)
        emails=(`echo ${emails[*]} | sed 's/[)(]//g'` ${OPTARG[*]})
        ;;
    s)
        subject=$OPTARG
        ;;
    m)
        msg=$OPTARG
        ;;
    H)
        html_file=$OPTARG
        ;;
    a)
        attach=($attach $OPTARG)
        ;;
    C)
        config=$OPTARG
        . $config
        echo "config file" $config
        echo $emails
        ;;
    n)
        number=$OPTARG
        ;;
    c)
        if [ $OPTARG == "att" ] \
        || [ $OPTARG == "ATT" ] \
        || [ $OPTARG == "at&t" ] \
        || [ $OPTARG == "AT&T" ] \
        || [ $OPTARG == "am" ] \
        || [ $OPTARG == "AM" ] \
        || [ $OPTARG == "ma" ] \
        || [ $OPTARG == "MA" ] \
        || [ $OPTARG == "A" ] \
        || [ $OPTARG == "a" ]; then
            # AT&T MMS email
            carrier=mms.att.net
        elif [ $OPTARG == "at" ] \
        || [ $OPTARG == "AT" ] \
        || [ $OPTARG == "ta" ] \
        || [ $OPTARG == "TA" ]; then
            # AT&T text email
            carrier=txt.att.net
        fi

        if [ $OPTARG == "verizon" ] \
        || [ $OPTARG == "v" ] \
        || [ $OPTARG == "V" ]; then
            carrier=vtext.com
        fi

        if [ $OPTARG == "tmob" ] \
        || [ $OPTARG == "TM" ] \
        || [ $OPTARG == "tm" ]; then
            carrier=tmomail.net
        fi

        if [ $OPTARG == "sprint" ] \
        || [ $OPTARG == "s" ] \
        || [ $OPTARG == "S" ]; then
            carrier=messaging.sprintpcs.com
        fi

        if [ $OPTARG == "virgin" ] \
        || [ $OPTARG == "virg" ] \
        || [ $OPTARG == "VIRG" ]; then
            carrier=vmobl.com
        fi

        if [ $OPTARG == "uscc" ] \
        || [ $OPTARG == "USCC" ] \
        || [ $OPTARG == "us" ]; then
            carrier=email.uscc.net
        fi

        if [ $OPTARG == "next" ] \
        || [ $OPTARG == "nextel" ] \
        || [ $OPTARG == "Next" ]; then
            carrier=messaging.nextel.com
        fi

        if [ $OPTARG == "boost" ] \
        || [ $OPTARG == "Boost" ] \
        || [ $OPTARG == "b" ] \
        || [ $OPTARG == "B" ]; then
            carrier=myboostmobile.com
        fi

        if [ $OPTARG == "alltel" ] \
        || [ $OPTARG == "all" ] \
        || [ $OPTARG == "All" ] \
        || [ $OPTARG == "AllTel" ]; then
            carrier=message.alltel.com
        fi
        ;;
    h | help)
        setDefaultConfig
        displayHelpInfo
        exit 1
        ;;
    \?)
        displayInvalidOption
        exit 1
        ;;
    :)
        echo -e "\n\nOption -$OPTARG requires an argument.\n\n" >&2
        exit 1
        ;;
    esac
done
#
# ------------------------------------------------------------------

setDefaultEmail() {
    echo "No emails provided, setting default to" ${default_emails[*]}
    emails=${default_emails[*]}
}

setDefaultSubject() {
    if [[ $sbj ]] && [[ ! $subject ]]; then
        subject=$sbj
    elif [[ $sub ]] && [[ ! $subject ]]; then
        subject=$sub
    elif [[ $subj ]] && [[ ! $subject ]]; then
        subject=$subj
    elif [[ $s ]] && [[ ! $subject ]]; then
        subject=$s
    else
      echo "No subject provided, setting default to" $default_subject
      subject=$default_subject
    fi
}

setDefaultMsg() {
    if [[ $message ]] && [ ! $msg ]; then
        msg=$message
    elif [[ $mess ]] && [ ! $msg ]; then
        msg=$mess
    elif [[ $m ]] && [ ! $msg ]; then
        msg=$m
    fi

    if [ "$html_file" != "false" ]; then
        msg=$(cat $html_file)
    else
        if [[ ! $msg ]]; then
          echo "No msg provided, setting default to" $default_msg
          msg=$default_msg
        fi
    fi
}

setDefaultAttachment() {
    echo "No attachment provided; default to:" $default_attach
    attach=$default_attach
}

checkVars() {
    # if variable email was used set emails = email
    if [ $email ]; then
        emails=(`echo ${email[*]} | sed 's/[)(]//g'` $emails)
    fi
    # if variable to was used set emails = to
    if [ $to ] && [ ! $emails ]; then
        emails=(`echo ${to[*]} | sed 's/[)(]//g'` $emails)
    fi
    # if no email provided, set email to default value
    if [[ ! $emails ]]; then
        # if no email is provided but a number and carrier are provided
        # those are substututed for the email
        if [ $number ] && [ $carrier ]; then
            phone=$number@$carrier
            emails=$phone
        elif [ $phone ]; then
            emails=$phone
        else
            setDefaultEmail
        fi
    fi

    # if no subject provided, set subject to default value
    if [[ ! $subject ]]; then
        setDefaultSubject
    fi
    # if no message provided, set message to default value
    if [[ ! $msg ]]; then
        setDefaultMsg
    fi
    # if no attachment provided, set attachment to default value
    if [[ ! $attach ]]; then
        setDefaultAttachment
    fi
}

# builds email and attachment arrays
buildArrays() {
    emails=`echo ${emails[*]} | sed 's/[)(]//g'`
    read -a emails <<<$emails

    attach=`echo ${attach[*]} | sed 's/[)(]//g'`
    read -a attach <<<$attach
}

# sends the email via mutt
sendEmail() {
    for  i in "${emails[@]}"; do
        echo "sending email to" $i | sed 's/[)(]//g'
        # if attachment array is not empty string
        if [[ ${attach[@]} != "" ]]; then
            # send email with attachments
            echo ${attach[@]}
            if [ "$html_file" != false ]; then
                echo "Sending as HTML"
                echo -e "$msg" | mutt -e "set content_type=text/html" "$i" -s "$subject" -a ${attach[@]}
            else
                echo "Sending as Plain-Text"
                echo -e "$msg" | mutt "$i" -s "$subject" -a ${attach[@]}
            fi
        else
            echo "html_file" $html_file
            if [ "$html_file" != false ]; then
                echo "Sending as HTML"
                echo -e "$msg" | mutt -e "set content_type=text/html" "$i" -s "$subject"
            else
                echo "Sending as Plain-Text"
                echo -e "$msg" | mutt "$i" -s "$subject"
            fi
        fi
    done
}

main() {
    # if no variables are given to email, subject, message, or attachment
    # set them to default values
    checkVars
    # build the arrays for emails and attachments
    buildArrays
    # send the email to all emails given
    sendEmail
}

main
