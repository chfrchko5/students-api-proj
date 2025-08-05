# python linter ('ruff' & 'mypy')

.PHONY: ruff-install ruff-run

ruff-install:
	@echo "installing ruff package with pip"
	pip install ruff

ruff-run:
	@echo "running ruff python linter"
	ruff check *.py
	ruff check app
	ruff check tests