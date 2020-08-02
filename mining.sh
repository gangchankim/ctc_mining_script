#! /bin/sh

docker-compose -f ./CreditcoinDocs-Mainnet/Server/creditcoin-with-gateway.yaml down
docker-compose -f ./CreditcoinDocs-Mainnet/Server/creditcoin-default.yaml down
docker-compose -f ./CreditcoinDocs-Mainnet/Server/creditcoin-with-gateway.yaml pull
docker-compose -f ./CreditcoinDocs-Mainnet/Server/creditcoin-default.yaml pull
docker-compose -f ./CreditcoinDocs-Mainnet/Server/creditcoin-with-gateway.yaml up
