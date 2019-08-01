ARG ODOO_VERSION
FROM tecnativa/doodba:${ODOO_VERSION}-onbuild

USER root

LABEL summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      io.k8s.display-name="Odoo " \
      io.openshift.expose-services="8069:http" \
      io.openshift.tags="builder,python,odoo" \
      io.openshift.s2i.scripts-url=image:///usr/libexec/s2i \
      io.s2i.scripts-url=image:///usr/libexec/s2i \      
      com.redhat.component="$NAME" \
      name="$FGC/$NAME" \
      version="$VERSION" \
      usage="s2i build https://github.com/oondeo/doodba-scaffolding --context-dir=./ $FGC/$NAME odoo-sample-app" \
      maintainer="Oondeo <info@oondeo.es>"
      
ENV PATH=$HOME/.local/bin/:$PATH \
    STI_SCRIPTS_URL=image:///usr/libexec/s2i \
    # Path to be used in other layers to place s2i scripts into
    STI_SCRIPTS_PATH=/usr/libexec/s2i \
    APP_ROOT=/opt/app-root \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    PIP_NO_CACHE_DIR=off


ENV NAME=odoo \
    APPLICATION=${APPLICATION:-ocb} \
    ODOO_VERSION=${ODOO_VERSION} \
    VERSION=${ODOO_VERSION} \
    ARCH=x86_64

ENV SUMMARY="Platform for building and running Odoo ${ODOO_VERSION} applications" \
    DESCRIPTION="Platform for building and running Odoo ${ODOO_VERSION} applications."

RUN git clone --depth 1 https://github.com/OCA/maintainer-quality-tools.git /opt/maintainer-quality-tools  \
    && rm -rf /opt/maintainer-quality-tools/.git

RUN mkdir -p /opt/addons /mnt/extra-addons 
RUN usermod -g $GID odoo \
    && chown -R $UID:0 /var/lib/odoo /qa/artifacts /opt /mnt/extra-addons \
    && chmod -R g+w /opt /var/lib/odoo /qa/artifacts /mnt/extra-addons \
    && find /opt /var/lib/odoo /qa/artifacts /mnt/extra-addons -type d -exec chmod g+s {} \; && sync
RUN chmod g+w /etc/passwd 
COPY ./entrypoint.sh /
COPY ./s2i/bin/ $STI_SCRIPTS_PATH

USER $UID

#ENTRYPOINT [ "/opt/odoo/common/entrypoint" ]
#ENTRYPOINT [ "/entrypoint.sh" ]
