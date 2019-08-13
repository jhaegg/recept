def HTTPNoContent():
    return [{
        'type': 'http.response.start',
        'status': 204,
        'headers': []
    }, {
        'type': 'http.response.body',
        'body': b""
    }]
