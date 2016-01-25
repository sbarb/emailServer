startNode() {

    if [[ ${0%/$(basename $BASH_SOURCE)} == *"/init"* ]]; then
        ROOT_DIR=${0%/$(basename $BASH_SOURCE)}
    else
        ROOT_DIR=$PWD
    fi

    ROOT_DIR=$(readlink -f $ROOT_DIR)
    ROOT_DIR=${ROOT_DIR%"/init"}

    NODE_DIR=$ROOT_DIR/node

    cd $NODE_DIR

    npm install

    node app.js
}

installNode() {
    # install curl
    sudo apt-get install -y curl
    # install nodejs
    curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
    sudo apt-get install -y nodejs
}

installNode

startNode
