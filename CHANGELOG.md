## 2020-11-30

- Add `SENTRY_URL=http://sentry.local:19000/` variable to Makefile
- Add Makefile target `push`
- Add `VERSION.txt` with current version
- Add Makefile targets to manipulate sentry releases
  - sentry-release-new
  - sentry-set-commits
  - sentry-release-finalize

## 2020-11-29

- Add boolean variable `APP_NO_CSS` variable to disable loading external CSS or JS resources (usable in isolated environments)
- Migrate to jinja2 template engine

## 2020-11-22

- Fix docker build (upd mysl-dev vesrsion to `1.1.24-r10`)
- Add sentry integration (use env `SENTRY_DSN`)
- Pass app version as release info to sentry

## 2020-10-04

- Add possibility setting web-page background color with env variable `APP_BGCOLOR`
- Fix Makefile target `hadolint`. Now it works
- Omit variable `APP_PORT` as unusable
- 

## 2020-05-17

- Remove `-${TRAVIS_BUILD_NUMBER}` from docker image tag

## 2020-05-16

- Display webdebugger version in webpage title
  - Add `APP_VERSION` to `Dockerfile`
  - Automatically update `APP_VERSION` in `Dockerfile` by _bump2version_

## 2020-05-15

- Include bootstrap-4.5.0 into html template

## 2020-05-03

- Add route `/env/<env_var>`. Return os environmant variable `env_var` value
- Add route `/healthz`. Always return OK
- Upldate `docker-compose.yml`. Mount `./` as `/app` into container
- Add pycodestyle to `.travis.yml` pipeline

## 2020-04-27

- Add `bump2version` to dev dependencies
- Add `autopep8` to dev dependencies
- Add Makefile target `hadolint`
- Add Makefile target `pycodestyle`
- Improve code style via autopep8
- Add Makefile target `docker-pycodestyle`
- Add Makefile target `docker-version`
- Add Makefile targets for version manipulation
  - `version` - get version
  - `version-patch` - increase version patch number
  - `version-minor` - increase minor version
  - `version-major` - increase major version
- Add `.travis.yml`
- Display version after increase in Makefile targets `version-*`
- Rename script `docker-push.sh` to `docker-publish.sh`
- Don't publish docker image on `maste` branch update
- Add build status badge to `README.md`
- Add `LICENSE.txt`
- Add variables to `.travis.yml`
  - `DOCKER_USERNAME`
  - `DOCKER_PASSWORD`
- Supress debug output in `docker-publish.sh`
- Add Makefile target `docker-publish` to publish docker image via CI
- Set exit with error if any variable value isn't set in `docker-entrypoint.sh`
- Dont do `build` before any of `docker-*` Makefile target
- Add `EXPOSE ${APP_PORT}` instruction to Dockerfile

## 2020-04-26

- Add `docker-compose.yml`

## 2020-04-25

- Remove `request.headers` from output
- Add `os.environ` to output
- Add reply delay (in seconds) with `APP_DELAY` environment variable
- Rename env var `PORT` to `APP_PORT`
- Dockerfile refactoring (spit environment and app configuration env variables)
- Add variable `APP_DELAY`
- Update `Makefile`. Run target build before any `docker-*` target


## 2020-04-24

- Project created
