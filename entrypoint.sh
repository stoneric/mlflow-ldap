#!/usr/bin/env bash

if [[ ! -z "$BACKEND_STORE_URI" ]]; then
   BACKEND_STORE_URI_OPT="--backend-store-uri $BACKEND_STORE_URI"

fi

if [[ ! -z "$DEFAULT_ARTIFACT_ROOT" ]]; then
   DEFAULT_ARTIFACT_ROOT_OPT="--default-artifact-root $DEFAULT_ARTIFACT_ROOT"
fi

if [[ -z "$LDAP_BIND_PASSWORD" ]]; then
   echo "LDAP bind user password is not defined"
   exit 1
else
   sudo -E LDAP_BIND_PASSWORD=$LDAP_BIND_PASSWORD bash -c 'echo "export LDAP_BIND_PASSWORD=$LDAP_BIND_PASSWORD"  >> /etc/apache2/envvars'
fi

if [[ -z "$LDAP_BIND_USER" ]]; then
   echo "LDAP bind user name is not defined"
   exit 1
else
   sudo -E LDAP_BIND_USER=$LDAP_BIND_USER bash -c 'echo "export LDAP_BIND_USER=$LDAP_BIND_USER"  >> /etc/apache2/envvars'
fi 

sudo service apache2 start && mlflow server -h 0.0.0.0 -p 5000 $BACKEND_STORE_URI_OPT $DEFAULT_ARTIFACT_ROOT_OPT
