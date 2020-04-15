
kubectl get Deployable --all-namespaces


kubectl get Subscription --all-namespaces


kubectl delete Deployable --all -n k8s-demo-app-ns

kubectl delete Deployable --all -n local


docker pull cp.icr.io/cp/icp-foundation/mcm-compliance:3.4.0
docker pull cp.icr.io/cp/icp-foundation/icp-multicluster-endpoint-operator:3.3.0
docker pull cp.icr.io/cp/icp-foundation/mcm-klusterlet:3.3.0
docker pull cp.icr.io/cp/icp-foundation/weave-collector:3.3.0
docker pull cp.icr.io/cp/icp-foundation/mcm-service-registry:3.3.0
docker pull cp.icr.io/cp/icp-foundation/mcm-operator:3.3.0
docker pull cp.icr.io/cp/icp-foundation/search-collector:3.3.0
docker pull cp.icr.io/cp/icp-foundation/subscription:3.3.0
docker pull cp.icr.io/cp/icp-foundation/klusterlet-component-operator:3.3.0
docker pull cp.icr.io/cp/icp-foundation/mcm-weave-scope:3.3.0
docker pull cp.icr.io/cp/icp-foundation/icp-management-ingress:2.5.0
docker pull cp.icr.io/cp/icp-foundation/icp-cert-manager-controller:0.10.0
docker pull cp.icr.io/cp/icp-foundation/tiller:v2.12.3-icp-3.2.2
docker pull cp.icr.io/cp/icp-foundation/coredns:1.2.6.1



