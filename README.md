# Taller práctico: Kubernetes + Minikube

Estudiante: **Alejandro Roque Morales** — ADSO  
Fecha: **27 de agosto de 2026**

Repositorio: [GirasolCallejeroTroi/KubernetesClase27Agosto](https://github.com/GirasolCallejeroTroi/KubernetesClase27Agosto)

Práctica declarativa sobre Minikube: namespace, ConfigMap, Secret, PVC, Deployment, Services, HPA e Ingress.

## Estructura

```
KubernetesClase27Agosto/
├── README.md
├── k8s/                 # Manifiestos que se aplican juntos
│   ├── 00-namespace.yaml
│   ├── 01-configmap.yaml
│   ├── 02-secret.yaml
│   ├── 03-pvc.yaml
│   ├── 04-deployment.yaml
│   ├── 05-service-clusterip.yaml
│   ├── 06-service-nodeport.yaml
│   ├── 07-hpa.yaml
│   └── 08-ingress.yaml
├── ejemplos/            # Pod suelto y Pod con PVC
├── docs/
│   ├── conceptos.md
│   └── comandos.md
└── scripts/
    └── flujo-practica.sh
```

## Qué queda desplegado

| Recurso | Nombre | Detalle |
|---------|--------|---------|
| Namespace | `practica` | Aislamiento del taller |
| ConfigMap | `nginx-config` | HTML + variables |
| Secret | `nginx-secretos` | Credenciales de demostración (`stringData`) |
| PVC | `nginx-volumen` | 1Gi `ReadWriteOnce` |
| Deployment | `nginx-deployment` | 3 réplicas, probes, límites, rolling update |
| Service | `nginx-clusterip` | Solo interno |
| Service | `nginx-nodeport` | Puerto de nodo **30080** |
| HPA | `nginx-hpa` | 3–10 réplicas (CPU 70%, memoria 80%) |
| Ingress | `nginx-ingress` | Host `miapp.local` → ClusterIP |

## Cómo probar

Requisitos: Docker, Minikube y `kubectl`.

```bash
chmod +x scripts/flujo-practica.sh
./scripts/flujo-practica.sh
```

A mano:

```bash
minikube start --driver=docker
minikube addons enable metrics-server
minikube addons enable ingress

kubectl apply -f k8s/
kubectl get all -n practica
kubectl rollout status deployment/nginx-deployment -n practica

# NodePort
minikube service nginx-nodeport -n practica --url

# Ingress (añadir IP de Minikube a /etc/hosts)
echo "$(minikube ip) miapp.local" | sudo tee -a /etc/hosts
# Luego: http://miapp.local
```

Pod de ejemplo (opcional, no forma parte del Deployment):

```bash
kubectl apply -f ejemplos/01-pod.yaml
kubectl apply -f ejemplos/02-pod-con-pvc.yaml
```

## Comandos útiles del taller

```bash
kubectl get pods -n practica -o wide
kubectl describe deployment nginx-deployment -n practica
kubectl logs -l app=nginx -n practica
kubectl exec -it deploy/nginx-deployment -n practica -- /bin/sh
kubectl scale deployment nginx-deployment -n practica --replicas=5
kubectl rollout undo deployment/nginx-deployment -n practica
kubectl top pods -n practica
```

## Limpieza

```bash
kubectl delete -f k8s/
kubectl delete -f ejemplos/
minikube delete
```

## Documentación

- [Conceptos de Kubernetes y Minikube](docs/conceptos.md)
- [Referencia de comandos](docs/comandos.md)

## Convención de commits

```
feat: nueva funcionalidad
fix: corrección
docs: documentación
chore: mantenimiento
```
