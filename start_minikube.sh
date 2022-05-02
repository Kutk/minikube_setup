#!/bin/sh

#Run minikube
minikube start --driver=docker --force

#Add repo of Prometheus and Grafana
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update


cat <<EOF > values.yaml
prometheus:
  prometheusSpec:
    serviceMonitorSelectorNilUsesHelmValues: false
    serviceMonitorSelector: {}
    serviceMonitorNamespaceSelector: {}
grafana:
  sidecar:
    datasources:
      defaultDatasourceEnabled: true
  additionalDataSources:
    - name: Loki
      type: loki
      url: http://loki-loki-distributed-query-frontend.monitoring:3100
EOF


kubectl create ns monitoring
helm install prom prometheus-community/kube-prometheus-stack -n monitoring --values values.yaml

#Wait 240s for preparing pods
sleep 240

#Forward service
kubectl port-forward service/prom-kube-prometheus-stack-prometheus -n monitoring 9090:9090&
kubectl port-forward service/prom-grafana -n monitoring 3000:80&

#Install Loki
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update


cat << EOF > promtail-values.yaml
config:
  lokiAddress: "http://loki-loki-distributed-gateway/loki/api/v1/push"
EOF


helm upgrade --install promtail grafana/promtail -f promtail-values.yaml -n monitoring
helm upgrade --install loki grafana/loki-distributed -n monitoring

#Wait 240s for preparing pods
sleep 240

kubectl -n monitoring port-forward daemonset/promtail 3101 &

echo 'Please goto http://127.0.0.1:3000 to enter Grafana'
echo
echo 'The account: admin'
echo 'The passwd: prom-operator'
