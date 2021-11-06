# Datapump Export / Import a Database with Pythia

# UPDATE STARTS HERE!

Pythia is able to do a Datapump Export / Import over a NETWORK_LINK (Database Link). You may either do a FULL Export / Import or an Import of a List of Schemas. Pythia also supports you by remapping the schemas.

Be aware, that all restrictions for doing an Export / Import over a Database Link are applying here. More informations can be found [here](https://docs.oracle.com/database/121/SUTIL/GUID-0871E56B-07EB-43B3-91DA-D1F457CF6182.htm#SUTIL919)

Be aware, that using the `datapump` TAG assumes, that there is a valid RDBMS in the correct Version already installed on both Systems. If this isn't the case, you need to specify the `rdbms` TAG like described [here](https://github.com/thedatabaseme/pythia/blob/master/docs/02_INSTALL_RDBMS.md)

## Working with an Ansible Vault

To process a Datapump Export / Import of a database, Pythia will need the Password for a User to execute the actual Export and Import for both Databases. It's recommended, that this user is the System user, but any user with the appropriate permissions will be feasable. The password needs to be provided in a `vault.yml` file, that resides under the `roles/pythia/vars` directory.
To create a new Vault File, you can do so by:

    ansible-vault create ./pythia/roles/pythia/vars/vault.yml

You will get asked for a password that will protect the Vault and is needed to edit or view the Vault File in the future.
In the upcoming editor you can enter informations, that will be stored encrypted in the Vault File. For Pythia Duplicate, you need to specify the SYS Password of the Source Database following the Syntax `vault_datapump_<SID>`. Here is an example:

    vault_datapump_EXPSRC: supersecretpassword

When calling a Playbook that uses Pythia, you can specify the Vault Password either by a Vault Passwordfile using `--vault-password-file` or by entering it during the Playbook call using `--ask-vault-password`.

You can find more general informations about the usage of an Ansible Vault [here](https://docs.ansible.com/ansible/latest/user_guide/vault.html).
## Variables

### Mandatory Variables


| Variable Name | Description              | Default Value |
|---------------|--------------------------|---------------|
|HOSTS |In this special usecase, you need to specify the Target Host as HOSTS.|none|
|datapump_source_host|The source host on which the datapump_source_sid is running. <br>Only needed when starting the playbook with the `datapump` TAG, for doing an Datapump Export / Import a Database.|none|
|datapump_target_host|The target host on which the datapump_target_sid is running. <br>Only needed when starting the playbook with the `datapump` TAG, for doing an Datapump Export / Import a Database.|none|
|datapump_source_sid|The source SID of the Database to duplicate. Only needed when <br>starting the playbook with the `datapump` TAG, for duplicating a Database.|none|
|datapump_target_sid|The target SID of the Database to duplicate to. Only needed when <br>starting the playbook with the `datapump` TAG, for duplicating a Database.|none|

### Optional Variables


| Variable Name | Description              | Default Value |
|---------------|--------------------------|---------------|
|datapump_full|Should a Full Export / Import be made or schema Import only? If `FALSE`, <br>you need to specify the `datapump_schema_list` Variable|`TRUE`|
|datapump_schema_list|List of Schemas (divided by , for example `USER1,USER2`). <br>Only relevant when `datapump_full` is `FALSE`. You need to to set `datapump_full` to `FALSE` when you want to export only a certain list of Schemas.|none|
|datapump_schema_remap|List of Schemas to Remap. For Example `USER1:USERA,USER2:USERB` <br>will remap USER1 to USERA and USER2 to USERB|none|
|datapump_max_runtime|Number of Seconds of the maximum Datapump runtime.|`14400`|
|datapump_source_user|User on Source Database which the Database Link uses to connect over Network_link|`System`|
|datapump_target_user|User on Target Database which impdp uses to connect|`System`|
|datapump_table_exists_action|Controls the impdp TABLE_EXIST_ACTION. Can either be `APPEND`, `REPLACE`, `SKIP` or `TRUNCATE`|`SKIP`|

## Examples

Example: Do a Datapump Export / Import over NETWORK_LINK. Source Database named EXPSRC to a Database named EXPDST on the host "vmdbsoradatapumptarget". As HOST, the Target Host must be specified:
Attention!: The Passwords for the Source and Target Database is needed for the datapump process. The Password has to be provided within the vault.yml (using ansible-vault) as `vault_datapump_<SOURCESID>` and `vault_datapump_<TARGETSID>`

    - ansible-playbook /etc/ansible/pythia/pythia.yml -e "HOSTS=vmdbsoradatapumptarget datapump_source_host=vmdbsdatapumpsource datapump_target_host=vmdbsoradatapumptarget datapump_source_sid=EXPSRC datapump_target_sid=EXPDST datapump_full=False datapump_schema_list='USER1,USER2'" --tags "datapump" -k -K -u <username> --vault-password-file /etc/ansible/vault_password.pwd

    - ansible-playbook /etc/ansible/pythia/pythia.yml -e "HOSTS=vmdbsoradatapumptarget datapump_source_host=vmdbsdatapumpsource datapump_target_host=vmdbsoradatapumptarget datapump_source_sid=EXPSRC datapump_target_sid=EXPDST" --tags "datapump" -k -K -u <username> --vault-password-file /etc/ansible/vault_password.pwd

## Further Documentation

This is only were the fun begins, next let's have a look on how to create a Database using Pythia and how to install Patches on top of your RDBMS and Database.

  - [Install a RDBMS](https://github.com/thedatabaseme/pythia/blob/master/docs/02_INSTALL_RDBMS.md)
  - [Install Patches and Updates](https://github.com/thedatabaseme/pythia/blob/master/docs/04_INSTALL_PATCH.md)