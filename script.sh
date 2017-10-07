#!/bin/bash

docker rm -f dockbix-agent-xxl-nvps-challenge 2>/dev/null >/dev/null || true
DATE=$(date)
CPU=$(cat /proc/cpuinfo | grep "model name" | uniq -c | sed 's/model name.*:/x/g')
CPU="${CPU#"${CPU%%[![:space:]]*}"}"
CID=$(md5sum <<< $(hostname) | awk -F - '{print $1}' | tr -d ' ')

set -x
sudo docker run \
  --name=dockbix-agent-xxl-nvps-challenge \
  --privileged \
  -v /:/rootfs \
  -v /var/run:/var/run \
  -e "ZA_Server=0.0.0.0/0" \
  -e "ZA_StartAgents=100" \
  -d monitoringartist/dockbix-agent-xxl-limited:latest
set +x
BENCH=$(sudo docker exec -t dockbix-agent-xxl-nvps-challenge zabbix_agent_bench -host 127.0.0.1 -key stress.ping[] -timelimit 10 -threads 128 | sed 's/\[32m//g' | sed 's/\[39m//g' | sed 's/\[0m//g' | head -c -1)
sudo docker rm -f dockbix-agent-xxl-nvps-challenge 2>/dev/null >/dev/null || true

# post data
USER_ID=${USER_ID:-"no-user-id"}
NVPS=$(echo $BENCH | grep "NVPS" | awk -F"(" '{print $3}' | awk '{print $1}')
echo "$BENCH"
echo "USER_ID: $USER_ID"
echo "CLIENT_ID: $CID"
echo "CPU: $CPU"
echo "NVPS: $NVPS"

curl -s -XPOST -o /dev/null -d "entry.1202603628=$USER_ID&entry.100279442=$CID&entry.1605496740=$CPU&entry.1893944826=$BENCH&entry.1312488442=$NVPS" \
"https://docs.google.com/forms/d/e/1FAIpQLSdRmBUnaie0ElvDfJ40bgUmhiccLgGSTWvHyDsBAgl_4JF-Zw/formResponse"

echo "Nice. Your results has been submitted. See https://drive.google.com/open?id=1qv5siZ-lGa69GnibsbtYHnCMdG05zrZG7L7FCuInF08"
