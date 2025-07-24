SHELL := /bin/bash
.SHELLFLAGS := -ec
VENV_DIR = .venv
PYTHON = $(VENV_DIR)/bin/python
PIP = $(VENV_DIR)/bin/pip

.PHONY: all install run help setup-env db-upgrade docker-image

all: install setup-env

$(VENV_DIR):
	python3 -m venv $(VENV_DIR)

setup-env:
	@if [ ! -f .env ]; then \
		echo "--> .env file not found. Creating a new one."; \
		echo 'DATABASE_URI="sqlite:///students.db"' > .env; \
	else \
		echo "--> .env file already exists. Skipping creation."; \
	fi

create-log:
	@if [ ! -d students_log ]; then \
		echo "students_log directory not found, creating"; \
		mkdir students_log; \
	else \
		echo "students_log directory already exists"; \
	fi

db-upgrade:
	@echo "upgrading flask db to create a database"
	@./.venv/bin/flask db upgrade

install: setup-env create-log db-upgrade $(VENV_DIR)
	@echo "installing project dependencies"
	$(PIP) install -r requirements.txt

run: install
	@echo "running the application"
	@echo "press CTRL + C to exit the app"
	$(PYTHON) run.py

docker-image:
	@echo "creating a docker image of the application"
	docker build -t students-api:0.1.0 .

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