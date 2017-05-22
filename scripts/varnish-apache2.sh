sudo apt-get install -y varnish apache2


sudo apt-get install -y apache2

sudo apt-get install apt-transport-https

curl https://repo.varnish-cache.org/ubuntu/GPG-key.txt | sudo apt-key add -


sudo sh -c 'echo "deb https://repo.varnish-cache.org/ubuntu/ trusty varnish-4.0" >> /etc/apt/sources.list.d/varnish-cache.list'

sudo apt-get update

sudo apt-get install -y varnish