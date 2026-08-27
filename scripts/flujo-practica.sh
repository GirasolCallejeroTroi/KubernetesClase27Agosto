#!/usr/bin/env bash
# Flujo de práctica: Minikube + manifiestos del taller.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
NS="practica"

echo "==> 1. Iniciar Minikube"
minikube start --driver=docker

echo "==> 2. Add-ons (HPA e Ingress)"
minikube addons enable metrics-server
minikube addons enable ingress

echo "==> 3. Verificar cluster"
kubectl get nodes
kubectl cluster-info

echo "==> 4. Aplicar manifiestos"
kubectl apply -f "${ROOT}/k8s/"

echo "==> 5. Esperar a que el Deployment esté listo"
kubectl rollout status deployment/nginx-deployment -n "${NS}"

echo "==> 6. Estado de recursos"
kubectl get all -n "${NS}"
kubectl get ingress -n "${NS}"
kubectl get pvc -n "${NS}"
kubectl get hpa -n "${NS}"

echo "==> 7. URL NodePort"
minikube service nginx-nodeport -n "${NS}" --url

echo
echo "Ingress: añade esto a /etc/hosts y abre http://miapp.local"
echo "  $(minikube ip)  miapp.local"
echo
echo "Limpieza posterior:"
echo "  kubectl delete -f ${ROOT}/k8s/"
echo "  minikube delete"
