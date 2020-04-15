
cd k8sdemo
docker build -t k8sdemo:1.0.1 .
docker tag k8sdemo:1.0.1 niklaushirt/k8sdemo:1.0.1
docker push niklaushirt/k8sdemo:1.0.1

cd ..
cd k8sdemo_backend
docker build -t k8sdemo-backend:1.0.1 .
docker tag k8sdemo-backend:1.0.1 niklaushirt/k8sdemo-backend:1.0.1
docker push k8sdemo-backend:1.0.1