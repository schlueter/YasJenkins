# Yas Jenkins [Handler]
###### A handler for [yas](github.com/schlueter/yas) to interact with a Jenkins instance

## Setup

To simply run a an instance of yas with this handler, `docker run` may be executed directly, albeit with a number of requisite environment variables:

    docker run --rm --tty \
        --env YAS_SLACK_TOKEN=xoxb-XXXXXXXXXXXX-XXXXXXXXXXXXXXXXXXXXXXXX \
        --env YAS_BOT_NAME=yasjenkins \
        --env YAS_JENKINS_URL=https://jenkins.example.com \
        --env YAS_JENKINS_USERNAME=yasjenkins \
        --env YAS_JENKINS_PASSWORD=superdupersecret \
        --env YAS_JENKINS_JOBS='{"MyJob": "do ci (?P<branch>\w+)"}' \
        --env YAS_HANDLER_LIST=yas.handlers.ignored_types_handler.,yas.handlers.not_talking_to_bot_handler.,yas.handlers.help_handler.,yas.handlers.identify_handler.,yasjenkins.,yas.handlers.rules_handler.,yas.handlers.default_handler. \
        schlueter/yasjenkins:latest

That handler list should be made DRYer sometime; the important bit for this module is the `yasjenkins.`, but the
rest is mostly necessary for YAS to operate in a reasonable way.

With yas installed manually, this module may be installed from pip with `python -m pip install yasjenkins` and the handler entry
"yasjenkins." added to the `YAS_HANDLER_LIST` environment variable in the execution environment. This handler may work
with pre 2.0 versions of yas by adding it to the handler list in the configuration file, but that is neither tested nor supported.

## Configuration

In addition to the configuration of yas itself, this handler is configured via the environment variables `YAS_JENKINS_URL`,
`YAS_JENKINS_USERNAME`, `YAS_JENKINS_PASSWORD`, and `YAS_JENKINS_JOBS`. The url, username, and password refer to the url
of a Jenkins instance, and the user credentials for a user on that instance. A service account should be preferred. The
jobs variable is used to expose jobs (surprise) via the indicated command. The command is a python regex string with any
parameters to the job present as named group like `(?P<my_parameter>\w+)` where my_parameter matches an **existing**
parameter defined in the job and `\w+` will match any value which should be expected from a slack request.

## Architecture

This plugin uses the [python-jenkins](https://python-jenkins.readthedocs.io/en/latest/) module to interact with the
configured Jenkins instance. At present (version 1.0) only triggering builds of jobs is exposed. The configured
jobs' command regexes are looped over to determine if any of them match a previously unmatched message to the host
YAS instance and a request to build the associated job is sent. At present (version 1.0) there is meek acknowledgement
that the request was made (it doesn't indicate which job or anything else), and nothing more. Improving that initial
response should be an expected feature in an upcoming version, but acknowledgement of failure or other state of
completion of the job will be left to the Jenkins job.
