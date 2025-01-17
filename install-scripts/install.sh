# bash -c "$(wget -qLO - https://kgithub.com/Catfish-Y/supervised-installer/raw/main/install-scripts/install.sh)"

# Change-Source
sed -i "s@http://deb.debian.org@https://mirrors.ustc.edu.cn/@g" /etc/apt/sources.list

# update
apt update
apt upgrade

# install-dependencies
apt install \
apparmor \
jq \
wget \
curl \
udisks2 \
libglib2.0-bin \
network-manager \
dbus \
lsb-release \
systemd-journal-remote -y

# Install Docker-CE
# curl -fsSL get.docker.com | sh
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
sleep 3

# Install OS-Agent
if [ -f "/tmp/os-agent.deb" ];then
  rm /tmp/os-agent.deb
fi
tag=$(curl -s https://api.kgithub.com/repos/home-assistant/os-agent/releases/latest | grep tag_name | cut -f4 -d "\"")
echo "$tag"
if [ ! "$tag" ]; then
  echo '未获取到版本号'
  exit
fi
curl -LJo /tmp/os-agent_x86_64.deb https://kgithub.com/home-assistant/os-agent/releases/download/"$tag"/os-agent_"${tag}"_linux_x86_64.deb
dpkg -i /tmp/os-agent_x86_64.deb

gdbus introspect --system --dest io.hass.os --object-path /io/hass/os
sleep 5

# Change_docker_registry
# if [ -d "/etc/docker" ];then
#   cat << EOF > /etc/docker/daemon.json 
#     { 
#     "log-driver": "journald",
#     "storage-driver": "overlay2",
#     "registry-mirrors": [ 
#     "https://hub-mirror.c.163.com",
#     "https://docker.mirrors.ustc.edu.cn"
#     ]
#     }
# EOF
#     systemctl daemon-reload
#     systemctl restart docker > /dev/null
# fi


# Install supervised package
if [ -f "/tmp/homeassistant-supervised.deb" ];then
  rm /tmp/homeassistant-supervised.deb
fi
curl -LJo /tmp/homeassistant-supervised.deb https://kgithub.com/home-assistant/supervised-installer/releases/latest/download/homeassistant-supervised.deb
# curl -LJo /tmp/homeassistant-supervised.deb https://kgithub.com/home-assistant/supervised-installer/releases/download/1.0.2/homeassistant-supervised.deb
# curl -LJo /tmp/homeassistant-supervised.deb https://kgithub.com/home-assistant/supervised-installer/releases/download/1.1.1/homeassistant-supervised.deb
apt install /tmp/homeassistant-supervised.deb
