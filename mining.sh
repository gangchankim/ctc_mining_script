#! /bin/sh

docker-compose -f ./Server/creditcoin-with-gateway.yaml down
docker-compose -f ./Server/creditcoin-default.yaml down
docker-compose -f ./Server/creditcoin-with-gateway.yaml pull
docker-compose -f ./Server/creditcoin-default.yaml pull
docker-compose -f ./Server/creditcoin-with-gateway.yaml up
