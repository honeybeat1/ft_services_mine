#!/bin/sh

# start minikube
export MINIKUBE_HOME=/Users/dachung/goinfre/
echo "Starting minikube..."
minikube start --driver=virtualbox

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
cat ./my_password.txt | docker login --username honeybeat1 --password-stdin
docker build -t nginx ./srcs/nginx
#docker run -it -p 80:80 -p 443:443 nginx

# metalLB to make Service as LoadBalancer Type
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl apply -f ./srcs/metalLB_config.yaml

# now make service.yaml
echo "Creating pods and services.."
kubectl create -f ./srcs/nginx.yaml

# open http://$IP
minikube service list
IP=$(kubectl get node -o=custom-columns='DATA:status.addresses[0].address' | sed -n 2p)
printf "Minikube IP: ${IP}"
