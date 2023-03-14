NAME     := evicertia/cryptoserver-driver-rpmbuilder
TAG      := $$(git log -1 --pretty=%h)
IMG      := ${NAME}:${TAG}
LATEST   := ${NAME}:latest
THISDIR  := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

.DEFAULT_GOAL := run

build:
	@docker build -t ${IMG} .
	@docker tag ${IMG} ${LATEST}

push:
	@docker push ${NAME}

login:
	@docker log -u ${DOCKER_USER} -p ${DOCKER_PASS}

run: DRIVER_RELEASE=$(shell git log -1 --pretty=%h | wc -l | tr -d '[:space:]')
run: build
	@docker run -it --rm \
		-v ${THISDIR}/outputs:/outputs \
		-v ${THISDIR}/non-free:/non-free \
		-v ${THISDIR}/main.sh:/main.sh \
		-v ${THISDIR}/nfpm.yaml:/nfpm.yaml \
		-e DRIVER_RELEASE=${DRIVER_RELEASE} \
	       	${NAME} /main.sh


