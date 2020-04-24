# webdebugger

This webb app show HTTP headers and other useful information


## Development

### Requirements

First, you must have `make` installed, to simplify all the operations.
If you haven't, see [Makefile](Makefile) for corresponding commands.

Then, you must have `poetry` installed. See https://python-poetry.org/docs/

Or just run 
```shell
make install_poetry
```

After that, install dependencies
```shell
make requirements
```
or
```shell
poetry install --local
```

### Run tests

```shell
make pytest
```
or
```shell
poetry run pytest -v
```

## Docker

Build image
```shell
make build
```

Build image and run tests
```shell
make docker-pytest
```

Run container
```shell
make docker-run
```

Run shell inside container
```shell
make docker-shell
```

## Author

Aleksey Koloskov <vsyscoder@gmail.com>
