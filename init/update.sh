setROOT() {
    if [[ ${0%/$(basename $BASH_SOURCE)} == *"update"* ]]; then
        ROOT_DIR=$PWD
    else
        ROOT_DIR=${0%/$(basename $BASH_SOURCE)}
    fi


    ROOT_DIR=$(readlink -f $ROOT_DIR)
    ROOT_DIR=${ROOT_DIR%"/init"}
}

setROOT

cd $ROOT_DIR

git pull

sudo cp $ROOT_DIR/bin/email.sh /usr/bin/email
