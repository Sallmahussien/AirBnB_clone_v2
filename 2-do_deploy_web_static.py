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

    opt = put("{:s}".format(archive_path), "/tmp/")
    if opt.failed:
        return False

    new_release_dir = "/data/web_static/releases/" + \
                      os.path.basename(archive_path).split('.')[0] + '/'
    opt = run('mkdir -p {:s}'.format(new_release_dir))
    if opt.failed:
        return False

    archived_file = os.path.basename(archive_path)
    opt = run('sudo tar -xzf /tmp/{:s} -C {:s}'
              .format(archived_file, new_release_dir))
    if opt.failed:
        return False

    opt = run('sudo mv {:s}web_static/* {:s}'
              .format(new_release_dir, new_release_dir))
    if opt.failed:
        return False

    opt = run('sudo rm -rf /tmp/{:s}'.format(archive_path))
    if opt.failed:
        return False

    opt = run('sudo rm -rf /data/web_static/current')
    if opt.failed:
        return False

    opt = run('ln -sf {:s} /data/web_static/current'.format(new_release_dir))
    if opt.failed:
        return False

    return True
