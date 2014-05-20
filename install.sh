#!/usr/bin/env bash

# vars
export ROOT_PATH='/nodejs'
export MONGO_VERSION='2.6.0'
export NODE_VERSION='0.10.26'

# take ownership of the folders that npm/node use
sudo mkdir -p /usr/local/{share/man,bin,lib/node,include/node}
sudo chown -R $USER /usr/local/{share/man,bin,lib/node,include/node}
sudo chown -R $USER $ROOT_PATH
sudo chown -R $USER /home/vagrant

# apt packages
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 # add mongo repo
echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
add-apt-repository -y ppa:rwky/redis # add redis repo
sudo apt-get update
sudo apt-get install -y curl software-properties-common git-core python-software-properties redis-server
sudo apt-get install -y libpcre3-dev build-essential libssl-dev g++ imagemagick
sudo apt-get install mongodb-org=$MONGO_VERSION mongodb-org-server=$MONGO_VERSION mongodb-org-shell=$MONGO_VERSION mongodb-org-mongos=$MONGO_VERSION mongodb-org-tools=$MONGO_VERSION

# install redis
wget http://download.redis.io/redis-stable.tar.gz
tar xvzf redis-stable.tar.gz
cd redis-stable
make

# install nvm and node
curl https://raw.githubusercontent.com/creationix/nvm/v0.7.0/install.sh | sh
source ~/.profile # apply .profile changes
nvm install $NODE_VERSION
nvm alias default $NODE_VERSION
source ~/.profile # apply .profile changes

# grant node access to port 80
# sudo apt-get install libcap2-bin
# sudo setcap cap_net_bind_service=+ep /usr/local/bin/node

# install global npm modules
npm install pm2@^0.8.1 -g # pm2
sudo env PATH=$PATH:/usr/local/bin pm2 startup ubuntu -u vagrant
npm install grunt@~0.4.1 -g # grunt
npm install git://github.com/alexferreira/ember-gen.git#7cad7 -g # ember-gen
npm install migrate@^0.1.4 -g

# .profile changes
curl https://gist.github.com/ricardobeat/6926021/raw/a4681e3391b3f0eb9995d46631831b9f6594067b/.profile >> ~/.profile # PS1 colors + git branch
echo 'export PATH=$PATH:node_modules/.bin:node_modules/bin' >> ~/.profile # bin NPM modules local path
echo "export NODE_ENV=development" >> ~/.profile # run as development env
echo "cd $ROOT_PATH" >> ~/.profile # project dir as session default
source ~/.profile # apply .profile changes
