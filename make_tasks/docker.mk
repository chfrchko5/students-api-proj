.PHONY: docker-image compose compose-down db-cli api-cli docker-migrate docker-upgrade

# create a docker image of the project
# with a default name of 'students-api:0.1.0'
# ALSO USED FOR GITHUB ACTIONS WORKFLOW
docker-image:
	@echo "creating a docker image of the application"
	@echo "default version starts with 0.1.0"
	docker build -t students-api:0.1.0 .

compose:
	@echo "running docker compose to bring up db and api containers in the detached mode"
	docker compose up -d

compose-down:
	@echo "shutting docker compose containers down"
	docker compose down

db-cli:
	@echo "entering cli mode for the database container"
	docker compose exec db sh

api-cli:
	@echo "entering cli mode for the api container"
	docker compose exec students-api sh

docker-migrate:
	@echo "running 'flask db migrate' to a local sqlite database instance"
	docker compose exec db flask db migrate -m "$()"

docker-upgrade:
	@echo "running 'flask db migrate' to a local sqlite database instance"
	docker compose exec students-api flask db upgrade