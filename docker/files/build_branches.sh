#!/bin/bash
cd /tmp
git clone -b master https://github.com/OCA/maintainer-quality-tools
python maintainer-quality-tools/travis/clone_oca_dependencies /home/odoo/instance/extra_addons /home/odoo/instance/extra_addons
ADDONS="$(python maintainer-quality-tools/travis/getaddons.py /home/odoo/instance/extra_addons)"
sed -ri "s%(addons_path).*$%\1 = /home/odoo/instance/odoo/addons,$ADDONS%g" /home/odoo/.openerp_serverrc
