#!/bin/bash

D1R=$(dirname $0)

if [ -f "${D1R}/.env" ]; then 
  export $(cat .env | xargs) 
else
  echo -e ".env file for credential not found!"
  exit 1;
fi

echo -e "Hi!..."

echo "vm.max_map_count=262144" >> /etc/sysctl.conf && sysctl -p
docker compose -f "${D1R}/compose-certs-generator.yml" run --rm generator
WI_HASH="$(docker run --rm -ti wazuh/wazuh-indexer:4.3.6 bash /usr/share/wazuh-indexer/plugins/opensearch-security/tools/hash.sh -p $WI_PASS)"
WI_HASH=$(echo -n $WI_HASH | tr -d '\r')
sed -i "s|set_hash|${WI_HASH}|g" "${D1R}/config/wazuh-indexer/internal_users.yml"

# start wazuh XDR
docker compose up -d
sleep 10s

# set wazuh_api credential
sed -i "s|set_pass|${WAPI_PASS}|g" "${D1R}/config/wazuh-dashboard/wazuh_app.yml"
docker restart wazuh.dashboard

echo -e "...done"
