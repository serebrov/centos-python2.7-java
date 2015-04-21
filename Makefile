.DEFAULT: build

build: Dockerfile
	docker build -t serebrov/centos-python2.7-java .
