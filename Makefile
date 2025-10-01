include make_tasks/*.mk

.PHONY: init argocd-start argocd-delete

# runs the script to configure some things before starting the proj
init:
	@echo "running the 'initialization.sh' script"
	./initialization.sh

argocd-start:
	@echo "installing argocd manifest file for the application stack"
	cd ./argocd_manifests
	kubectl create -f app.yaml

argocd-delete:
	@echo "deleting the stack deployed by argocd"

	@echo "observ-stack"
	kubectl patch app -n argocd argo-observ-stack  -p '{"metadata": {"finalizers": null}}' --type merge
	kubectl delete app -n argocd argo-observ-stack

	@echo "students-app-stack"
	kubectl patch app -n argocd argo-students-app-stack  -p '{"metadata": {"finalizers": null}}' --type merge
	kubectl delete app -n argocd argo-students-app-stack