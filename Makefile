# NAME=pczerkas VERSION=3.200.14-20221110 make all release tag_latest release_latest

NAME := $(or $(NAME),$(NAME),selenium)
VERSION := $(or $(VERSION),$(VERSION),3.141.59-20210929)
NAMESPACE := $(or $(NAMESPACE),$(NAMESPACE),$(NAME))
AUTHORS := $(or $(AUTHORS),$(AUTHORS),SeleniumHQ)
PLATFORM := $(shell uname -s)
BUILD_ARGS := $(BUILD_ARGS)
MAJOR := $(word 1,$(subst ., ,$(VERSION)))
MINOR := $(word 2,$(subst ., ,$(VERSION)))
MAJOR_MINOR_PATCH := $(word 1,$(subst -, ,$(VERSION)))

all: hub chrome firefox opera edge chrome_debug firefox_debug opera_debug edge_debug standalone_chrome standalone_firefox standalone_opera standalone_edge standalone_chrome_debug standalone_firefox_debug standalone_opera_debug standalone_edge_debug

generate_all:	\
	generate_hub \
	generate_nodebase \
	generate_chrome \
	generate_firefox \
	generate_opera \
	generate_edge \
	generate_chrome_debug \
	generate_firefox_debug \
	generate_opera_debug \
	generate_edge_debug \
	generate_standalone_firefox \
	generate_standalone_chrome \
	generate_standalone_opera \
	generate_standalone_edge \
	generate_standalone_firefox_debug \
	generate_standalone_chrome_debug \
	generate_standalone_opera_debug \
	generate_standalone_edge_debug

build: all

ci: build test

base:
	cd ./Base && docker build $(BUILD_ARGS) -t $(NAME)/selenium-base:$(VERSION) .

generate_hub:
	cd ./Hub && ./generate.sh $(VERSION) $(NAMESPACE) $(AUTHORS)

hub: base generate_hub
	cd ./Hub && docker build $(BUILD_ARGS) -t $(NAME)/selenium-hub:$(VERSION) .

generate_nodebase:
	cd ./NodeBase && ./generate.sh $(VERSION) $(NAMESPACE) $(AUTHORS)

nodebase: base generate_nodebase
	cd ./NodeBase && docker build $(BUILD_ARGS) -t $(NAME)/selenium-node-base:$(VERSION) .

generate_chrome:
	cd ./NodeChrome && ./generate.sh $(VERSION) $(NAMESPACE) $(AUTHORS)

chrome: nodebase generate_chrome
	cd ./NodeChrome && docker build $(BUILD_ARGS) -t $(NAME)/selenium-node-chrome:$(VERSION) .

generate_firefox:
	cd ./NodeFirefox && ./generate.sh $(VERSION) $(NAMESPACE) $(AUTHORS)

firefox: nodebase generate_firefox
	cd ./NodeFirefox && docker build $(BUILD_ARGS) -t $(NAME)/selenium-node-firefox:$(VERSION) .

generate_opera:
	cd ./NodeOpera && ./generate.sh $(VERSION) $(NAMESPACE) $(AUTHORS)

opera: nodebase generate_opera
	cd ./NodeOpera && docker build $(BUILD_ARGS) -t $(NAME)/selenium-node-opera:$(VERSION) .

generate_edge:
	cd ./NodeEdge && ./generate.sh $(VERSION) $(NAMESPACE) $(AUTHORS)

edge: nodebase generate_edge
	cd ./NodeEdge && docker build $(BUILD_ARGS) -t $(NAME)/selenium-node-edge:$(VERSION) .

generate_standalone_firefox:
	cd ./Standalone && ./generate.sh StandaloneFirefox selenium-node-firefox Firefox $(VERSION) $(NAMESPACE) $(AUTHORS)

standalone_firefox: firefox generate_standalone_firefox
	cd ./StandaloneFirefox && docker build $(BUILD_ARGS) -t $(NAME)/selenium-standalone-firefox:$(VERSION) .

generate_standalone_firefox_debug:
	cd ./StandaloneDebug && ./generate.sh StandaloneFirefoxDebug selenium-node-firefox-debug Firefox $(VERSION) $(NAMESPACE) $(AUTHORS)

standalone_firefox_debug: firefox_debug generate_standalone_firefox_debug
	cd ./StandaloneFirefoxDebug && docker build $(BUILD_ARGS) -t $(NAME)/selenium-standalone-firefox-debug:$(VERSION) .

generate_standalone_chrome:
	cd ./Standalone && ./generate.sh StandaloneChrome selenium-node-chrome Chrome $(VERSION) $(NAMESPACE) $(AUTHORS)

standalone_chrome: chrome generate_standalone_chrome
	cd ./StandaloneChrome && docker build $(BUILD_ARGS) -t $(NAME)/selenium-standalone-chrome:$(VERSION) .

generate_standalone_chrome_debug:
	cd ./StandaloneDebug && ./generate.sh StandaloneChromeDebug selenium-node-chrome-debug Chrome $(VERSION) $(NAMESPACE) $(AUTHORS)

standalone_chrome_debug: chrome_debug generate_standalone_chrome_debug
	cd ./StandaloneChromeDebug && docker build $(BUILD_ARGS) -t $(NAME)/selenium-standalone-chrome-debug:$(VERSION) .

generate_standalone_opera:
	cd ./Standalone && ./generate.sh StandaloneOpera selenium-node-opera Opera $(VERSION) $(NAMESPACE) $(AUTHORS)

standalone_opera: opera generate_standalone_opera
	cd ./StandaloneOpera && docker build $(BUILD_ARGS) -t $(NAME)/selenium-standalone-opera:$(VERSION) .

generate_standalone_opera_debug:
	cd ./StandaloneDebug && ./generate.sh StandaloneOperaDebug selenium-node-opera-debug Opera $(VERSION) $(NAMESPACE) $(AUTHORS)

standalone_opera_debug: opera_debug generate_standalone_opera_debug
	cd ./StandaloneOperaDebug && docker build $(BUILD_ARGS) -t $(NAME)/selenium-standalone-opera-debug:$(VERSION) .

generate_standalone_edge:
	cd ./Standalone && ./generate.sh StandaloneEdge selenium-node-edge Edge $(VERSION) $(NAMESPACE) $(AUTHORS)

standalone_edge: edge generate_standalone_edge
	cd ./StandaloneEdge && docker build $(BUILD_ARGS) -t $(NAME)/selenium-standalone-edge:$(VERSION) .

generate_standalone_edge_debug:
	cd ./StandaloneDebug && ./generate.sh StandaloneEdgeDebug selenium-node-edge-debug Edge $(VERSION) $(NAMESPACE) $(AUTHORS)

standalone_edge_debug: edge_debug generate_standalone_edge_debug
	cd ./StandaloneEdgeDebug && docker build $(BUILD_ARGS) -t $(NAME)/selenium-standalone-edge-debug:$(VERSION) .

generate_chrome_debug:
	cd ./NodeDebug && ./generate.sh NodeChromeDebug selenium-node-chrome Chrome $(VERSION) $(NAMESPACE) $(AUTHORS)

chrome_debug: generate_chrome_debug chrome
	cd ./NodeChromeDebug && docker build $(BUILD_ARGS) -t $(NAME)/selenium-node-chrome-debug:$(VERSION) .

generate_firefox_debug:
	cd ./NodeDebug && ./generate.sh NodeFirefoxDebug selenium-node-firefox Firefox $(VERSION) $(NAMESPACE) $(AUTHORS)

firefox_debug: generate_firefox_debug firefox
	cd ./NodeFirefoxDebug && docker build $(BUILD_ARGS) -t $(NAME)/selenium-node-firefox-debug:$(VERSION) .

generate_opera_debug:
	cd ./NodeDebug && ./generate.sh NodeOperaDebug selenium-node-opera Opera $(VERSION) $(NAMESPACE) $(AUTHORS)

opera_debug: generate_opera_debug opera
	cd ./NodeOperaDebug && docker build $(BUILD_ARGS) -t $(NAME)/selenium-node-opera-debug:$(VERSION) .

generate_edge_debug:
	cd ./NodeDebug && ./generate.sh NodeEdgeDebug selenium-node-edge Edge $(VERSION) $(NAMESPACE) $(AUTHORS)

edge_debug: generate_edge_debug edge
	cd ./NodeEdgeDebug && docker build $(BUILD_ARGS) -t $(NAME)/selenium-node-edge-debug:$(VERSION) .

tag_latest:
	docker tag $(NAME)/selenium-base:$(VERSION) $(NAME)/selenium-base:latest
	docker tag $(NAME)/selenium-hub:$(VERSION) $(NAME)/selenium-hub:latest
	docker tag $(NAME)/selenium-node-base:$(VERSION) $(NAME)/selenium-node-base:latest
	docker tag $(NAME)/selenium-node-chrome:$(VERSION) $(NAME)/selenium-node-chrome:latest
	docker tag $(NAME)/selenium-node-firefox:$(VERSION) $(NAME)/selenium-node-firefox:latest
	docker tag $(NAME)/selenium-node-opera:$(VERSION) $(NAME)/selenium-node-opera:latest
	docker tag $(NAME)/selenium-node-edge:$(VERSION) $(NAME)/selenium-node-edge:latest
	docker tag $(NAME)/selenium-node-chrome-debug:$(VERSION) $(NAME)/selenium-node-chrome-debug:latest
	docker tag $(NAME)/selenium-node-firefox-debug:$(VERSION) $(NAME)/selenium-node-firefox-debug:latest
	docker tag $(NAME)/selenium-node-opera-debug:$(VERSION) $(NAME)/selenium-node-opera-debug:latest
	docker tag $(NAME)/selenium-node-edge-debug:$(VERSION) $(NAME)/selenium-node-edge-debug:latest
	docker tag $(NAME)/selenium-standalone-chrome:$(VERSION) $(NAME)/selenium-standalone-chrome:latest
	docker tag $(NAME)/selenium-standalone-firefox:$(VERSION) $(NAME)/selenium-standalone-firefox:latest
	docker tag $(NAME)/selenium-standalone-opera:$(VERSION) $(NAME)/selenium-standalone-opera:latest
	docker tag $(NAME)/selenium-standalone-edge:$(VERSION) $(NAME)/selenium-standalone-edge:latest
	docker tag $(NAME)/selenium-standalone-chrome-debug:$(VERSION) $(NAME)/selenium-standalone-chrome-debug:latest
	docker tag $(NAME)/selenium-standalone-firefox-debug:$(VERSION) $(NAME)/selenium-standalone-firefox-debug:latest
	docker tag $(NAME)/selenium-standalone-opera-debug:$(VERSION) $(NAME)/selenium-standalone-opera-debug:latest
	docker tag $(NAME)/selenium-standalone-edge-debug:$(VERSION) $(NAME)/selenium-standalone-edge-debug:latest

release_latest:
	docker push $(NAME)/selenium-base:latest
	docker push $(NAME)/selenium-hub:latest
	docker push $(NAME)/selenium-node-base:latest
	docker push $(NAME)/selenium-node-chrome:latest
	docker push $(NAME)/selenium-node-firefox:latest
	docker push $(NAME)/selenium-node-opera:latest
	docker push $(NAME)/selenium-node-edge:latest
	docker push $(NAME)/selenium-node-chrome-debug:latest
	docker push $(NAME)/selenium-node-firefox-debug:latest
	docker push $(NAME)/selenium-node-opera-debug:latest
	docker push $(NAME)/selenium-node-edge-debug:latest
	docker push $(NAME)/selenium-standalone-chrome:latest
	docker push $(NAME)/selenium-standalone-firefox:latest
	docker push $(NAME)/selenium-standalone-opera:latest
	docker push $(NAME)/selenium-standalone-edge:latest
	docker push $(NAME)/selenium-standalone-chrome-debug:latest
	docker push $(NAME)/selenium-standalone-firefox-debug:latest
	docker push $(NAME)/selenium-standalone-opera-debug:latest
	docker push $(NAME)/selenium-standalone-edge-debug:latest

tag_major_minor:
	docker tag $(NAME)/selenium-base:$(VERSION) $(NAME)/selenium-base:$(MAJOR)
	docker tag $(NAME)/selenium-hub:$(VERSION) $(NAME)/selenium-hub:$(MAJOR)
	docker tag $(NAME)/selenium-node-base:$(VERSION) $(NAME)/selenium-node-base:$(MAJOR)
	docker tag $(NAME)/selenium-node-chrome:$(VERSION) $(NAME)/selenium-node-chrome:$(MAJOR)
	docker tag $(NAME)/selenium-node-firefox:$(VERSION) $(NAME)/selenium-node-firefox:$(MAJOR)
	docker tag $(NAME)/selenium-node-opera:$(VERSION) $(NAME)/selenium-node-opera:$(MAJOR)
	docker tag $(NAME)/selenium-node-edge:$(VERSION) $(NAME)/selenium-node-edge:$(MAJOR)
	docker tag $(NAME)/selenium-node-chrome-debug:$(VERSION) $(NAME)/selenium-node-chrome-debug:$(MAJOR)
	docker tag $(NAME)/selenium-node-firefox-debug:$(VERSION) $(NAME)/selenium-node-firefox-debug:$(MAJOR)
	docker tag $(NAME)/selenium-node-opera-debug:$(VERSION) $(NAME)/selenium-node-opera-debug:$(MAJOR)
	docker tag $(NAME)/selenium-node-edge-debug:$(VERSION) $(NAME)/selenium-node-edge-debug:$(MAJOR)
	docker tag $(NAME)/selenium-standalone-chrome:$(VERSION) $(NAME)/selenium-standalone-chrome:$(MAJOR)
	docker tag $(NAME)/selenium-standalone-firefox:$(VERSION) $(NAME)/selenium-standalone-firefox:$(MAJOR)
	docker tag $(NAME)/selenium-standalone-opera:$(VERSION) $(NAME)/selenium-standalone-opera:$(MAJOR)
	docker tag $(NAME)/selenium-standalone-edge:$(VERSION) $(NAME)/selenium-standalone-edge:$(MAJOR)
	docker tag $(NAME)/selenium-standalone-chrome-debug:$(VERSION) $(NAME)/selenium-standalone-chrome-debug:$(MAJOR)
	docker tag $(NAME)/selenium-standalone-firefox-debug:$(VERSION) $(NAME)/selenium-standalone-firefox-debug:$(MAJOR)
	docker tag $(NAME)/selenium-standalone-opera-debug:$(VERSION) $(NAME)/selenium-standalone-opera-debug:$(MAJOR)
	docker tag $(NAME)/selenium-standalone-edge-debug:$(VERSION) $(NAME)/selenium-standalone-edge-debug:$(MAJOR)
	docker tag $(NAME)/selenium-base:$(VERSION) $(NAME)/selenium-base:$(MAJOR).$(MINOR)
	docker tag $(NAME)/selenium-hub:$(VERSION) $(NAME)/selenium-hub:$(MAJOR).$(MINOR)
	docker tag $(NAME)/selenium-node-base:$(VERSION) $(NAME)/selenium-node-base:$(MAJOR).$(MINOR)
	docker tag $(NAME)/selenium-node-chrome:$(VERSION) $(NAME)/selenium-node-chrome:$(MAJOR).$(MINOR)
	docker tag $(NAME)/selenium-node-firefox:$(VERSION) $(NAME)/selenium-node-firefox:$(MAJOR).$(MINOR)
	docker tag $(NAME)/selenium-node-opera:$(VERSION) $(NAME)/selenium-node-opera:$(MAJOR).$(MINOR)
	docker tag $(NAME)/selenium-node-edge:$(VERSION) $(NAME)/selenium-node-edge:$(MAJOR).$(MINOR)
	docker tag $(NAME)/selenium-node-chrome-debug:$(VERSION) $(NAME)/selenium-node-chrome-debug:$(MAJOR).$(MINOR)
	docker tag $(NAME)/selenium-node-firefox-debug:$(VERSION) $(NAME)/selenium-node-firefox-debug:$(MAJOR).$(MINOR)
	docker tag $(NAME)/selenium-node-opera-debug:$(VERSION) $(NAME)/selenium-node-opera-debug:$(MAJOR).$(MINOR)
	docker tag $(NAME)/selenium-node-edge-debug:$(VERSION) $(NAME)/selenium-node-edge-debug:$(MAJOR).$(MINOR)
	docker tag $(NAME)/selenium-standalone-chrome:$(VERSION) $(NAME)/selenium-standalone-chrome:$(MAJOR).$(MINOR)
	docker tag $(NAME)/selenium-standalone-firefox:$(VERSION) $(NAME)/selenium-standalone-firefox:$(MAJOR).$(MINOR)
	docker tag $(NAME)/selenium-standalone-opera:$(VERSION) $(NAME)/selenium-standalone-opera:$(MAJOR).$(MINOR)
	docker tag $(NAME)/selenium-standalone-edge:$(VERSION) $(NAME)/selenium-standalone-edge:$(MAJOR).$(MINOR)
	docker tag $(NAME)/selenium-standalone-chrome-debug:$(VERSION) $(NAME)/selenium-standalone-chrome-debug:$(MAJOR).$(MINOR)
	docker tag $(NAME)/selenium-standalone-firefox-debug:$(VERSION) $(NAME)/selenium-standalone-firefox-debug:$(MAJOR).$(MINOR)
	docker tag $(NAME)/selenium-standalone-opera-debug:$(VERSION) $(NAME)/selenium-standalone-opera-debug:$(MAJOR).$(MINOR)
	docker tag $(NAME)/selenium-standalone-edge-debug:$(VERSION) $(NAME)/selenium-standalone-edge-debug:$(MAJOR).$(MINOR)
	docker tag $(NAME)/selenium-base:$(VERSION) $(NAME)/selenium-base:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/selenium-hub:$(VERSION) $(NAME)/selenium-hub:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/selenium-node-base:$(VERSION) $(NAME)/selenium-node-base:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/selenium-node-chrome:$(VERSION) $(NAME)/selenium-node-chrome:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/selenium-node-firefox:$(VERSION) $(NAME)/selenium-node-firefox:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/selenium-node-opera:$(VERSION) $(NAME)/selenium-node-opera:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/selenium-node-edge:$(VERSION) $(NAME)/selenium-node-edge:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/selenium-node-chrome-debug:$(VERSION) $(NAME)/selenium-node-chrome-debug:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/selenium-node-firefox-debug:$(VERSION) $(NAME)/selenium-node-firefox-debug:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/selenium-node-opera-debug:$(VERSION) $(NAME)/selenium-node-opera-debug:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/selenium-node-edge-debug:$(VERSION) $(NAME)/selenium-node-edge-debug:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/selenium-standalone-chrome:$(VERSION) $(NAME)/selenium-standalone-chrome:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/selenium-standalone-firefox:$(VERSION) $(NAME)/selenium-standalone-firefox:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/selenium-standalone-opera:$(VERSION) $(NAME)/selenium-standalone-opera:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/selenium-standalone-edge:$(VERSION) $(NAME)/selenium-standalone-edge:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/selenium-standalone-chrome-debug:$(VERSION) $(NAME)/selenium-standalone-chrome-debug:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/selenium-standalone-firefox-debug:$(VERSION) $(NAME)/selenium-standalone-firefox-debug:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/selenium-standalone-opera-debug:$(VERSION) $(NAME)/selenium-standalone-opera-debug:$(MAJOR_MINOR_PATCH)
	docker tag $(NAME)/selenium-standalone-edge-debug:$(VERSION) $(NAME)/selenium-standalone-edge-debug:$(MAJOR_MINOR_PATCH)

release: tag_major_minor
	@if ! docker images $(NAME)/selenium-base | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/selenium-base version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/selenium-hub | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/selenium-hub version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/selenium-node-base | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/selenium-node-base version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/selenium-node-chrome | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/selenium-node-chrome version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/selenium-node-firefox | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/selenium-node-firefox version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/selenium-node-opera | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/selenium-node-opera version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/selenium-node-edge | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/selenium-node-edge version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/selenium-node-chrome-debug | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/selenium-node-chrome-debug version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/selenium-node-firefox-debug | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/selenium-node-firefox-debug version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/selenium-node-opera-debug | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/selenium-node-opera-debug version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/selenium-node-edge-debug | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/selenium-node-edge-debug version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/selenium-standalone-chrome | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/selenium-standalone-chrome version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/selenium-standalone-firefox | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/selenium-standalone-firefox version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/selenium-standalone-opera | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/selenium-standalone-opera version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/selenium-standalone-edge | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/selenium-standalone-edge version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/selenium-standalone-chrome-debug | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/selenium-standalone-chrome-debug version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/selenium-standalone-firefox-debug | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/selenium-standalone-firefox-debug version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/selenium-standalone-opera-debug | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/selenium-standalone-opera-debug version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)/selenium-standalone-edge-debug | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/selenium-standalone-edge-debug version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	docker push $(NAME)/selenium-base:$(VERSION)
	docker push $(NAME)/selenium-hub:$(VERSION)
	docker push $(NAME)/selenium-node-base:$(VERSION)
	docker push $(NAME)/selenium-node-chrome:$(VERSION)
	docker push $(NAME)/selenium-node-firefox:$(VERSION)
	docker push $(NAME)/selenium-node-opera:$(VERSION)
	docker push $(NAME)/selenium-node-edge:$(VERSION)
	docker push $(NAME)/selenium-node-chrome-debug:$(VERSION)
	docker push $(NAME)/selenium-node-firefox-debug:$(VERSION)
	docker push $(NAME)/selenium-node-opera-debug:$(VERSION)
	docker push $(NAME)/selenium-node-edge-debug:$(VERSION)
	docker push $(NAME)/selenium-standalone-chrome:$(VERSION)
	docker push $(NAME)/selenium-standalone-firefox:$(VERSION)
	docker push $(NAME)/selenium-standalone-opera:$(VERSION)
	docker push $(NAME)/selenium-standalone-edge:$(VERSION)
	docker push $(NAME)/selenium-standalone-chrome-debug:$(VERSION)
	docker push $(NAME)/selenium-standalone-firefox-debug:$(VERSION)
	docker push $(NAME)/selenium-standalone-opera-debug:$(VERSION)
	docker push $(NAME)/selenium-standalone-edge-debug:$(VERSION)
	docker push $(NAME)/selenium-base:$(MAJOR)
	docker push $(NAME)/selenium-hub:$(MAJOR)
	docker push $(NAME)/selenium-node-base:$(MAJOR)
	docker push $(NAME)/selenium-node-chrome:$(MAJOR)
	docker push $(NAME)/selenium-node-firefox:$(MAJOR)
	docker push $(NAME)/selenium-node-opera:$(MAJOR)
	docker push $(NAME)/selenium-node-edge:$(MAJOR)
	docker push $(NAME)/selenium-node-chrome-debug:$(MAJOR)
	docker push $(NAME)/selenium-node-firefox-debug:$(MAJOR)
	docker push $(NAME)/selenium-node-opera-debug:$(MAJOR)
	docker push $(NAME)/selenium-node-edge-debug:$(MAJOR)
	docker push $(NAME)/selenium-standalone-chrome:$(MAJOR)
	docker push $(NAME)/selenium-standalone-firefox:$(MAJOR)
	docker push $(NAME)/selenium-standalone-opera:$(MAJOR)
	docker push $(NAME)/selenium-standalone-edge:$(MAJOR)
	docker push $(NAME)/selenium-standalone-chrome-debug:$(MAJOR)
	docker push $(NAME)/selenium-standalone-firefox-debug:$(MAJOR)
	docker push $(NAME)/selenium-standalone-opera-debug:$(MAJOR)
	docker push $(NAME)/selenium-standalone-edge-debug:$(MAJOR)
	docker push $(NAME)/selenium-base:$(MAJOR).$(MINOR)
	docker push $(NAME)/selenium-hub:$(MAJOR).$(MINOR)
	docker push $(NAME)/selenium-node-base:$(MAJOR).$(MINOR)
	docker push $(NAME)/selenium-node-chrome:$(MAJOR).$(MINOR)
	docker push $(NAME)/selenium-node-firefox:$(MAJOR).$(MINOR)
	docker push $(NAME)/selenium-node-opera:$(MAJOR).$(MINOR)
	docker push $(NAME)/selenium-node-edge:$(MAJOR).$(MINOR)
	docker push $(NAME)/selenium-node-chrome-debug:$(MAJOR).$(MINOR)
	docker push $(NAME)/selenium-node-firefox-debug:$(MAJOR).$(MINOR)
	docker push $(NAME)/selenium-node-opera-debug:$(MAJOR).$(MINOR)
	docker push $(NAME)/selenium-node-edge-debug:$(MAJOR).$(MINOR)
	docker push $(NAME)/selenium-standalone-chrome:$(MAJOR).$(MINOR)
	docker push $(NAME)/selenium-standalone-firefox:$(MAJOR).$(MINOR)
	docker push $(NAME)/selenium-standalone-opera:$(MAJOR).$(MINOR)
	docker push $(NAME)/selenium-standalone-edge:$(MAJOR).$(MINOR)
	docker push $(NAME)/selenium-standalone-chrome-debug:$(MAJOR).$(MINOR)
	docker push $(NAME)/selenium-standalone-firefox-debug:$(MAJOR).$(MINOR)
	docker push $(NAME)/selenium-standalone-opera-debug:$(MAJOR).$(MINOR)
	docker push $(NAME)/selenium-standalone-edge-debug:$(MAJOR).$(MINOR)
	docker push $(NAME)/selenium-base:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/selenium-hub:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/selenium-node-base:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/selenium-node-chrome:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/selenium-node-firefox:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/selenium-node-opera:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/selenium-node-edge:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/selenium-node-chrome-debug:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/selenium-node-firefox-debug:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/selenium-node-opera-debug:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/selenium-node-edge-debug:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/selenium-standalone-chrome:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/selenium-standalone-firefox:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/selenium-standalone-opera:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/selenium-standalone-edge:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/selenium-standalone-chrome-debug:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/selenium-standalone-firefox-debug:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/selenium-standalone-opera-debug:$(MAJOR_MINOR_PATCH)
	docker push $(NAME)/selenium-standalone-edge-debug:$(MAJOR_MINOR_PATCH)

test: test_chrome \
 test_firefox \
 test_opera \
 test_edge \
 test_chrome_debug \
 test_firefox_debug \
 test_opera_debug \
 test_edge_debug \
 test_chrome_standalone \
 test_firefox_standalone \
 test_opera_standalone \
 test_edge_standalone \
 test_chrome_standalone_debug \
 test_firefox_standalone_debug \
 test_opera_standalone_debug \
 test_edge_standalone_debug

test_chrome:
	VERSION=$(VERSION) NAMESPACE=$(NAMESPACE) ./tests/bootstrap.sh NodeChrome

test_chrome_debug:
	VERSION=$(VERSION) NAMESPACE=$(NAMESPACE) ./tests/bootstrap.sh NodeChromeDebug

test_chrome_standalone:
	VERSION=$(VERSION) NAMESPACE=$(NAMESPACE) ./tests/bootstrap.sh StandaloneChrome

test_chrome_standalone_debug:
	VERSION=$(VERSION) NAMESPACE=$(NAMESPACE) ./tests/bootstrap.sh StandaloneChromeDebug

test_firefox:
	VERSION=$(VERSION) NAMESPACE=$(NAMESPACE) ./tests/bootstrap.sh NodeFirefox

test_firefox_debug:
	VERSION=$(VERSION) NAMESPACE=$(NAMESPACE) ./tests/bootstrap.sh NodeFirefoxDebug

test_firefox_standalone:
	VERSION=$(VERSION) NAMESPACE=$(NAMESPACE) ./tests/bootstrap.sh StandaloneFirefox

test_firefox_standalone_debug:
	VERSION=$(VERSION) NAMESPACE=$(NAMESPACE) ./tests/bootstrap.sh StandaloneFirefoxDebug

test_opera:
	VERSION=$(VERSION) NAMESPACE=$(NAMESPACE) ./tests/bootstrap.sh NodeOpera

test_opera_debug:
	VERSION=$(VERSION) NAMESPACE=$(NAMESPACE) ./tests/bootstrap.sh NodeOperaDebug

test_opera_standalone:
	VERSION=$(VERSION) NAMESPACE=$(NAMESPACE) ./tests/bootstrap.sh StandaloneOpera

test_opera_standalone_debug:
	VERSION=$(VERSION) NAMESPACE=$(NAMESPACE) ./tests/bootstrap.sh StandaloneOperaDebug

test_edge:
	VERSION=$(VERSION) NAMESPACE=$(NAMESPACE) ./tests/bootstrap.sh NodeEdge

test_edge_debug:
	VERSION=$(VERSION) NAMESPACE=$(NAMESPACE) ./tests/bootstrap.sh NodeEdgeDebug

test_edge_standalone:
	VERSION=$(VERSION) NAMESPACE=$(NAMESPACE) ./tests/bootstrap.sh StandaloneEdge

test_edge_standalone_debug:
	VERSION=$(VERSION) NAMESPACE=$(NAMESPACE) ./tests/bootstrap.sh StandaloneEdgeDebug

.PHONY: \
	all \
	base \
	build \
	chrome \
	chrome_debug \
	ci \
	firefox \
	firefox_debug \
	opera \
	opera_debug \
	generate_all \
	generate_hub \
	generate_nodebase \
	generate_chrome \
	generate_firefox \
	generate_opera \
	generate_edge \
	generate_chrome_debug \
	generate_firefox_debug \
	generate_opera_debug \
	generate_edge_debug \
	generate_standalone_chrome \
	generate_standalone_firefox \
	generate_standalone_opera \
	generate_standalone_edge \
	generate_standalone_chrome_debug \
	generate_standalone_firefox_debug \
	generate_standalone_opera_debug \
	generate_standalone_edge_debug \
	hub \
	nodebase \
	release \
	standalone_chrome \
	standalone_firefox \
	standalone_opera \
	standalone_edge \
	standalone_chrome_debug \
	standalone_firefox_debug \
	standalone_opera_debug \
	standalone_edge_debug \
	tag_latest \
	test
