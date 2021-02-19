# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    setup.sh                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: tmatis <tmatis@student.42.fr>              +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/02/17 14:40:23 by tmatis            #+#    #+#              #
#    Updated: 2021/02/19 19:38:39 by tmatis           ###   ########.fr        #
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

printf "\033[0;34mStarting minikube 🤩\n";
minikube --vm-driver=docker start 
printf "\033[0;34mSetup Kubernetes\n";
minikube addons enable ingress
minikube addons enable dashboard
echo "Launching dashboard 🖥️"
#minikube dashboard &> /dev/null &
#eval $(minikube docker-env)
#IP=$(kubectl get node -o=custom-columns='DATA:status.addresses[0].address' | sed -n 2p)
#printf "Minikube IP: ${IP}"
#docker build -t nginx_image ./srcs/nginx
#kubectl create -f ./srcs/
