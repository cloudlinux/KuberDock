.PHONY:	build push save load

VENDOR = kuberdock
NAME = fluentd
VERSION = 1.0
TAG = $(VENDOR)/$(NAME):$(VERSION)
TAR = $(VENDOR)_$(NAME)_$(VERSION).tar

build:
	docker build -t $(TAG) .

push:
	docker push $(TAG)

save:
	docker save -o $(TAR) $(TAG)

load:
	docker load -i $(TAR)
