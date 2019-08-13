from os import environ
from yaml import load, FullLoader

class Config:
    def __init__(self, filename):
        with open(filename) as f:
            self._config = _override_with_env(load(f.read(), Loader=FullLoader))

    def __getitem__(self, key):
        return self._config[key]


def _override_with_env(source, path=(), separator="_"):
    if isinstance(source, dict):
        return {
            key: _override_with_env(value, path=path + (key, ), separator=separator)
            for key, value in source.items()
        }

    if isinstance(source, list):
        return [
            _override_with_env(value, path = path + (str(index), ), separator=separator)
            for index, value in enumerate(source)
        ]

    return environ.get(separator.join(path).upper(), default=source)
