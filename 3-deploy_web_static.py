#!/usr/bin/python3
"""Full deployment"""

from fabric.api import env
import os

do_pack = __import__('1-pack_web_static').do_pack
do_deploy = __import__('2-do_deploy_web_static').do_deploy


def deploy():
    """Full deployment"""
    try:
        files = os.listdir("versions")
        if len(files) == 1:
            archive_path = "versions/" + files[0]

    except Exception:
        archive_path = do_pack()

    return do_deploy(archive_path)
