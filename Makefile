.PHONY: docs

docs:
	terraform-docs markdown . --hide modules --output-file README.md
