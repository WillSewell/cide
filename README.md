cide - Continuous Integration Docker Environment
================================================

`cide` is a command-line application that runs your project's CI inside of a
docker container. This allows to test locally in the same environment as
remotely.

Usage
-----

Just run `cide` inside of your project. cide will look for a .cide.yml file
for configuration but all arguments are also passable trough command-line
arguments. If a Dockerfile already exists it will be used instead.

Features
--------

* straighforward to use, just run `cide` inside of your project
* works on OSX with boot2docker

Limitations
-----------

A temporary Dockerfile has to be created in the project's root because docker
doesn't allow referencing files outside of the directory (even with a symlink)

TODO
----

* use the /cache volume
* multi-container runs
* `cide setup` to configure inside of a project
* `cide gc` to cleanup old cide builds
* travis.yml compatiblity with docker containers that map to languages

