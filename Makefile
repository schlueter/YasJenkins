DOCKER_REPOSITORY := schlueter
VERSION := $(shell sed -En "s/.*version='([^']+)'.*/\1/p" setup.py)
CONTAINER_TAG := ${DOCKER_REPOSITORY}/yas:${VERSION}
CONTAINER_LATEST_TAG := ${DOCKER_REPOSITORY}/yas:latest
CONTAINER_NAME := yas-jenkins

noop:
	@echo 'Doing nothing. Have a look at the Makefile if you want to find something to do.'

dist: dist/${CONTAINER_NAME}-${VERSION}.tar.gz

dist/${CONTAINER_NAME}-${VERSION}.tar.gz:
	python setup.py sdist bdist_wheel

test-pypi: update-on-test-pypi

update-on-test-pypi: dist
	python -m twine upload --repository-url https://test.pypi.org/legacy/ dist/*

pypi: update-on-pypi

update-on-pypi: dist
	python -m twine upload dist/*

build-container:
	docker build -t ${CONTAINER_TAG} .

dockerhub: update-on-dockerhub

update-on-dockerhub: build-container
	docker push ${CONTAINER_TAG}

dockerhub-latest: build-container
	docker tag ${CONTAINER_TAG} ${CONTAINER_LATEST_TAG}
	docker push ${CONTAINER_LATEST_TAG}

git-tag:
	git tag -s ${VERSION}
	git push --tags

.PHONY: noop update-on-test-pypi update-on-pypi update-on-dockerhub dist test-pypi pypi build-container dockerhub git-tag
