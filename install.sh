#!/bin/bash

USER=lxli

# uninstall old docker
yum remove docker \
          docker-client \
	  docker-client-latest \
	  docker-common \
	  docker-latest \
	  docker-latest-logrotate \
	  docker-logrotate \
	  docker-selinux \
	  docker-engine-selinux \
	  docker-engine

# 2. install dependencies
yum install -y yum-utils \
           device-mapper-persistent-data \
           lvm2

# 3. add yum repo
yum-config-manager \
    --add-repo \
    http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

# 4. install docker-ce
#yum makecache fast
#yum install docker-ce -y

# 4. install by script
curl -fsSL get.docker.com -o get-docker.sh
sh get-docker.sh --mirror Aliyun

# 5. start docker
systemctl enable docker
systemctl start docker

# 6. setting registry-mirrors
cat << EOF >> /etc/docker/daemon.json
{
  "registry-mirrors": [
    "https://dockerhub.azk8s.cn",
    "https://reg-mirror.qiniu.com"
  ],
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ],
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF

# 7. restart docker
systemctl daemon-reload
systemctl restart docker

# 8. test if docker install correct
docker info

# 9. add user for Group docker
usermod -aG docker $USER