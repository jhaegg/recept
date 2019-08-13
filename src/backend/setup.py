from setuptools import find_packages, setup

with open('requirements.txt') as f:
    requirements = f.read()

setup(
    name="backend",
    version="0.0.1",
    description="Backend for recipe site",
    author="Johan Hägg",
    author_email="johan.hagg@shard.se",
    packages=find_packages(),
    install_requires=requirements,
    entry_points={
        "console_scripts": "apply_migrations=backend:apply_migrations"
    }
)
