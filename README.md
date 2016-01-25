# Email - Mutt Wraper

# BEFORE YOU RUN THIS MODIFY

`/conf/default-mail.conf`

`/conf/install.conf`

**NEW FEATURE!!!**

**Now there is a node package that will throw up a simple server and give you an endpoint to hit**

# Currently this only supports gmail

# Docker pull

`docker pull -a sbarber/demail`

`docker run -it -v /PATH/TO/REPO:/DEST_PATH sbarber/demail bash`

`node /DEST_PATH/node/app.js`

# Docker

`docker run -it -v /PATH/TO/REPO:/DEST_PATH ubuntu bash`

`bash /DEST_PATH/init/install.sh`

select option 2

look at node README for curl information

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

    2)  install-package

        Same as option 1
        but installs node server and runs it


    3)  bin-package

            all files are modified and saved in ~/.Email

            if you run
                email
            it will be an alias to the script
            * you must source ~/.bashrc

    4)  bin-package

            Same as option 2
            but without the ailias in ~/.bashrc
            rather than
                email
            it will be
                bash Email/bin/email.sh

# Setup & Install

`bash Email/init/install.sh`

select option 1, 2, or 3 from above.

Then, try it out:

`wget https://upload.wikimedia.org/wikipedia/commons/3/3f/Logo_Linux_Mint.png -O mint.png && email -a mint.png -t YOUR_EMAIL`

**if you can't send email check your google account you may have to allow access**

**if you don't want to allow access create a free gmail account to send email from**


# http endpoint

Run install process and select option 2

-- or --

After the install process

`bash Email/init/node.sh`




# Run

After setup is complete, if you chose to install, you should have a new folder ~/.email

    email -t email1@gmail.com -m "this \nis \nthe \nmessage" -a file1 -a file2

    -- to send a text --

    email -n 5558882222 -c att -m "this \nis \nthe \nmessage"

    -- to use a config file --

    email -C ~/.email/templates/emailTemplate

# CLI Options:

`email -h` to get more information

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


    If passing in a config file it will override the default
    Default configs are stored in
    /conf/default-mail.conf



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

**Must be a single line**

    sbj
    subject
    sub
    subj
    s

    sbj="this is a subject line"
    s="or this one"

#### Message    

The Message can either be the output of a bash file (or even a bash file itself, if sent as a config file)

    message
    msg
    mess
    m

    msg="this \nis \n the \nmessage \nwith \nnewlines"
    message=$(cat text.txt)
    m=$(ls)

#### Attachmets

Attachments work like emails

    attach

    attach=/ABS/FILE/PATH
        -- or --
    attach=(~/file1 ~/file2)

    attach=~/download.txt

#### HTML File

The body of the message could be HTML.  If that is the case, rather than give a message in the config file give it the html file location

    html_file

    html_file=~/email.html
