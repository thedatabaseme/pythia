# Create a Database with Pythia

The next step is to install an Oracle Database on a System of our choice. Of course, therefore we need an installed RDBMS in the needed Version. You can read more informations [here](https://github.com/thedatabaseme/pythia/blob/master/docs/02_INSTALL_RDBMS.md), if you not already have done so.
We highly recommend, to also specify the "hugepage" TAG when creating a Database with Pythia. Hugepages will highly improve the Systems Performance at least for Databases with large SGA size.

## Prerequisites

During the Prerequisite Check that Pythia does everytime you let her go, the according Prerequisites will be implemented. When specifying the "db" TAG, the following will be done during the prerequisite phase.

  - Check and set all needed Kernel Parameter (Shared Memory Configuration and also Hugepages if you specified the TAG "hugepage")
  - Restarts the System to disable Transparent Hugepages (when "hugepage" TAG is specified and you acknowledged the Reboot)
  - Set the Security Limits (ulimit) of the System
  - Setup an Environment Script for the Oracle OS User which will be executed when you "su" to the Oracle User

REVIEW DOWN HERE!



## Variables

| Variable Name | Description              | Default Value |
|---------------|--------------------------|---------------|
|oracle_version |The Version of the RDBMS and Database you want to deploy or change.<br>The Version String has to be existant within the RDBMS Dictionary (rdbms_dict.yml under vars folder)|19EE|

Please also check the vars/rdbms_dict.yml and set the following Variables as you need. DON'T specify them in your Playbook Call.

| Variable Name | Description              |
|---------------|--------------------------|
|rdbms_dir |Path where the RDBMS is located on the Stage Directory,<br>relative to the local_stage_directory Variable|
|rdbms_file |Filename of the RDBMS Archive|
|oracle_base|Oracle Base Directory for the specified RDBMS|
|oracle_home|Oracle Home Directory for the specified RDBMS|
|oracle_inventory|Path to the Oracle Inventory Location|
|additional_dir|You may specify an additional directory that should be<br> created / permission set when install RDBMS|
|space_needed_gb|Space approximately in GB for installing the RDBMS. Respects,<br> that there is probably a Patch installed on top|
|desc|Description of the RDBMS|

## Examples

Example: Install Oracle RDBMS with Version 18c as Standard Edition 2 on Host "ansibletest":

    - ansible-playbook /etc/ansible/pythia/pythia.yml -e "HOSTS=ansibletest" --tags "rdbms" -e "oracle_version=18SE2" -k -K -u <username>

Example: Install Oracle RDBMS with Version 19c as Enterprise Edition on Host "ansibletest", install the 19.5 RU (Patch ID: 30125133). Build a Database named "ORA19" on top:

    - ansible-playbook /etc/ansible/pythia/pythia.yml -e "HOSTS=ansibletest" --tags "rdbms, db, patch" -e "oracle_sid=ORA19 oracle_version=19EE install_patch=30125133" -k -K -u <username>