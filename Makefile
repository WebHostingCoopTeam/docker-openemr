build:
	docker build -t `cat TAG` .

run:
	docker run \
	-it \
	-P \
	`cat TAG`
