IMAGE := web

.PHONY: build
build:
	docker build -t $(IMAGE) .

shell:
	docker-compose exec app shell

run:
	docker-compose rm --force
	docker-compose up

up:
	docker-compose up
