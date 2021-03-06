# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    setup.sh                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: tmatis <tmatis@student.42.fr>              +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/02/17 14:40:23 by tmatis            #+#    #+#              #
#    Updated: 2021/02/24 17:20:21 by tmatis           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

printf "\033[0;34mHi, welcome to tmatis's ft_services 😇\n\n";

printf "Verifing if docker is installed: ";

if [ -x "$(command -v docker)" ]; then
	printf "\033[0;32m[OK]\n"
else
	printf "\033[0;31m[KO]\n"
	printf "\033[0;36mInstalling docker..\n";
	printf "Downloading docker ...\n";
	wget -q --show-progress https://download.docker.com/linux/static/stable/x86_64/docker-20.10.3.tgz
	printf "Installing docker\n";
	tar -xzf docker-20.10.3.tgz
	rm -rf docker-20.10.3.tgz
	sudo cp docker/* /usr/bin/
	rm -rf ./docker/
	printf "\033[0;34mInit docker: "
	sudo dockerd &> /dev/null &
	printf "\033[0;32m[OK]\n\033[0m"
	sudo groupadd docker &> /dev/null
	sudo usermod -aG docker ${USER}
fi

printf "\033[0;34mVerifing if minikube is installed: ";

if [ -x "$(command -v minikube)" ]; then
	printf "\033[0;32m[OK]\n"
else
	printf "\033[0;31m[KO]\n"
	printf "\033[0;34mDownloading minikube ...\n";
	wget -q --show-progress https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
	printf "Installing minikube ...\n";
	sudo install minikube-linux-amd64 /usr/bin/minikube
	rm -rf minikube-linux-amd64
fi

printf "\033[0;34mVerifing if kubectl is installed: ";

if [ -x "$(command -v kubectl)" ]; then
	printf "\033[0;32m[OK]\n"
else
	printf "\033[0;31m[KO]\n"
	printf "\033[0;34mDownloading kubectl  ...\n";
	wget -q --show-progress https://storage.googleapis.com/kubernetes-release/release/v1.20.0/bin/linux/amd64/kubectl
	printf "Installing kubectl ...\n";
	chmod +x ./kubectl
	sudo mv ./kubectl /usr/bin/kubectl
fi
printf "\033[0;34mSetup docker socket perm\n";
sudo chmod 777 /var/run/docker.sock
printf "\033[0;34mStarting minikube 🤩\n";
minikube --vm-driver=docker start 
eval $(SHELL=/bin/bash minikube docker-env)
minikube addons enable metrics-server
minikube addons enable dashboard
printf "\033[0;34mSetup metallb\n";
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl apply -f srcs/metallb.yaml
minikube dashboard &> /dev/null &
printf "👷 building influxdb image\n"
docker build --network=host -t influxdb_image ./srcs/influxdb &> /dev/null
kubectl create -f ./srcs/deploy/influxdb.yaml
printf "👷 building mysql image\n"
docker build --network=host -t mysql_image ./srcs/mysql &> /dev/null
kubectl create -f ./srcs/deploy/mysql.yaml
printf "👷 building phpmyadmin image\n"
docker build --network=host -t phpmyadmin_image ./srcs/phpmyadmin &> /dev/null
kubectl create -f ./srcs/deploy/phpmyadmin.yaml
printf "👷 building wordpress image\n"
docker build --network=host -t wordpress_image ./srcs/wordpress &> /dev/null
kubectl create -f ./srcs/deploy/wordpress.yaml
printf "👷 building nginx image\n"
docker build --network=host -t nginx_image ./srcs/nginx &> /dev/null
kubectl create -f ./srcs/deploy/nginx.yaml
printf "👷 building grafana image\n"
docker build --network=host -t grafana_image ./srcs/grafana &> /dev/null
kubectl create -f ./srcs/deploy/grafana.yaml
printf "👷 building ftps image\n"
docker build --network=host -t ftps_image ./srcs/ftps &> /dev/null
kubectl create -f ./srcs/deploy/ftps.yaml
