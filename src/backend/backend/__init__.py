from .config import Config
from .database import Database
from .application import Application
from .handlers import up

async def init():
    config = Config("config/config.yaml")

    base = {
        'database': await Database.create(config['database'])
    }

app = Application(init)

app.add_route('/up', up)
