#! /bin/sh

docker exec -it creditcoin-client ./ccclient tip >> /root/tiplog.txt 

$CMP1=tail -n 4 /root/tiplog.txt | head -n 1
$CMP2=tail -n 2 /root/tiplog.txt | head -n 1

if [ "$CMP1" == "$CMP2" ]; then
    /root/mining.sh
fi
