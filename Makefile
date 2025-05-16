.PHONY: help install init shell clean build-docs serve-docs lint format check precommit

# General help
help:
	@echo ""
	@echo "Usage: make <command>"
	@echo ""
	@echo "Available commands:"
	@echo "  install        Install project dependencies via Poetry"
	@echo "  init           Set up the environment (dependencies + hooks + docs)"
	@echo "  shell          Activate the Poetry virtual environment"
	@echo "  build-docs     Build documentation with Sphinx"
	@echo "  serve-docs     Start a local Sphinx server with live reload"
	@echo "  lint           Run Ruff linter"
	@echo "  format         Format code using Ruff"
	@echo "  check          Run linter and type checker (Ruff + MyPy)"
	@echo "  precommit      Run all pre-commit hooks"
	@echo "  clean          Remove build and cache files"
	@echo ""

# Install all dependencies (without installing the package itself)
install:
	poetry install --no-root

# Full environment setup (install + hooks + docs prep)
init: install
	poetry run pre-commit install
	poetry run pre-commit autoupdate
	@echo "✔️  Environment initialized and pre-commit hooks installed."

# Open the Poetry-managed shell
shell:
	poetry shell

# Build the Sphinx HTML documentation
build-docs:
	poetry run sphinx-build -b html docs/source docs/build/html
	@echo "✔️  Documentation built in docs/build/html"

# Serve docs with live reload (autobuild)
serve-docs:
	poetry run sphinx-autobuild docs/source docs/build/html

# Run Ruff linter
lint:
	poetry run ruff check src

# Format code using Ruff
format:
	poetry run ruff format src

# Lint + type check (MyPy)
check:
	poetry run ruff check src
	poetry run mypy src

# Run pre-commit hooks on all files
precommit:
	poetry run pre-commit run --all-files

# Clean up temporary and build files
clean:
	find . -type d -name '__pycache__' -exec rm -rf {} +
	find . -type d -name '.pytest_cache' -exec rm -rf {} +
	rm -rf .mypy_cache .ruff_cache docs/build htmlcov dist .tox .nox coverage.xml
	@echo "✔️  Cleanup completed."
