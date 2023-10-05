#!/usr/bin/python3
"""Compress before sending"""

from fabric.api import local
from datetime import datetime


def do_pack():
    """Script that generates a .tgz from the contents of the web_static"""
    dir_name = "web_static_" + datetime.strftime(datetime.now(),
                                                 "%Y%m%d%H%M%S")
    archive_path = 'versions/{:s}.tgz'.format(dir_name)

    try:
        local('mkdir -p versions')
        local('tar -czvf {:s} web_static'.format(archive_path))
    except Exception:
        return None

    return archive_path
