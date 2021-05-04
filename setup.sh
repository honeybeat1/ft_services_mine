#!/bin/sh

# start minikube
export MINIKUBE_HOME=/Users/dachung/goinfre/
echo "Starting minikube..."
minikube start --vm-driver=virtualbox --extra-config=apiserver.service-node-port-range=1-35000


# minikube - docker connect
echo "Eval.."
eval $(minikube docker-env)

# addons
echo "Enabling addons..."
minikube addons enable metrics-server
minikube addons enable dashboard

echo "Launching dashboard.."
minikube dashboard &

# IP config as minikube IP
IP=$(kubectl get node -o=custom-columns='DATA:status.addresses[0].address' | sed -n 2p)
printf "Minikube IP: ${IP}"

# build images
echo "Building images.."
docker build -t nginx ./srcs/nginx
#docker run -it -p 80:80 -p 443:443 nginx
# IP 주소가 바뀌기 때문에 해당 미니큐브 주소로 IP 설정
docker build -t mysql ./srcs/mysql --build-arg IP=${IP}
docker build -t wordpress ./srcs/wordpress --build-arg IP=${IP}
docker build -t phpmyadmin ./srcs/phpmyadmin --build-arg IP=${IP}
docker build -t influxdb ./srcs/influxdb
docker build -t telegraf ./srcs/telegraf
docker build -t grafana ./srcs/grafana
docker build -t ftps ./srcs/ftps --build-arg IP=${IP}

# metalLB to make Service as LoadBalancer Type
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl apply -f ./srcs/metalLB_config.yaml

# now make service.yaml
echo "Creating pods and services.."
kubectl create -f ./srcs/nginx.yaml
kubectl create -f ./srcs/mysql.yaml
kubectl create -f ./srcs/wordpress.yaml
kubectl create -f ./srcs/phpmyadmin.yaml
kubectl create -f ./srcs/influxdb.yaml
kubectl create -f ./srcs/telegraf.yaml
kubectl create -f ./srcs/grafana.yaml
kubectl create -f ./srcs/ftps.yaml


# open http://$IP
minikube service list
IP=$(kubectl get node -o=custom-columns='DATA:status.addresses[0].address' | sed -n 2p)
printf "Minikube IP: ${IP}"
