

kubectl -n grpcdemo-app create secret generic icam-grpcapp-secret --from-file=keyfiles/keyfile.p12 --from-file=global.environment


kubectl apply -f namespace.yaml
kubectl apply -f 2_mcm-app/1-app.yaml
kubectl apply -f 2_mcm-app/2-app-channel.yaml
kubectl apply -f 2_mcm-app/3-app-web.yaml
kubectl apply -f 2_mcm-app/4-app-web-deployables.yaml
