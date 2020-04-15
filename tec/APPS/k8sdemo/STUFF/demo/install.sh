

kubectl apply -f app_frontend.yaml
kubectl apply -f app_backend.yaml
kubectl apply -f deployables_frontend.yaml
kubectl apply -f deployables_backend.yaml




kubectl delete -f app_frontend.yaml
kubectl delete -f app_backend.yaml
kubectl delete -f deployables_frontend.yaml
kubectl delete -f deployables_backend.yaml

