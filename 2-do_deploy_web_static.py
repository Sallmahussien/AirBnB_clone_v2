#!/usr/bin/python3
"""Deploy archive!"""

from fabric.api import *
import os

env.user = "ubuntu"
env.hosts = ["52.201.146.153", "35.153.17.132"]


def do_deploy(archive_path):
    """distributes an archive to a web servers"""
    if not os.path.exists(archive_path):
        return False

    try:
        put("{:s}".format(archive_path), "/tmp/")

        new_release_dir = "/data/web_static/releases/" + \
                          os.path.basename(archive_path).split('.')[0] + '/'
        run('mkdir -p {:s}'.format(new_release_dir))

        archived_file = os.path.basename(archive_path)
        run('sudo tar -xzf /tmp/{:s} -C {:s}'
            .format(archived_file, new_release_dir))

        run('sudo mv {:s}web_static/* {:s}'
            .format(new_release_dir, new_release_dir))

        run('sudo rm -rf /tmp/{:s}'.format(archived_file))

        run('sudo rm -rf /data/web_static/current')

        run('ln -sf {:s} /data/web_static/current'.format(new_release_dir))

        return True

    except Exception:
        return False
