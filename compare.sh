#! /bin/bash

sudo docker-compose -f ~/CreditcoinDocs-Mainnet/Client/creditcoin-client.yaml down
sudo docker-compose -f ~/CreditcoinDocs-Mainnet/Client/creditcoin-client.yaml pull
sudo docker-compose -f ~/CreditcoinDocs-Mainnet/Client/creditcoin-client.yaml up -d

docker exec creditcoin-client ./ccclient tip >> /root/a

NOW=$(curl -fsL  https://api.creditcoinexplorer.com/api/Blocks | cut -f 8 -d '"')
CMP0=$(tail -n 6 /root/a | head -n 1)
CMP1=$(tail -n 4 /root/a | head -n 1)
CMP2=$(tail -n 2 /root/a | head -n 1)
CMP3=$(tail -n 1 /root/a)

if [[ "$CMP3" =~ "Error" ]]; then
        echo "============================================================"
        echo "Error Status, Restart the server..."
        echo "============================================================"
        /root/mining.sh
else
    if [ x$CMP1 != x$CMP2 ];then
        echo "============================================================"
        echo "Now block number is $CMP2, Keep Mining"
        echo "============================================================"
    else
        if [ $CMP2 -lt $NOW ];then
            echo "============================================================"
            echo "The block number is the same for 15 minutes. Restart the server."
            echo "============================================================"
            /root/mining.sh
        else
                if [ x$CMP2 = x$CMP0 ];then
                        echo "============================================================"
                        echo "There is some error. Restart the server."
                        echo "============================================================"
                        /root/mining.sh
                else
                        echo "============================================================"
                        echo "The block number is the same for 15 minutes. But It's the lastest block. Keep Mining"
                        echo "============================================================"
                fi
        fi
    fi
fi
