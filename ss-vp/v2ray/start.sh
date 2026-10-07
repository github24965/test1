docker stop v2ray
docker rm v2ray
docker run --name v2ray -d -p 30086:10086 -v /opt/vpn/config.json:/etc/v2ray/config.json  --entrypoint "/usr/bin/v2ray" v2fly/v2fly-core:v5.41.0  run -c /etc/v2ray/config.json
sleep 5
docker ps
