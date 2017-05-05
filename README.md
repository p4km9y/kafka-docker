## see makefile
## simple docker setup
```bash
# zookeeper named z1
# ip=`docker inspect z1 | sed -n 's/^\(.*"IPAddress"\s*:\s*"\(.\+\)".*\)$/\2/p' | uniq`
docker run --name k1 -e "ZOOKEEPER_CONNECT=172.17.0.2:2181" p4km9y/kafka
docker run --name k2 -e "ZOOKEEPER_CONNECT=172.17.0.2:2181" p4km9y/kafka
```

## compose
```bash
docker-compose -p iot zookaf
```

## swarm
```bash
docker stack deploy -c docker-compose.yml zookaf
```
