#!/bin/bash


if [ ! -e /var/lib/ldap-account-manager/config/docker_bootstrapped ]; then
  cp -r /opt/lam/* /var/lib/ldap-account-manager/config/
  if [ -e /lam_bootstrap/lam.conf ]; then
    cp -fr /lam_bootstrap/lam.conf /var/lib/ldap-account-manager/config/lam.conf
  fi
  chown www-data:www-data /var/lib/ldap-account-manager/config -R
  touch /var/lib/ldap-account-manager/config/docker_bootstrapped
else
  status "found already-configured lam"
fi



rm -f /run/apache2/apache2.pid
source /etc/apache2/envvars
exec apache2 -D FOREGROUND

