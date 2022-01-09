# Install RDBMS with Pythia

The most basic Feature of Pythia is, to install an Oracle Database RDBMS on a Linux machine of your choice. If you haven't done so, please read the [General Instructions](https://github.com/thedatabaseme/pythia/blob/master/docs/01_GENERAL.md) before you continue reading this one. The RDBMS Installation will most likely be combined with other Tasks (TAGs) you want to have done by Pythia. We will give you some examples here, but you can find the details in the according documentation. This can be done by specifying the `rdbms` TAG.

## Prerequisites

During the Prerequisite Check that Pythia does everytime you let her go, the according Prerequisites will be implemented. When specifying the "rdbms" TAG, the following will be done during the prerequisite phase.

  - Ensure that OS User and Group exist. If not, Pythia will create them with a random Password
  - Ensure that all needed Directories are created to install the Software in (specified in the `vars/rdbms_dict.yml`)
  - Ensure that all needed OS Packages are installed. Be aware, you need access to a Repository here!

## Variables

### Mandatory Variables

| Variable Name | Description              | Default Value |
|---------------|--------------------------|---------------|
|oracle_version |The Version of the RDBMS and Database you want to deploy or change.<br>The Version String has to be existant within the RDBMS Dictionary (`rdbms_dict.yml` under vars folder)|`19EE`|

Please also check the `vars/rdbms_dict.yml` and set the following Variables as you need. DON'T specify them in your Playbook Call.

| Variable Name | Description              |
|---------------|--------------------------|
|rdbms_dir |Path where the RDBMS is located on the Stage Directory,<br>relative to the `local_stage_directory` Variable|
|rdbms_file |Filename of the RDBMS Archive|
|oracle_base|Oracle Base Directory for the specified RDBMS|
|oracle_home|Oracle Home Directory for the specified RDBMS|
|oracle_inventory|Path to the Oracle Inventory Location|
|container_database|Controls, if a database created for the specified<br> release, should be a CDB or not. NON-CDB<br> are desupported starting with 21c
|additional_dir|You may specify an additional directory that should be<br> created / permission set when install RDBMS|
|space_needed_gb|Space approximately in GB for installing the RDBMS. Respects,<br> that there is probably a Patch installed on top|
|desc|Description of the RDBMS|

## Examples

Example: Install Oracle RDBMS with Version 18c as Standard Edition 2 on Host "ansibletest":

    - ansible-playbook /etc/ansible/pythia/pythia.yml -e "HOSTS=ansibletest" --tags "rdbms" -e "oracle_version=18SE2" -k -K -u <username>

Example: Install Oracle RDBMS with Version 19c as Enterprise Edition on Host "ansibletest", install the 19.5 RU (Patch ID: 30125133). Build a Database named "ORA19" on top:

    - ansible-playbook /etc/ansible/pythia/pythia.yml -e "HOSTS=ansibletest" --tags "rdbms, db, patch" -e "oracle_sid=ORA19 oracle_version=19EE install_patch=30125133" -k -K -u <username>

## Further Documentation

This is only were the fun begins, next let's have a look on how to create a Database using Pythia and how to install Patches on top of your RDBMS and Database.

  - [Create a Database](https://github.com/thedatabaseme/pythia/blob/master/docs/03_CREATE_DB.md)
  - [Install Patches and Updates](https://github.com/thedatabaseme/pythia/blob/master/docs/04_INSTALL_PATCH.md)