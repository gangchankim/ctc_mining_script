#!/bin/sh

### Type your INFURA URL ###
INFURA="https://mainnet.infura.io/v3/6ee3f79f964745ff99fac13da1b7061d"
####################

IP=$(dig +short myip.opendns.com @resolver1.opendns.com)

# Block snapshot on google drive
# Timestamp: July 10, 2020 9:46 PM UTC
# File Name: creditcoin-block-volume.tar.gz
# Latest Block: 513,815
# SHA-256 Hash: 9BF2542F72F913AACDEE82CD6B2FFC3AD09E78D4662DDCAD865816CA425F0AE1
FILE_ID="1LYvErTJIhaOpmwc853_uSEios-K-VXGn"


# 1. Git&tmux insatll
sudo apt-get -y install git tmux

# 2. Docker install
## Docker uninstall(Pass this part if you start on new instance)
sudo apt-get -y remove docker docker-engine docker.io containerd runc

## SET UP THE REPOSITORY
## Update the apt package index and install packages to allow apt to use a repository over HTTPS:
sudo apt-get update
sudo apt-get -y install \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  software-properties-common

## Add Docker’s official GPG key:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

## set up the stable repository
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

## Install docker engine
sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io

# 3. Docker compose install
## Run this command to download the current stable release of Docker Compose:
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

## Apply executable permissions to the binary:
sudo chmod +x /usr/local/bin/docker-compose

## You can also create a symbolic link to /usr/bin or any other directory in your path.
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# 4. Clone creditcoin mainnet repository
git clone https://github.com/gluwa/CreditcoinDocs-Mainnet.git
## cd
cd CreditcoinDocs-Mainnet/
## checkout to revive "-vv"
git checkout 694b010550

# 5. Replace public IP & ethereum_node_url
sed -i "s|<ethereum_node_url>|$INFURA|g" ./Server/gatewayConfig.json
sed -i "s|\[insert.your.ip\]|$IP|g" ./Server/creditcoin-with-gateway.yaml
sed -i "s|\[insert.your.ip\]|$IP|g" ./Server/creditcoin-default.yaml

# 6. change sawtooth version 1.0 to 1.2
sed -i "s|sawtooth-settings-tp:1.0|sawtooth-settings-tp:1.2|g" ./Server/creditcoin-with-gateway.yaml
sed -i "s|sawtooth-settings-tp:1.0|sawtooth-settings-tp:1.2|g" ./Server/creditcoin-default.yaml

sed -i "s|sawtooth-rest-api:1.0|sawtooth-rest-api:1.2|g" ./Server/creditcoin-with-gateway.yaml
sed -i "s|sawtooth-rest-api:1.0|sawtooth-rest-api:1.2|g" ./Server/creditcoin-default.yaml

# 7. docker image pull
sudo docker-compose -f Server/creditcoin-with-gateway.yaml pull
sudo docker-compose -f Server/creditcoin-default.yaml pull # Optional
sudo docker-compose -f Client/creditcoin-client.yaml pull

# 8. Download block snapshot
## Install gdown to download large file from Google Drive
## Install python3 & pip3 
sudo apt install -y python3 python3-pip
## Install gdown
pip3 install gdown
## download compressed block snapshot file
gdown https://drive.google.com/uc?id=$FILE_ID

# 9. Use snapshot
## Make folder "server_validator-block-volume"
sudo mkdir /var/lib/docker/volumes/server_validator-block-volume/
## Uncompressed
sudo tar xzvf creditcoin-block-volume.tar.gz -C /var/lib/docker/volumes/server_validator-block-volume/
## Remove downloaded compressed file
sudo rm -rf creditcoin-block-volume.tar.gz

# 10. Open firewall
# 4004 8008 8800 55555
yes | sudo ufw enable
sudo ufw allow 22/tcp    # for SSH # AWS Connection Error
sudo ufw allow 4004/tcp
sudo ufw allow 8008/tcp
sudo ufw allow 8800/tcp
sudo ufw allow 55555/tcp

# 11. Auto script download

cd ..
echo "$(curl -fsSL https://raw.githubusercontent.com/gangchankim/ctc_mining_script/master/mining.sh)" > mining.sh
chmod +x mining.sh
echo "$(curl -fsSL https://raw.githubusercontent.com/gangchankim/ctc_mining_script/master/client.sh)" > client.sh
chmod +x client.sh

# 12. Run Server
cd CreditcoinDocs-Mainnet/
sudo docker-compose -f ./Server/creditcoin-with-gateway.yaml up
