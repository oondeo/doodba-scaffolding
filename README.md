# Dockerized Odoo project scaffolding

[Read the docs.](https://github.com/Tecnativa/doodba#scaffolding)

docker-compose -f setup-devel.yaml run --rm odoo
docker-compose -f devel.yaml up

# Initialize odoo database
```
odoo --no-http -u all --load-language=es_ES -d db
```

# Todo
- List all secuences, if is null initialize
```
SELECT c.relname FROM pg_class c WHERE c.relkind = 'S';
```

- Fix addons folders

- Filestore is on /home/odoo/.local

- Entrypoint params is not working

- Convert setup-devel.yaml (up) + devel.yaml (build+up) to Openshift

- oca_dependencies.txt:
ENV MQT_URI="https://github.com/LasLabs/maintainer-quality-tools/archive/bugfix/script-shebang.tar.gz"
RUN curl -sL "$MQT_URI" | tar -xz -C /opt/ \
    && ln -s /opt/maintainer-quality-tools-*/travis/clone_oca_dependencies /usr/bin \
    && ln -s /opt/maintainer-quality-tools-*/travis/getaddons.py /usr/bin/get_addons \
    && chmod +x /usr/bin/get_addons

# test build
DOCKER_REPO="oondeo" DOCKER_TAG="8.0" APPLICATION="openupgrade" hooks/build
