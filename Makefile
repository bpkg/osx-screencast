
CWD ?= $(shell pwd)
BIN ?= osx-screencast
CMDS ?= record export dependencies
PREFIX ?= /usr/local

$(BIN): install

install: uninstall
	cp osx-screencast.sh $(PREFIX)/bin/$(BIN)
	for c in $(CMDS); do cp $${c}.sh $(PREFIX)/bin/$(BIN)-$${c}; done

uninstall:
	rm -f $(PREFIX)/bin/$(BIN)
	for c in $(CMDS); do rm -f $(PREFIX)/bin/$(BIN)-$${c}; done

link: uninstall
	ln -s $(CWD)/osx-screencast.sh $(PREFIX)/bin/$(BIN)
	for c in $(CMDS); do ln -s $(CWD)/$${c}.sh $(PREFIX)/bin/$(BIN)-$${c}; done
