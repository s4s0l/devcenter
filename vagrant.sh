#!/usr/bin/env bash
exit_with_bells() {
    printf '\a'           # Ring terminal bell
    command -v paplay >/dev/null 2>&1 && paplay dummies/alarm.ogg
    exit 1                # Exit with error
}
trap 'exit_with_bells' ERR

set -e
PACKER_URL=https://releases.hashicorp.com/packer/0.10.1/packer_0.10.1_linux_
DIR=$(dirname $0)
DIR=$(pwd $DIR)

RED='\033[0;31m'
NC='\033[0m' # No Color
MSG='\033[0;36m'


#Check if vagrant is installed
command -v vagrant >/dev/null 2>&1 || { echo -e "${RED}You don't have vagrant installed. See https://www.vagrantup.com/docs/installation/ for instructions" >&2; exit 1; }


EXIST=$(vagrant plugin list | grep vagrant-persistent-storage || true)
if [[ -z ${EXIST} ]]; then
    echo -e "${MSG}No vagrant-persistent-storage plugin, installing..."
    vagrant plugin install vagrant-persistent-storage
fi

if [[ ! -f $DIR/.tmp/packer ]]; then
    echo -e "${MSG}No packer, downloading...."
    archs=`uname -m`
    case "$archs" in
        i?86) PACKER_URL=${PACKER_URL}386.zip ;;
        x86_64) PACKER_URL=${PACKER_URL}amd64.zip ;;
        arm) PACKER_URL=${PACKER_URL}arm.zip ;;
    esac
    mkdir -p $DIR/.tmp/
    wget -O $DIR/.tmp/packer.zip ${PACKER_URL}
    unzip $DIR/.tmp/packer.zip -d $DIR/.tmp
    rm -f $DIR/.tmp/packer.zip
fi

if [[ ! -f $DIR/baseimage/box/virtualbox/ubuntu1604-ansible-0.1.0.box ]]; then
    echo -e "${MSG}Base image was never build, using packer to do that...."
    (cd $DIR/baseimage && $DIR/.tmp/packer build ubuntu.json)
fi

echo -e "${MSG}Running ${NC}vagrant $@"
vagrant "$@"