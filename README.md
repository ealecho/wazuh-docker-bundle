# Wazuh Docker Bundle
This deployment is defined in the docker-compose.yml file with one Wazuh manager containers, one Wazuh indexer containers, and one Wazuh dashboard container [reference](https://documentation.wazuh.com/current/deployment-options/docker/wazuh-container.html). 

Step 1: **Configuration** Create the .env file for credentials, NOT change the user name. Reference:
```
WAZUH_VERSION=4.3.6
# wazuh indexer creds
WI_USER=w4zuh_adm1n
WI_PASS=

# wazuh dashboard app creds
WAPI_USER=w4zuh_ap1
WAPI_PASS=

# The general recommendation is to allocate 50% of the available system memory to wazuh-indexer, with a maximum of 32GB
JAVA_HEAP=1g

# wazuh agent password for authentication
WAGENT_PASS=
```

- Config filebeat: `/var/lib/docker/volumes/filebeat-etc/_data/filebeat.yml` output.elasticsearch `username: w4zuh_adm1n`, `password: <password>` & `ssl.verification_mode: none` to send alerts to wazuh indexer.

Step 2: **Deployment** Run deploy.sh as sudo, `sudo bash deploy.sh`
