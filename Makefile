SHELL := /bin/bash
.SHELLFLAGS := -ec
VENV_DIR = .venv
PYTHON = $(VENV_DIR)/bin/python
PIP = $(VENV_DIR)/bin/pip

.PHONY: all install run help setup-env db-upgrade docker-image

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
	docker build -t students-api:0.1.0 .



# help for commands
help:
	@echo "Available commands:"
	@echo "  make            	  - runs make install + setup-env"
	@echo "  make setup-env  	  - creates .env with database variable"
	@echo "  make create-log 	  - creates students_log directory for log collection"
	@echo "  make db-upgrade 	  - creates and upgrades the database"
	@echo "  make install    	  - Installs project dependencies"
	@echo "  make run             - Runs the application"
	@echo "  make docker-image    - create a docker image from current configuration;"
	@echo "                         default naming is 'students-api:0.1.0'"