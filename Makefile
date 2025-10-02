include make_tasks/*.mk

.PHONY: setup-env compose compose-down migrate upgrade app-cli

setup-env:
	@if [ ! -f .env ]; then \
		echo "--> .env file not found. Creating a new onea."; \
		echo 'DATABASE_URI="sqlite:///students.db"' > .env; \
	else \
		echo "--> .env file already exists. Skipping creation."; \
	fi

compose: setup-env
	@echo "running docker compose up to boot up dev environment for the app in detached mode"
	@echo "application's directories and files are mounted to the container for real time development"
	docker compose up -d

compose-down:
	@echo "shutting docker compose containers down"
	docker compose down

migrate:
	@echo "run database migration inside the container"
	@echo "for committing changes made in 'app/model.py'"
	docker compose exec db flask db migrate -m "$()"

upgrade:
	@echo "to apply database migrations inside the container"
	@echo "for applying changes saved by migration"
	docker compose exec db flask db upgrade

app-cli:
	@echo "entering cli mode for the api container"
	docker compose exec students-api sh

# help for commands
help:
	@echo "  make setup-env       - create environment variables for development"
	@echo "  make compose         - boot up the application for developing"
	@echo "  make compose-down    - shut down the application"
	@echo "  make migrate         - commit changes made in model.py"
	@echo "  make upgrade         - apply the changes made to database"
	@echo "  make app-cli         - enter cli in the application"