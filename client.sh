#! /bin/sh

docker-compose -f ./Client/creditcoin-client.yaml down
docker-compose -f ./Client/creditcoin-client.yaml pull
docker-compose -f ./Client/creditcoin-client.yaml up -d
