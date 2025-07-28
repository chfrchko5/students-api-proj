SHELL := /bin/bash
.SHELLFLAGS := -ec
VENV_DIR = .venv
PYTHON = $(VENV_DIR)/bin/python
PIP = $(VENV_DIR)/bin/pip

.PHONY: all install run help setup-env db-upgrade docker-image compose $(VENV_DIR) local-migrate local-upgrade docker-migrate docker-upgrade db-cli api-cli

# running 'make' will run these:
all: install setup-env


# set up a virtual environment
$(VENV_DIR):
	python3 -m venv $(VENV_DIR)


# if env variable for LOCAL IN-APP database doesnt exist
# then create and insert it inside
setup-env:
	@if [ ! -f .env ]; then \
		echo "--> .env file not found. Creating a new one."; \
		echo 'DATABASE_URI="sqlite:///students.db"' > .env; \
	else \
		echo "--> .env file already exists. Skipping creation."; \
	fi


# if directory for students_log doesnt exist then create
# need it for app to run and work, storing logs inside
create-log:
	@if [ ! -d students_log ]; then \
		echo "students_log directory not found, creating"; \
		mkdir students_log; \
	else \
		echo "students_log directory already exists"; \
	fi


# run db upgrade to update the db table
db-upgrade:
	@echo "upgrading flask db to create a database"
	@./.venv/bin/flask db upgrade


# install project requirements
install: setup-env create-log db-upgrade $(VENV_DIR)
	@echo "installing project dependencies"
	$(PIP) install -r requirements.txt


# if ran standalone, then first the install part will run
# then the app itself
run: install
	@echo "running the application"
	@echo "press CTRL + C to exit the app"
	$(PYTHON) run.py


# create a docker image of the project
# with a default name of 'students-api:0.1.0'
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

local-migrate:
	@echo "running 'flask db migrate' on the local sqlite database instance"
	flask db migrate -m "$()"

local-upgrade:
	@echo "running 'flask db upgrade' on the local sqlite database instance"
	flask db upgrade

docker-migrate:
	@echo "running 'flask db migrate' to a local sqlite database instance"
	docker compose exec db flask db migrate -m "$()"

docker-upgrade:
	@echo "running 'flask db migrate' to a local sqlite database instance"
	docker compose exec students-api flask db upgrade


# help for commands
help:
	@echo "Available commands:"
	@echo "------- LOCAL SETUP -------"
	@echo "  make            	  - installs and runs the app locally"
	@echo "  make setup-env  	  - creates .env with database variable"
	@echo "  make create-log 	  - creates students_log directory for log collection"
	@echo "  make db-upgrade 	  - creates and upgrades the database"
	@echo "  make install    	  - installs project dependencies"
	@echo "  make run 	          - runs the application"

	@echo ""

	@echo "------- CONTAINER SETUP -------"
	@echo "  make docker-image    - create a docker image from current configuration;"
	@echo "                         default naming is 'students-api:0.1.0'"
	@echo "  make compose         - run both db and api containers via docker compose"
	@echo "  make local-migrate   - run local migration of the database"
	@echo "  make local-upgrade   - run local upgrade of the database"
	@echo "  make docker-migrate  - run database migration in db docker container via docker compose"
	@echo "  make docker-upgrade  - run database upgrade in db docker container via docker compose"
	@echo "  make db-cli          - enter cli mode for db container"
	@echo "  make api-cli         - enter cli mode for api container"