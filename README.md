# manifest
A single source of truth repo for argocd

## setting up Prometheus Monitoring on Kubernetes using Helm and Prometheus Operator

1. Creating all configuration YAML files yourself and execute them in right order
prometheus stateful set
alert manager
Grafana deployment
config maps/ secrets
-> inefficient and lot of effort

2. Using operator
use a operator that manages the combination of all prometheus components as one unit
-> find prometheus operator
-> deploy in k8s cluster

3. Using Helm chart
use Helm chart maintained by helm community to deploy prometheus operator 