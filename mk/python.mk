.PHONY:     get-python-version  ➤
get-python-version:
	@python3 --version

.PHONY: get-path-to-python ➤
get-path-to-python:
	@whereis python3
