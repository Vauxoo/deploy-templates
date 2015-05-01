# Ansible start script for Odoo

The main intention of this script is to help in the starting process of dockerized Odoo instances.

## Vars file

This file contains the vars that will be used for configuring the instance.

**image_name** the image that will be used for the container
**container_name** the name that will have the container once it is started
**container_hostname** hostname of the container once started
**odoo_mapped_port** mapped xmlrpc port on the host, inside de container Odoo will be listenning 8069 port, but thi will be mapped into the host
**odoo_mapped_port_lp** same as *odoo_mapped_port* but for longpolling port
**odoo_config_file** location of the odoo config file, most of the time the default value is fine
**db_server** db host, if the container is in the same host than postgres youy must configure PostgreSQL to serve from the docker virtual interface too and configure to accept md5 connections
**working_folder** is the folder in the host filesystem where the persistent data will be stores (ssh keys, logs, tmp and filestore). 4 folders are created in here: logs, ssh, tmp and filestore; when a container is commited and pushed this isformation **won't** be pushed along with the builded image and will be kept locally


The following vars has the same effect than Odoo config parameters, atually they are replaced in the *odoo_config_file* by the [entry_point.py](https://github.com/Vauxoo/docker_entrypoint/blob/master/entry_point.py) when the container is started:
- db_filter
- db_name
- db_user
- db_password
- without_demo
- admin_passwd