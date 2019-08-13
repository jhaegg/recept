import logging

from .error import HTTPNotFound, HTTPMethodNotAllowed
from .responses import HTTPNoContent
from .aitertools import await_map

class Application:
    def __init__(self, init):
        self._init = init
        self._routes = {}
        self._logger = logging.getLogger("ASGIApp")
        self._logger.setLevel(logging.DEBUG)
        ch = logging.StreamHandler()
        ch.setLevel(logging.DEBUG)
        self._logger.addHandler(ch)

    def add_route(self, route, handler):
        self._routes[route] = handler

    async def __call__(self, scope, receive, send):
        if scope['type'] == 'http':
            return await self._http(scope, receive, send)
        elif scope['type'] == 'lifespan':
            return await self._lifespan(scope, receive, send)
        else:
            raise Exception("Unhandled scope %s" % scope['type'])

    async def _http(self, scope, receive, send):
        try:
            handler = getattr(self._routes[scope['path']], scope['method'])
        except KeyError:
            return await await_map(send, HTTPNotFound(scope['path']))
        except AttributeError:
            return await await_map(send, HTTPMethodNotAllowed(scope['path'], scope['method']))

        try:
            resp = await handler(self._context)
        except Exception:
            self._logger.exception("Exception in %s %s handler" % (scope['method'], scope['path']))
            return

        if resp is None:
            return await await_map(send, HTTPNoContent())

        for item in resp:
            pass
            # Handle proper responses here

    async def _lifespan(self, scope, receive, send):
        while True:
            message = await receive()
            if message['type'] == 'lifespan.startup':
                self._context = await self._init()
                await send({'type': 'lifespan.startup.complete'})
            elif message['type'] == 'lifespan.shutdown':
                await send({'type': 'lifespan.shutdown.complete'})
                return
