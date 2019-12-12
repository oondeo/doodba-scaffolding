# Dockerized Odoo project scaffolding

[Read the docs.](https://github.com/Tecnativa/doodba#scaffolding)

docker-compose -f setup-devel.yaml run --rm odoo
docker-compose -f devel.yaml up

# Todo

- Fix addons folders

- Filestore is on /home/odoo/.local

- Entrypoint params is not working

- Convert setup-devel.yaml (up) + devel.yaml (build+up) to Openshift

- oca_dependencies, get_addons -> /mqt

- List all secuences, if is null initialize
```
SELECT c.relname FROM pg_class c WHERE c.relkind = 'S';
```

# test build
```
DOCKER_REPO="oondeo" DOCKER_TAG="8.0" APPLICATION="openupgrade" hooks/build
```

# Initialize odoo database
```
odoo --no-http -u all --load-language=es_ES -d db
```
