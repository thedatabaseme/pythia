# Install a Patch with Pythia

Now let's have a look into how we can install Patches / Release Updates with Pythia. You may use the `patch` TAG in combination with the `rdbms` and / or `db` TAG, but you may also install a Patch on an already running Database or even a bunch of Databases. This can be done by specifying the `patch` TAG.

## Variables

### Mandatory Variables


| Variable Name | Description              | Default Value |
|---------------|--------------------------|---------------|
|oracle_version |The Version of the RDBMS and Database you want to deploy or change.<br>The Version String has to be existant within the RDBMS Dictionary (`rdbms_dict.yml`under vars folder)|`19EE`|
|install_patch|The Patch ID you want to install on a new Database or an existing RDBMS / Database. <br>Only needed when starting the playbook with the "patch" or "patchonly" tag. Optional when starting <br>the playbook with the `db` or `rdbms` TAG. The Value of the `install_patch` Variable <br>has to be defined in the `patch_dictionary.yml` File under the vars folder.|none|

Please also check the vars/patch_dict.yml and set the following Variables as you need. DON'T specify them in your Playbook Call.

| Variable Name | Description              |
|---------------|--------------------------|
|patch_id |Unique Patch ID|
|patch_dir |Path where the patch is located, relative to the `local_stage_directory` variable. <br>Must reside under `local_stage_directory`|
|patch_file|Filename of the Patch Archive|
|opatch_dir|Path where the needed OPATCH for patch installation is located. Relative to the `local_stage_directory` variable. <br>Must reside under `local_stage_directory`|
|oracle_inventory|Path to the Oracle Inventory Location|
|opatch_file|Filename of the needed OPATCH archive|
|desc|Description of the Patch|

## Examples

Example: Patch an existing Oracle RDBMS (and all Databases under the Oracle Home) to 19.5 RU (Patch ID: 30125133):

    - ansible-playbook /etc/ansible/pythia/pythia.yml -e "HOSTS=ansibletest" --tags "patch" -e "oracle_version=19EE install_patch=30125133" -k -K -u <username>

Example: Install Oracle RDBMS with Version 19c as Enterprise Edition on Host "ansibletest", install the 19.5 RU (Patch ID: 30125133). Build a Database named "ORA19" on top:

    - ansible-playbook /etc/ansible/pythia/pythia.yml -e "HOSTS=ansibletest" --tags "rdbms, db, patch" -e "oracle_sid=ORA19 oracle_version=19EE install_patch=30125133" -k -K -u <username>

## Further Documentation

This is only were the fun begins, next let's have a look on how to create a Database using Pythia and how to install Patches on top of your RDBMS and Database.

  - [Install a RDBMS](https://github.com/thedatabaseme/pythia/blob/master/docs/02_INSTALL_RDBMS.md)
  - [Create a Database](https://github.com/thedatabaseme/pythia/blob/master/docs/03_CREATE_DB.md)