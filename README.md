## playing with kafka
```bash
#docker build -t p4km9y/kafka -t kafka .
#docker login
#docker push p4km9y/kafka
# zookeeper named z1
# ip=`docker inspect z1 | sed -n 's/^\(.*"IPAddress"\s*:\s*"\(.\+\)".*\)$/\2/p' | uniq`
# leader
docker run --name k1 -e "ZOOKEEPER_CONNECT=172.17.0.2:2181" kafka
# follower
docker run --name k2 -e "ZOOKEEPER_CONNECT=172.17.0.2:2181" -e "BROKER_ID=2" kafka
```

## iot sw infra setup
```bash
docker-compose -p iot up
```

