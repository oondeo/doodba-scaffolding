ARG ODOO_VERSION
FROM tecnativa/doodba:${ODOO_VERSION}-onbuild

ARG UID
USER root

RUN curl "https://github.com/OCA/maintainer-quality-tools/archive/master.zip" /opt/maintainer-quality-tools

RUN git --depth 1 https://github.com/OCA/maintainer-quality-tools.git /opt/maintainer-quality-tools  \
    && rm -rf /opt/maintainer-quality-tools/.git

USER $UID
