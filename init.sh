kind create cluster
helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring --create-namespace