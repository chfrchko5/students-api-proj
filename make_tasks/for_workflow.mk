# python linter ('ruff' & 'mypy')

.PHONY: ruff-install ruff-run mypy-install mypy-run

ruff-install:
	@echo "installing ruff package with pip"
	pip install ruff

ruff-run:
	@echo "running ruff python linter"
	ruff check *.py
	ruff check app
	ruff check tests


mypy-install:
	@echo "installing mypy with pip"
	pip install mypy

mypy-run:
	@echo "running mypy python static type checker"
	mypy *.py
	mypy app
	mypy tests