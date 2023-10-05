#!/usr/bin/python3
"""Compress before sending"""

from fabric.api import local
from datetime import datetime


def do_pack():
    """Script that generates a .tgz from the contents of the web_static"""
    local('mkdir -p versions')
    dir_name = "web_static_" + datetime.strftime(datetime.now(),
                                                 "%Y%m%d%H%M%S")
    local('tar -czvf versions/{:s}.tgz web_static'.format(dir_name))
