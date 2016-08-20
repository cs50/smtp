default: build

build:
	docker build -t cs50/smtp .

rebuild:
	docker build --no-cache -t cs50/smtp .
