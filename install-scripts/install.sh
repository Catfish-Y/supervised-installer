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
curl -fsSL get.docker.com | sh

# Install OS-Agent
rm /tmp/os-agent.deb
tag=$(curl -s https://api.github.com/repos/home-assistant/os-agent/releases/latest | grep tag_name | cut -f4 -d "\"")
echo "$tag"
if [ ! "$tag" ]; then
  echo '未获取到版本号'
  exit
fi
curl -LJo /tmp/os-agent_x86_64.deb https://kgithub.com/home-assistant/os-agent/releases/download/"$tag"/os-agent_"${tag}"_linux_x86_64.deb
dpkg -i /tmp/os-agent_x86_64.deb

gdbus introspect --system --dest io.hass.os --object-path /io/hass/os
sleep 5

# Install supervised package
curl -LJo /tmp/homeassistant-supervised.deb https://kgithub.com/home-assistant/supervised-installer/releases/latest/download/homeassistant-supervised.deb
apt install /tmp/homeassistant-supervised.deb
