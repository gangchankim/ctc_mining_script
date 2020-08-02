#! /bin/sh

docker-compose -f ./CreditcoinDocs-Mainnet/Client/creditcoin-client.yaml down
docker-compose -f ./CreditcoinDocs-Mainnet/Client/creditcoin-client.yaml pull
docker-compose -f ./CreditcoinDocs-Mainnet/Client/creditcoin-client.yaml up -d
