async def await_map(fn, el):
    for e in el:
        await fn(e)
