# MLFlow with LDAP authentication using Apache2 as a reverse proxy.

# Input parameters:
## LDAP
LDAP_BIND_USER - Bind user for LDAP. The user name must be with the domain part e.g. user@domain
LDAP_BIND_PASSWORD - Password for bind user

## HTTPS/SSL
The image expects ssl certificates in the /cert directory. 
This directory must contain the following files: 
 - https_cert.cert	
 - https_cert.key
 
 # Build
 docker image build --tag mlflow_ad:latest .
 
 # Run
 Example run command:
 docker run --name mlflow_ad --rm -p 443:443 --env LDAP_BIND_PASSWORD=<password> --env LDAP_BIND_USER=user@domain -v <local path to certificates for https>:/cert -it mlflow_ad:latest
 
