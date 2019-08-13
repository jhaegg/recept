def HTTPNotFound(path):
    body = ("%s not found" % path).encode('utf-8')
    yield {
        'type': 'http.response.start',
        'status': 404,
        'headers': [
            (b'content-type', b'text/plain; charset=utf-8'),
            (b'content-length', b'%d' % len(body))
        ]
    }

    yield {
        'type': 'http.response.body',
        'body': body
    }


def HTTPMethodNotAllowed(path, method):
    body = ("%s does not support method %s" % (path, method)).encode('utf-8')
    yield {
        'type': 'http.response.start',
        'status': 405,
        'headers': [
            (b'content-type', b'text/plain; charset=utf-8'),
            (b'content-length', b'%d' % len(body))
        ]
    }

    yield {
        'type': 'http.response.body',
        'body': body
    }
