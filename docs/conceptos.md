# Conceptos de Kubernetes y Minikube

Notas de clase — 27 de agosto de 2026. Estudiante: **Alejandro Roque Morales** (ADSO).

## ¿Qué es Kubernetes?

Plataforma open source de **orquestación de contenedores**. Automatiza el despliegue, el escalado y la gestión de aplicaciones en contenedores. Nació en Google (sistema interno Borg), se donó a la CNCF en 2015 y es el estándar de la industria.

## Por qué se usa

| Problema | Qué resuelve Kubernetes |
|----------|-------------------------|
| Un contenedor se cae y no se recupera | Auto-recuperación: reinicia contenedores fallidos |
| Hay que escalar según la demanda | Auto-escalado de réplicas |
| Las IPs de los contenedores cambian | Service Discovery con DNS estable |
| Actualizar sin cortar el servicio | Rolling updates sin downtime |
| Repartir tráfico entre instancias | Load balancing entre Pods |
| Desplegar en varios entornos | Portabilidad: nube u on-premise |

## Arquitectura

Kubernetes es un **cluster** (conjunto de máquinas) con dos tipos de nodos.

### Control Plane (Master)

Cerebro del cluster. Componentes:

- **API Server:** punto de entrada. Recibe y valida comandos de `kubectl`.
- **etcd:** base de datos distribuida con el estado y la configuración.
- **Scheduler:** elige en qué worker corre cada Pod, según recursos.
- **Controller Manager:** controladores que corrigen el estado real hacia el deseado.
- **Cloud Controller Manager:** integración con AWS, Azure, GCP, etc.

### Workers

Donde corren las aplicaciones:

- **kubelet:** agente en cada nodo. Habla con el API Server y gestiona Pods.
- **kube-proxy:** reglas de red entre Pods y Services.
- **Container Runtime:** Docker, containerd o CRI-O.

## Conceptos fundamentales

**Pod.** Unidad mínima desplegable. Uno o más contenedores que comparten IP, volúmenes y contexto de red. Analogía: cápsula espacial; los astronautas (contenedores) viajan juntos.

**Service.** Interfaz de red estable. Los Pods son efímeros; el Service no.

| Tipo | Acceso |
|------|--------|
| ClusterIP | Solo dentro del cluster (por defecto) |
| NodePort | Puerto en cada nodo (rango 30000–32767) |
| LoadBalancer | Balanceador externo (nube) |
| ExternalName | Alias DNS externo |

Flujo NodePort:

```
Cliente → Nodo:30080 (nodePort) → Service:80 (port) → Pod:80 (targetPort)
```

**Deployment.** Declara el estado deseado, replica Pods, hace rolling update/rollback y auto-recuperación. Gestiona ReplicaSets, y estos gestionan Pods.

**Namespace.** Aislamiento lógico (equipos, proyectos, entornos: dev, staging, prod).

**ConfigMap.** Configuración no sensible (variables, archivos).

**Secret.** Datos sensibles (contraseñas, tokens, claves) en base64. Mejor usar `stringData` y dejar que Kubernetes lo codifique.

## Imperativo vs declarativo

| Estilo | Idea | Ejemplo |
|--------|------|---------|
| Imperativo | Le dices QUÉ hacer, paso a paso | `kubectl create deployment nginx --image=nginx` |
| Declarativo | Le dices CÓMO debe quedar el estado | `kubectl apply -f deployment.yaml` |

Kubernetes prefiere lo declarativo: versionado (GitOps), replicable, recuperable y colaborativo.

Un recurso se identifica por `apiVersion` + `kind` + `metadata.name`. La terna `kind` + `name` + `namespace` debe ser única.

## Minikube

Cluster Kubernetes de **un nodo** en la máquina local. Sirve para aprender, desarrollar y experimentar sin nube.

- Drivers: Docker, VirtualBox, Hyper-V, KVM, VMware.
- Add-ons: Dashboard, Ingress, Metrics Server.
- Multi-nodo experimental.
- Linux, macOS y Windows.

`kubectl` es el control remoto:

```
kubectl [comando] [tipo-de-recurso] [nombre] [flags]
```
