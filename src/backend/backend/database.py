import aiomysql

from pymysql.cursors import DictCursor
from asyncio import get_running_loop

class Database:
    @classmethod
    async def create(cls, config):
        self = Database()

        self._read = await aiomysql.create_pool(**config['read'],
                                                cursorclass=DictCursor)

        self._write = await aiomysql.create_pool(**config['write'],
                                                 cursorclass=DictCursor,
                                                 autocommit=False)

    async def read(self, query, *args):
        async with self._read.acquire() as conn:
            async with conn.cursor() as cur:
                return cur.execute(query, *args)

    async def write(self, query, *args):
        async with self._write.acquire() as conn:
            async with conn.cursor() as cur:
                result = await cur.execute(query, *args)
                await cur.commit()

        return result

    async def begin(self):
        return await Transaction(self._write)


class Transaction:
    async def __init__(self, pool):
        self._conn = await pool.acquire()
        self._cur = await self._conn.cursor()

    async def execute(self, query, *args):
        return await self._cur.execute(query, *args)

    async def commit(self):
        await self._cur.commit()
        await self._conn.release()

    async def rollback(self):
        await self._cur.rollback()
        await self._conn.release()
