# Dockerized Odoo project scaffolding

[Read the docs.](https://github.com/Tecnativa/doodba#scaffolding)

docker-compose -f setup-devel.yaml run --rm odoo
docker-compose -f devel.yaml up

# Todo

- Convert setup-devel.yaml (up) + devel.yaml (build+up) to Openshift

- oca_dependencies.txt: 
ENV MQT_URI="https://github.com/LasLabs/maintainer-quality-tools/archive/bugfix/script-shebang.tar.gz"
RUN curl -sL "$MQT_URI" | tar -xz -C /opt/ \
    && ln -s /opt/maintainer-quality-tools-*/travis/clone_oca_dependencies /usr/bin \
    && ln -s /opt/maintainer-quality-tools-*/travis/getaddons.py /usr/bin/get_addons \
    && chmod +x /usr/bin/get_addons
