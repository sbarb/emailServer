setNODE_DIR() {
    if [[ ${0%/$(basename $BASH_SOURCE)} == *"node"* ]]; then
        ROOT_DIR=$PWD
    else
        ROOT_DIR=${0%/$(basename $BASH_SOURCE)}
    fi

    ROOT_DIR=$(readlink -f $ROOT_DIR)
    ROOT_DIR=${ROOT_DIR%"/init"}

    NODE_DIR=$ROOT_DIR/node
}

setNODE_DIR

cd $NODE_DIR

# install curl
sudo apt-get install -y curl
# install nodejs
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
sudo apt-get install -y nodejs


npm install

echo -e "\n\n\n"
read -n1 -p "Start Node server now?: " START_SERVER
echo -e "\n"

case $START_SERVER in
    y|Y)
        node app.js
        ;;
    n|N)
        exit 1
        ;;
esac

exit 1
