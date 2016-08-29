#!/bin/sh

set -e
if [ ! -f /opt/sonarqube/bootstrapped ]; then
    echo "Bootstrapping sonar"
    cp -fR /opt/sonarqube/bootstrap/* /opt/sonarqube/
fi

exec ./bin/run.sh  "$@"