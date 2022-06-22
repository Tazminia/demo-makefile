# Makefile-demo

This repository is to display some features of Makefiles and test how it works. I learned about most of the concepts used here thanks to @looztra.

It is for learning purposes only.

## Prerequisites

`fzf` is used to create an interactive menu. To install `fzf` on MacOs:

```bash
brew install fzf
```

## Lab

### Usage of @

`@` in makefile is used to supress printing the command to be run. For instance:

```bash
tazminia@laptop:~$ make helloworld
Hi

tazminia@laptop:~$ make helloworld-debug
echo "Hi"
Hi
```

Now if we look at the code the only difference is the use of `@`

```makefile
helloworld:
	@echo "Hi"
helloworld-debug:
	echo "Hi"
```

### Usage of include

`include` allows to load code from other makefiles. For example:

```bash
tazminia@laptop:~$ make helloworld
Hi
tazminia@laptop:~$ make get-python-version
Python 3.9.13
```

- `helloworld` is a target in `Makefile`
- `get-python-version` is a target in `mk/python.mk` that was included in `Makefile`

### Usage of PHONY

Consider the following:

```bash
tazminia@laptop:~$ make helloworld
Hi
tazminia@laptop:~$ make helloworld
Hi
tazminia@laptop:~$ make foo.txt
Create file named foo.txt
tazminia@laptop:~$ make foo.txt
make: 'foo.txt' is up to date.
```

Usual targets run based on a file presence. This means that `foo.txt` will only run if no file named `foo.txt` is present in the directory.

```makefile
foo.txt:
	@echo "Create file named foo.txt"
	@touch foo.txt
```

In our case, the first execution creates the file `foo.txt`, so any following execution skips this target.

When defined with `.PHONY` like the target `helloworld`, make understands that no file is involved regarding this recipe and would run even if a file named `helloworld` exists.

```makefile
.PHONY: helloworld ➤
helloworld:
	@echo "Hi"
```

### Interactive menu with fzf

1. When no default target is defined and you run just `make` with no target, the first target available is called.
2. When a person has never used your makefile, it does not know what can be done with it, unless it reads the code.

So, the idea is:

1. To let the user choose the target to run when no target is defined.
2. Be able to present a list of goals available to the user.

The details on how this is achieved can be found [here](menu.md). If you simply want to test it, just run make.
