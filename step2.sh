#!/bin/sh

sudo docker container cp ./validator.priv sawtooth-validator-default:/etc/sawtooth/keys/validator.priv
rm validator.priv
sudo docker container cp ./validator.pub sawtooth-validator-default:/etc/sawtooth/keys/validator.pub
rm validator.pub

cd ~/CreditcoinDocs-Mainnet/

# 1. Get signer
## Creditcoin Miner must be on running status
## If you successfully terninated step1, It will fine

SIGNER=$(sudo docker exec sawtooth-validator-default cat /etc/sawtooth/keys/validator.priv)

echo "signer: $SIGNER"

## replace SIGNER
sed -i "s|<256_bit_key_secp256k1_ECDSA>|$SIGNER|g" ./Client/clientConfig.json

# 2. Run client
sudo docker-compose -f ./Client/creditcoin-client.yaml up -d

# 3. Run client shell
sudo docker exec -it creditcoin-client bash
