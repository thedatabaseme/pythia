# Create a Database with Pythia

The next step is to install an Oracle Database on a System of our choice. This can be done by specifying the `db` TAG. Of course, therefore we need an installed RDBMS in the needed Version. You can read more informations [here](https://github.com/thedatabaseme/pythia/blob/master/docs/02_INSTALL_RDBMS.md), if you not already have done so.
We highly recommend, to also specify the `hugepage` TAG when creating a Database with Pythia. Hugepages will highly improve the Systems Performance at least for Databases with large SGA size.

## Prerequisites

During the Prerequisite Check that Pythia does everytime you let her go, the according Prerequisites will be implemented. When specifying the `db` TAG, the following will be done during the prerequisite phase.

  - Check and set all needed Kernel Parameter (Shared Memory Configuration and also Hugepages if you specified the TAG `hugepage`)
  - Restarts the System to disable Transparent Hugepages (when `hugepage` TAG is specified and you acknowledged the Reboot (`reboot_ack=true`))
  - Set the Security Limits (`ulimit`) of the System
  - Setup an Environment Script for the Oracle OS User which will be executed when you `su` to the Oracle User

## Variables

### Mandatory Variables


| Variable Name | Description              | Default Value |
|---------------|--------------------------|---------------|
|oracle_version |The Version of the RDBMS and Database you want to deploy or change.<br>The Version String has to be existant within the RDBMS Dictionary (`rdbms_dict.yml` under vars folder)|`19EE`|
|oracle_sid|The SID of the Oracle Database you want to install. Only needed when starting <br>the playbook with the `db` tag, for creating a Database|`NONE`|

### Optional SID parameters
You can specify a list of database parameters that should get set during dbca DB creation by specifying them with the according SID name in a `sid_parameters.yml` (see *sid_parameters_EXAMPLE.yml*).
For instance, if you plan to adjust the parameters `filesystemio_options` and `fast_start_mttr_target` when a database `ORA21` is getting created, your `sid_parameters.yml` should look like this.

```
sid_parameters:
  ORA21:
    parameters:
      FILESYSTEMIO_OPTIONS: setall
      FAST_START_MTTR_TARGET: 150
```

You are able to specify parameters for multiple instances in one file.

> :warning: Defining the same parameters multiple times with conflicting values will lead to unknown behavior during the DB creation. Please check the dbca templates under the templates directory to understand, which parameters are set there.

### Optional Variables


| Variable Name | Description              | Default Value |
|---------------|--------------------------|---------------|
|oracle_pdb_name|Name of the Plugable Database you want to get created<br> during Database creation. Needs to be set in order to get it created.|`NONE`|
|sga_max_size |Size of the SGA in GB of the Oracle Database to be created. Both Parameters <br>sga_max_size and sga_target will be set to this value for your Instance Configuration|`2`|
|pga_aggregate_target|Size of the PGA in GB of the Oracle Database to be created. Will be set as <br>Oracle Parameter pga_aggregate_target|`1`|
|use_large_pages|Can be `TRUE` or `ONLY`. Will automatically be set to `ONLY` when the hugepage tag <br>is specified|`TRUE`|
|management_pack_access|Controls the Parameter control_management_pack_access when creating a <br>new Database. Values can be in: `NONE`, `DIAGNOSTIC` or `DIAGNOSTIC+TUNING`. <br>Be sure, that you have licenced the corrent Enterprise Option (Tuning and or Diagnostic Pack) <br>before setting this Parameter other than `NONE`. In the Standard Edition 2 of Oracle, <br>it is not possible to licence this Features, so the Variable will not have <br>impact on this Response File Templates.|`NONE`|
|character_set|Character Set of the Database when creating.|`AL32UTF8`|
|national_character_set|National Character Set of the Database when creating|`AL16UTF16`|
|nls_length_semantics|Oracle Parameter NLS_LENGTH_SEMANTICS, can be `BYTE` or `CHAR`. When set, it will <br>be placed in the Database creation Response Files|`BYTE`|
|listener_port|Port on which a new listener will be created. Only needed when starting the playbook <br>with the `db` or `listener` tag.|`1521`|
|listener_prefix|The Prefix with which a new listener will be created after the Database creation. <br>The SID of the Database will always be appended to the prefix. Only needed when <br>starting the playbook with the `db` or `listener` tag.|`LSNR_`|
|listener_logging|Specifies if a created listener will be configured to log or not. Can be either `OFF` or `ON`.|`OFF`|
|emexpress|Specifies if the EM Express should be installed / configured when creating a Database. <br>There are two valid values for this Variable: `DBEXPRESS` and `NONE`|`DBEXPRESS`|
|autoextend|Specifies if the created Datafiles should be autoextensible or not|`FALSE`|
|selinux_desired_state|There are some known problems with SELinux set to enforcing and Oracle Databases.<br>`selinux_desired_state` controls the state which SELinux should get set by Pythia.<br> Can be set to `permissive`, `enforcing` and `disabled`. Eventually a reboot is required<br>when altering the state. You may need to set the reboot_ack parameter when calling<br>the playbook.|`permissive`|

<br>

> :warning: SELinux can be tricky. We recommend to use the default setting (`permissive`). If your system is set to `enforcing`, a reboot will be required. Pythia will do the reboot for you, but you need to also acknowledge the reboot by the `reboot_ack=true` flag in the playbook call (see `hugepage` TAG in the [README.md](https://github.com/thedatabaseme/pythia/blob/master/README.md))

<br>

## Examples

Example: Build a Database named "ORA18" on an already installed 18c RDBMS (defined in Dictionary under 18EE) with a SGA Size of 4GB:

    - ansible-playbook /etc/ansible/pythia/pythia.yml -e "HOSTS=ansibletest" --tags "db" -e "oracle_sid=ORA18 oracle_version=18EE sga_max_size=4" -k -K -u <username>

Example: Install Oracle RDBMS with Version 19c as Enterprise Edition on Host "ansibletest", install the 19.5 RU (Patch ID: 30125133). Build a Database named "ORA19" on top:

    - ansible-playbook /etc/ansible/pythia/pythia.yml -e "HOSTS=ansibletest" --tags "rdbms, db, patch" -e "oracle_sid=ORA19 oracle_version=19EE install_patch=30125133" -k -K -u <username>

## Further Documentation

This is only were the fun begins, next let's have a look on how to create a Database using Pythia and how to install Patches on top of your RDBMS and Database.

  - [Install a RDBMS](https://github.com/thedatabaseme/pythia/blob/master/docs/02_INSTALL_RDBMS.md)
  - [Install Patches and Updates](https://github.com/thedatabaseme/pythia/blob/master/docs/04_INSTALL_PATCH.md)