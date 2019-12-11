FROM tecnativa/doodba

USER root

LABEL summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      io.k8s.display-name="Odoo " \
      io.openshift.expose-services="8069:http,8072:http" \
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
    APPLICATION=${APPLICATION:-ocb} \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    PIP_NO_CACHE_DIR=off \
    ODOO_VERSION=${ODOO_VERSION} \
    VERSION=${ODOO_VERSION} \
    WAIT_DB=false \
    UID=1000 \
    GID=0

ENV SUMMARY="Platform for building and running Odoo ${ODOO_VERSION} applications" \
    DESCRIPTION="Platform for building and running Odoo ${ODOO_VERSION} applications."


RUN git clone --depth 1 https://github.com/OCA/maintainer-quality-tools.git /opt/maintainer-quality-tools  \
    && rm -rf /opt/maintainer-quality-tools/.git

COPY clone_oca_dependencies /opt/maintainer-quality-tools/travis/

#Our version is launching as user
RUN /opt/maintainer-quality-tools/travis/clone_oca_dependencies /opt/odoo/custom/src /opt/odoo/custom/src



#Fix odoo 9 build
RUN pip install --upgrade pytz
RUN python -m compileall /opt/odoo/src

RUN rm -rf /opt/odoo/auto/* && mkdir -p /opt/odoo/auto/addons \
    && mkdir -p /opt/addons /mnt/extra-addons \
    && usermod -g $GID odoo \
    && chown -R $UID:$GID /var/lib/odoo /qa/artifacts /opt /mnt/extra-addons \
    && chmod -R g+w /opt /var/lib/odoo /qa/artifacts /mnt/extra-addons \
    && chmod g+w /etc/passwd  \
    && find /opt /var/lib/odoo /qa/artifacts /mnt/extra-addons -type d -exec chmod g+s {} \; && sync

#COPY ./entrypoint.sh /

COPY .s2i/bin/ $STI_SCRIPTS_PATH
RUN cp /usr/local/bin/odoo $STI_SCRIPTS_PATH/run && sed -i 's/^import os/import os;os.umask(0o002)/' /usr/local/bin/direxec
USER $UID

#ENTRYPOINT [ "/opt/odoo/common/entrypoint" ]
#CMD [ "/opt/odoo/common/entrypoint" ]
#ENTRYPOINT [ "/bin/dash" ]
