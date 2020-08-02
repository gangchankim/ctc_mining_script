#! /bin/sh

# 1. docker clear crontab

sudo echo "0 *     * * *   root    truncate -s 0 /var/lib/docker/containers/*/*-json.log" >> /etc/crontab

# 2. rc.local // auto mining.sh after booting

sudo echo "#! /bin/sh" > /etc/rc.local
sudo echo "exit 0" >> /etc/rc.local
sudo chmod +755 /etc/rc.local

sudo echo "#! /bin/sh" > /etc/rc3.d/rc.local
sudo echo "/root/mining.sh" >> /etc/rc3.d/rc.local
sudo chmod +755 /etc/rc3.d/rc.local

sudo echo "[Install]" >> /lib/systemd/system/rc-local.service
sudo echo "WantedBy=multi-user.target" >> /lib/systemd/system/rc-local.service
sudo systemctl enable rc-local.service
sudo systemctl start rc-local.service

sudo echo "#! /bin/sh" > /etc/rc.local
sudo echo "/root/mining.sh" >> /etc/rc.local

# 3. mining.sh automation(4hours repeat)

sh -c "$(curl -fsSL https://raw.githubusercontent.com/gangchankim/ctc_mining_script/master/autominingcheck.sh)"
