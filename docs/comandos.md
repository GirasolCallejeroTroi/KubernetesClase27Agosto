# Referencia rápida: kubectl, Minikube y YAML

## kubectl

### Cluster y nodos

```bash
kubectl cluster-info
kubectl version
kubectl get nodes
kubectl get nodes -o wide
kubectl describe node <nombre>
```

### Pods

```bash
kubectl get pods
kubectl get pods -n <namespace>
kubectl get pods -o wide
kubectl get pods --all-namespaces
kubectl get pods -l app=nginx
kubectl describe pod <nombre>
kubectl logs <nombre-pod>
kubectl logs <nombre-pod> -c <contenedor>
kubectl logs <nombre-pod> -f
kubectl logs <nombre-pod> --previous
kubectl exec -it <nombre-pod> -- /bin/sh
kubectl exec <nombre-pod> -- ls /
kubectl port-forward <nombre-pod> 8080:80
kubectl delete pod <nombre>
kubectl delete pod <nombre> --force --grace-period=0
```

### Deployments

```bash
kubectl get deployments
kubectl describe deployment <nombre>
kubectl apply -f deployment.yaml
kubectl delete deployment <nombre>
kubectl scale deployment <nombre> --replicas=5
kubectl autoscale deployment <nombre> --min=2 --max=10 --cpu-percent=80
kubectl rollout status deployment/<nombre>
kubectl rollout history deployment/<nombre>
kubectl set image deployment/<nombre> <contenedor>=<imagen>
kubectl rollout undo deployment/<nombre>
kubectl rollout undo deployment/<nombre> --to-revision=1
kubectl rollout pause deployment/<nombre>
kubectl rollout resume deployment/<nombre>
```

### Services, namespaces, config

```bash
kubectl get svc
kubectl describe service <nombre>
kubectl get endpoints <nombre-svc>
kubectl expose deployment <nombre> --type=NodePort --port=80

kubectl get namespaces
kubectl create namespace <nombre>
kubectl delete namespace <nombre>
kubectl config set-context --current --namespace=<nombre>
kubectl get all -n <nombre>

kubectl get configmaps
kubectl get secrets
kubectl create configmap <nombre> --from-literal=clave=valor
kubectl create secret generic <nombre> --from-literal=password=secreto
```

### Utilidades

```bash
kubectl apply -f <archivo.yaml>
kubectl apply -f <directorio>/
kubectl delete -f <archivo.yaml>
kubectl get all
kubectl get events --sort-by='.lastTimestamp'
kubectl top nodes
kubectl top pods
kubectl explain pod.spec
kubectl cp <archivo> <pod>:<ruta>
```

## Minikube

```bash
minikube start --driver=docker
minikube start --cpus=4 --memory=8192
minikube stop
minikube delete
minikube status
minikube ip
minikube ssh
minikube dashboard
minikube service <nombre> --url
minikube addons list
minikube addons enable metrics-server
minikube addons enable ingress
minikube tunnel
minikube docker-env
eval $(minikube docker-env)
minikube image load <imagen>
```

## apiVersion por recurso

| Recurso | apiVersion |
|---------|------------|
| Pod, Service, ConfigMap, Secret, Namespace, PVC, ServiceAccount | `v1` |
| Deployment, ReplicaSet, StatefulSet, DaemonSet | `apps/v1` |
| Job, CronJob | `batch/v1` |
| Ingress, NetworkPolicy | `networking.k8s.io/v1` |
| HorizontalPodAutoscaler | `autoscaling/v2` |
| Role, ClusterRole | `rbac.authorization.k8s.io/v1` |
