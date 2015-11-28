#!/bin/bash

GO_URL=https://storage.googleapis.com/golang/go1.5.1.linux-amd64.tar.gz

TOP_DIR=`pwd`

sudo apt-get install -y wget

#Install Go 
if  [ ! -d $TOP_DIR/go ] ; then
  wget $GO_URL
  tar zxvf $(basename $GO_URL)
fi


export GOROOT=$TOP_DIR/go
export GOPATH=$TOP_DIR/godep
export PATH=$GOROOT/bin:$PATH

mkdir -p $GOPATH

git clone https://github.com/GoogleCloudPlatform/kubernetes

cd kubernetes

export KUBERNETES_CONTRIB=mesos

make

cd $TOP_DIR

echo "FROM $HUB_USER/kubernetes" > Dockerfile.km
cat Dockerfile.km.template >> Dockerfile.km

echo "FROM $HUB_USER/kubernetes" > Dockerfile.kubelet
cat Dockerfile.kubelet.template >> Dockerfile.kubelet

sudo docker build -t $HUB_USER/kubernetes -f Dockerfile.kubernetes --no-cache .
sudo docker build -t $HUB_USER/km -f Dockerfile.km --no-cache .
sudo docker build -t $HUB_USER/kubelet -f Dockerfile.kubelet --no-cache .