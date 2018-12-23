curl -fsSL get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo systemctl start docker.service
sudo systemctl enable docker.service
sudo usermod -aG docker `whoami`
