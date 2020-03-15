# Folding@Home client docker file

## Running in Docker

Start by running:

```shell
docker run --rm -it cmendibl3/fahclient
```

To run with your own parameters run:

```shell
docker run --rm -it cmendibl3/fahclient --user=<your user> --team=<your team> --gpu=<false or true> --power=<medium or full>
```

## Running in Azure Container Instances

```shell
az group create -n <resource group name> -l westeurope
az container create --name fahclient --resource-group <resource group name> --image cmendibl3/fahclient:latest
```

Check logs:

```shell
az container logs -g <resource group name> -n fahclient --follow
```

## Running in Kubernetes

```shell
kubectl apply -f deployment.yaml
```
