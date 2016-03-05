## Put the image name according to the version
FROM vauxoo/odoo-80-image

## Remember to put you name
MAINTAINER Your Name <mail@example.com>

## Change the version to the correspondig one
ENV VERSION 8.0

## Change the repo according to the customer app repo
ENV APP_REPO git@github.com:Vauxoo/app_repo.git

RUN adduser --home=/home/odoo --disabled-password --gecos "" --shell=/bin/bash odoo \
    && echo 'root:odoo' |chpasswd \
    && mkdir -p /home/odoo/.ssh \
    && mkdir -p /root/.ssh \
    && mkdir /external_files

## This is a key you must copy in the same folder as the dockerfile
## but remember not to add it when you commit the files
COPY id_rsa /root/.ssh/id_rsa

RUN chown odoo:odoo -R /home/odoo/.ssh \
    && chmod 600 /root/.ssh/id_rsa

COPY files/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY files/supervisord.conf /external_files/supervisord.conf
COPY files/openerp_serverrc /external_files/openerp_serverrc
COPY files/build_branches.sh /tmp/build_branches.sh

USER odoo
ENV HOME="/home/odoo" \
    ODOO_CONFIG_FILE="/home/odoo/.openerp_serverrc" \
    ODOO_FILESTORE_PATH="/home/odoo/.local/share/Odoo/filestore" \
    XDG_DATA_HOME="/home/odoo/.local/share"


## Scan the keys to avoid the add question
RUN ssh-keyscan github.com > /home/odoo/.ssh/known_hosts \
    && ssh-keyscan launchpad.net >> /home/odoo/.ssh/known_hosts \
    && ssh-keyscan bitbucket.org >> /home/odoo/.ssh/known_hosts

USER root
## Actually here is where the instance is build
## Make the instance folder structure
COPY files/openerp_serverrc /home/odoo/.openerp_serverrc
RUN ssh-keyscan github.com > /root/.ssh/known_hosts \
    && /bin/bash -c "mkdir -p /home/odoo/instance/{config,extra_addons}" \
    && cd /home/odoo/instance \
    && git clone -b $VERSION --single-branch --depth=1 git@github.com:Vauxoo/odoo.git odoo \
    && mkdir -p /home/odoo/.local/share \
    && pip install --upgrade pip \
    && cd /home/odoo/instance/extra_addons \
    && git clone -b $VERSION --single-branch --depth=1 $APP_REPO \
    && sh /tmp/build_branches.sh \
    && chown odoo:odoo -R /home/odoo \
    && rm -f /root/.ssh/id_rsa \
    && rm -r /tmp/*
RUN mkdir -p /var/log/supervisor
RUN wget -q -O /entry_point.py https://raw.githubusercontent.com/vauxoo/docker_entrypoint/master/entry_point.py \
    && chmod +x /entry_point.py

## The volumes we want to use
VOLUME ["/var/log/supervisor", "/home/odoo/.local/share/Odoo", "/tmp", "/home/odoo/.ssh"]

## Expose xmlrpc and longpolling ports
EXPOSE 8069
EXPOSE 8072
CMD /entry_point.py
