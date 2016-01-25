# Node package

provides a curl endpoint to hit to send emails

# to install

#### Automated

With initial install choose option 2

-- or --

If install has already run

`bash Email/init/node.sh`

#### Manual
install curl

`sudo apt-get install -y curl`

install Node

`curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -`

`sudo apt-get install -y nodejs`

install node packages

`npm install`

# Run

`cd node`

`node app.js`

# How it works

    curl -POST IP_ADDRESS:4000 -H "Content-Type: application/json" -d '{
    "subj":"from curl",
    "msg":"this is a \ntest will \nit \nwork?",
    "args": ["-T"]
    }'

all args are the same as `email -h`

the available commands are

    to          -- single or array
    subj
    msg
    attach      -- single or array
    args        -- single or array
    html_file
