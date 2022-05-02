# minikube_setup
This repository is for automatically setting up minikube environment and installing Grafana, Prometheus and Loki.

## Reqiruement
These scripts are for CentOS 7.9 distribution. Please install **Gnome Desktop** version.

## Usage
### Step 1. Prepare Environment
```sh env_setup.sh```

### Step 2. Start minikube
```sh start_minikube.sh```

## Hint
### Delete cluster
If you want to delete minikube cluster, you can use ```minikube delete```. 

Then use **start_minikube.sh** again to install Grafana, Prometheus and Loki again.

### Stop cluster
```minikube stop```

This command will stop the minikube cluster and save current status of your working progress.

When you want to continue your cluster, use the below command to continue.

```minikube start --driver=docker --force```
