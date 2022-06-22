include mk/docker.mk
include mk/python.mk

.PHONY: helloworld ➤
helloworld:
	@echo "Hi"

.PHONY: helloworld-debug ➤
helloworld-debug:
	echo "Hi"

foo.txt:
	@echo "Create file named foo.txt"
	@touch foo.txt

.PHONY: not-important-task
not-important-task:
	@echo "This task is not important and can be ignored"



## Target to be invoked if make command is called without a specified target
.DEFAULT_GOAL := find-target
.PHONY: find-target
find-target:
	@grep --no-filename -E '.PHONY:[[:space:]].*➤' $(MAKEFILE_LIST) \
	| sed -n -E "s/[[:space:]]+➤//p" \
	| sed -n -E "s/.PHONY:[[:space:]]+//p" \
	| fzf \
	| xargs -I '{}' make {}
