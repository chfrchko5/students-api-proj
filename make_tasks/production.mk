.PHONY: init minikube-start argocd-create argocd-delete grafana-ui help-prod

# makefile containing targets to run and set up production environment
# uses minikube and argocd

init:
	@echo "running initialization script to install the following:"
	@echo "--- minikube ---"
	@echo "--- argocd ---"
	@echo "also creates necessary namespaces for the deployment"
	./initialization.sh

minikube-start:
	@echo "manually running the 2 node kubernetes cluster"
	minikube start

argocd-create:
	@echo "run argocd manifest to deploy 2 helm charts on minikube cluster"
	kubectl create -f argocd_manifests/app.yaml
	
argocd-delete:
	@echo "delete the stack deployed by argocd"

	@echo "observ-stack"
	kubectl patch app -n argocd argo-observ-stack  -p '{"metadata": {"finalizers": null}}' --type merge
	kubectl delete app -n argocd argo-observ-stack

	@echo "app-stack"
	kubectl patch app -n argocd argo-students-app-stack  -p '{"metadata": {"finalizers": null}}' --type merge
	kubectl delete app -n argocd argo-students-app-stack

grafana-ui:
	@echo "access grafana UI for detailed information about the k8s cluster and application stack"
	@echo "login: admin"
	@echo "password: prom-operator"
	export POD_NAME=$(kubectl --namespace default get pod -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=observ-stack" -oname)
	kubectl --namespace default port-forward $POD_NAME 3000

help-prod:
	@echo "  make init             - sets up pre-requisites for production environment"
	@echo "  make minikube-start   - to manually start minikube cluster in subsequent launches"
	@echo "  make argocd-create    - for creating the argocd stack with app and observability helm charts"
	@echo "  make argocd-delete    - to delete the argocd stack from the k8s cluster"
	@echo "  make grafana-ui       - to access grafana ui via port-forwarding"