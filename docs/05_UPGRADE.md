# Upgrade a Database with Pythia

You may want to Upgrade (e.G. 18c to 19c) an Oracle Database using Pythia. Pythia will thereby using the "autoupgrade" Feature of Oracle. 

Be aware, Pythia assumes, that both the source and the target RDBMS Version is already installed on the system when specifying the "upgrade" TAG. If this isn't the case, you need to specify the "rdbms" TAG like described [here](https://github.com/thedatabaseme/pythia/blob/master/docs/02_INSTALL_RDBMS.md)

## Upgrade Modes

Pythia can use three so called "Upgrade Modes". 

  - analyze: The Database will "only" be analyzed what has to be done as prerequisites, before you heading to the actual upgrade. You then can go through the Analyze results and prepare the upgrade itself.
  - fixup: This includes the analyze step. The results will then tried to get fixed automatically by the autoupgrade Feature of Oracle. (running the fixup SQL File).
  - deploy: This includes all steps mentioned before. Also the actual upgrade will be performed.
## Variables

### Mandatory Variables


| Variable Name | Description              | Default Value |
|---------------|--------------------------|---------------|
|oracle_source_version|The version of the Database to upgrade. This is needed for checking <br>the oracle home directory.|18EE|
|oracle_target_version|The version the Database will be upgraded to. This is needed for <br>checking the oracle home directory.|19EE|
|upgrade_mode|Defines the mode the autoupgrade is running at. Options: `analyze` / `fixup` / `deploy`|analyze|

### Optional Variables


| Variable Name | Description              | Default Value |
|---------------|--------------------------|---------------|
|upgrade_log_dir|Creates a path for a upgrade log directory|/oracle/cfgtoollogs/autoupgrade/<date><time>|
|autoupgrade_jar_dir|Path where the up to date autoupgrade.jar is located, relative to the <br>`local_stage_directory` variable. Must reside under `local_stage_directory`|/db/oracle/19/rdbms/linux/x86_64/upgrade|
|create_grp|Controls if a Restore Point is made during an Autoupgrade Process|no|

## Examples

Example: Upgrade an Oracle Database in Version 18 to Oracle Database in Version 19 on Host "ansibletest":

    - ansible-playbook /etc/ansible/pythia/pythia.yml -e "oracle_source_version=18EE oracle_target_version=19EE oracle_sid=ORAUPGRD upgrade_mode=deploy HOSTS=ansibletest" --tags "upgrade" -k -K -u <username>

## Further Documentation

This is only were the fun begins, next let's have a look on how to create a Database using Pythia and how to install Patches on top of your RDBMS and Database.

  - [Install a RDBMS](https://github.com/thedatabaseme/pythia/blob/master/docs/02_INSTALL_RDBMS.md)
  - [Install Patches and Updates](https://github.com/thedatabaseme/pythia/blob/master/docs/04_INSTALL_PATCH.md)