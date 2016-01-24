# Email
# Install Options
    1)  install-package

            installs email as if it were a normal linux package

            modifies
                /usr/share/
                    -- for the app data
                        symlinked to ~/.email
                /usr/bin/   
                    -- for the run script
                        which email
                        returns /user/bin/email

    2)  bin-package

            all files are modified and saved in ~/.Email

            if you run
                email
            it will be an alias to the script
            * you must source ~/.bashrc


# Currently this only supports gmail

# Setup

    clone repo

    bash init/setupMailServer.sh

    email -h

**if you can't send email check your google account you may have to allow access**

**if you don't want to allow access create a free gmail account to send email from**


# Run

After setup is complete you should have a new folder ~/.email

Along with a new alias email

to run it either

    email -h

    email -t email1@gmail.com -m "this \nis \nthe \nmessage" -a file1 -a file2

    -- to send a text --

    email -n 5558882222 -c att -m "this \nis \nthe \nmessage"

    -- to use a config file --

    email -C ~/.email/templates/emailTemplate

# CLI Options:

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


    Default configs are stored in /conf/defult-mail.conf

    If passing in a config file it will override the /conf/defult-mail.conf


## Config file options:
#### Address

these options are availiable for single email or array of emails

    to
    email
    emails
    number
    carrier
    phone

    to=email@domain.com
        -- or --
    to=(email@home_domain.com email@work_domain.net 5554448888@mms.att.net)

    number=5554448888
    carrier=mms.att.net

    phone=5554448888@mms.att.net

#### Subject  

The subject line is a string subject to send

    sbj
    subject
    sub
    subj
    s

#### Message    

The Message can either be the output of a bash file (or even a bash file itself, if sent as a config file)

    message
    msg
    mess
    m

#### Attachmets

Attachments work like emails

    attach

    attach=/ABS/FILE/PATH
        -- or --
    attach=(~/file1 ~/file2)

#### HTML File

The body of the message could be HTML.  If that is the case, rather than give a message in the config file give it the html file location

    html_file

    html_file=~/email.html
