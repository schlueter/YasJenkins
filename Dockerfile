FROM schlueter/yas:latest

ENV YAS_JENKINS_JOBS '{}'
ENV YAS_JENKINS_URL ''
ENV YAS_JENKINS_USERNAME ''
ENV YAS_JENKINS_PASSWORD ''

COPY . .
RUN python -m pip install yasjenkins
