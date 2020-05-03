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
