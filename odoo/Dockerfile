ARG ODOO_VERSION
FROM tecnativa/doodba:${ODOO_VERSION}-onbuild

USER root

RUN git clone --depth 1 https://github.com/OCA/maintainer-quality-tools.git /opt/maintainer-quality-tools  \
    && rm -rf /opt/maintainer-quality-tools/.git

RUN mkdir -p /opt/addons /mnt/extra-addons 
RUN usermod -g $GID odoo \
    && chown -R $UID:0 /var/lib/odoo /qa/artifacts /opt /mnt/extra-addons \
    && chmod -R g+w /opt /var/lib/odoo /qa/artifacts /mnt/extra-addons \
    && find /opt /var/lib/odoo /qa/artifacts /mnt/extra-addons -type d -exec chmod g+s {} \; && sync
RUN chmod g+w /etc/passwd 
COPY ./entrypoint.sh /
USER $UID

#/opt/odoo/common/entrypoint
ENTRYPOINT [ "/entrypoint.sh" ]
