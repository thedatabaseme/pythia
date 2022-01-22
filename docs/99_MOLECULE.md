# General Informations
Pythia has implemented some Molecule test scenarios. This section describes which scenarios there are and how to run them.


# Prerequisites

In order to run Molecule tests for Pythia, there are some prerequisites, that need to be fullfilled.

  - A Linux Host / VM (e.G. Ubuntu 20.04)
  - Python3 with pip installed
  - Docker installed (see (here)[https://docs.docker.com/engine/install/ubuntu/])
  - Molecule with Docker Module installed (see (here)[https://thedatabaseme.de/2022/01/17/automated-testing-your-ansible-role-with-molecule-and-github-actions/])
  - This repository cloned on the Host / VM you prepared
  - A `local_stage_directory` is attached to the Host / VM with Oracle Database software in version 21c.


# Molecule scenarios

The following scenarios are implemented as Molecule tests:

  - `install_rdbms`: Installs an Oracle DB RDBMS in version 21c.
  - `install_db`: Installs an Oracle DB on one an existing RDBMS. Be aware, this will not work on an "empty" Docker Image without an Oracle Database installed.
  - `install_patch`: Installs an Oracle DB patch on one or many existing databases. Be aware, this will not work on an "empty" Docker Image without an Oracle Database installed.
  - `install_rdbms_db_patch`: This will do everything and is also the `default` Molecule test scenario.

# Run a Molecule test

To run a Molecule test, head to the roles root directory (`roles/pythia/`) and run molecule with the wanted scenario. Here is an example:

    - molecule test -s install_rdbms_db_patch

If you don't want to get the container destroyed after a test run, add the `--destroy=never` parameter to your `molecule` command.