#!/usr/bin/python3
"""deletes out-of-date archives"""

from fabric.api import local, run, env
import os

env.user = "ubuntu"
env.hosts = ["52.201.146.153", "35.153.17.132"]


def do_clean(number=0):
    """clean unnecessary files"""
    releases_path = '/data/web_static/releases'
    number = 2 if number == '0' else int(number) + 1

    local('cd versions; ls -t | tail -n +{} | xargs rm -rf'
          .format(number))
    run('cd {}; ls -t | tail -n +{} | sudo xargs rm -rf'
        .format(releases_path, number))
