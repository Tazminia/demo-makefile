# Interactive Menu

The idea is to create a menu that will allow navigation between available make targets, search based on keyword and to run the selected target.

## Used tools

To create the menu we use:

- [grep](https://www.gnu.org/software/grep/manual/grep.html)
- [sed](https://www.gnu.org/software/sed/manual/sed.html)
- [fzf](https://bytexd.com/how-to-use-fzf-command-line-fuzzy-finder/) 

## Code breakdown

Code looks like the following:

```makefile
.DEFAULT_GOAL := find-target # Tell make that 'find-target' is the default target
.PHONY: find-target
find-target:
	@grep --no-filename -E '.PHONY:[[:space:]].*➤' $(MAKEFILE_LIST) \
	| sed -n -E "s/[[:space:]]+➤//p" \
	| sed -n -E "s/.PHONY:[[:space:]]+//p" \
	| fzf \
	| xargs -I '{}' make {}
```

- `grep`: search in Makefile and all included makefiles for lines containing `.PHONY:` followed by spaces then any characters and finally `➤`.

    ```bash
    tazminia@laptop:~$ grep --no-filename -E '.PHONY:[[:space:]].*➤'  \
        Makefile mk/python.mk mk/docker.mk
    .PHONY: helloworld ➤
    .PHONY: helloworld-debug ➤
    .PHONY:     get-python-version  ➤
    .PHONY: get-path-to-python ➤
    .PHONY: start-container ➤
    .PHONY: stop-container ➤
    ```
- first `sed`: take the result of grep and remove the trailing spaces along with `➤`.

    ```bash
    tazminia@laptop:~$ grep --no-filename -E '.PHONY:[[:space:]].*➤'  \
        Makefile mk/python.mk mk/docker.mk \
        | sed -n -E "s/[[:space:]]+➤//p"
    .PHONY: helloworld
    .PHONY: helloworld-debug
    .PHONY:     get-python-version
    .PHONY: get-path-to-python
    .PHONY: start-container
    .PHONY: stop-container
    ```

- Second `sed`: take the result of `sed` and remove `.PHONY:` and leading spaces.

    ```bash
    tazminia@laptop:~$ grep --no-filename -E '.PHONY:[[:space:]].*➤'  \
        Makefile mk/python.mk mk/docker.mk \
        | sed -n -E "s/[[:space:]]+➤//p" \
        | sed -n -E "s/.PHONY:[[:space:]]+//p"
    helloworld
    helloworld-debug
    get-python-version
    get-path-to-python
    start-container
    stop-container
    ```

- fzf: display make targets collected from `sed` and enables searching through them and selecting one.
- xargs: call `make` with the target selected using `fzf`.
