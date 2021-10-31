# Duplicate a Database with Pythia

Pythia is able to duplicate an Oracle Database using RMAN "duplicate from active database". Pythia will also support you, to delete already existing Target Databases in this process. As well as to run User defined Scripts, preserve Passwords during the duplicate from the Target DB, disable Archivelog deletion from Source and to preserve a maybe existing Init-File (spfile) from Source or Target.

Be aware, that using the "duplicate" TAG assumes, that there is a valid RDBMS in the correct Version already installed on both Systems. If this isn't the case, you need to specify the "rdbms" TAG like described [here](https://github.com/thedatabaseme/pythia/blob/master/docs/02_INSTALL_RDBMS.md)

## Working with an Ansible Vault

To process a duplicate database, Pythia will need the SYS Password from the Source Database. The password needs to be provided in a vault.yml file, that resides under the roles/pythia/vars directory.
To create a new Vault File, you can do so by:

    ansible-vault create ./pythia/roles/pythia/vars/vault.yml

You will get asked for a password that will protect the Vault and is needed to edit or view the Vault File in the future.
In the upcoming editor you can enter informations, that will be stored encrypted in the Vault File. For Pythia Duplicate, you need to specify the SYS Password of the Source Database following the Syntax `vault_sys_<SID>`. Here is an example:

    vault_sys_CLONESRC: supersecretpassword

When calling a Playbook that uses Pythia, you can specify the Vault Password either by a Vault Passwordfile using `--vault-password-file` or by entering it during the Playbook call using `--ask-vault-password`.

You can find more general informations about the usage of an Ansible Vault [here](https://docs.ansible.com/ansible/latest/user_guide/vault.html).
## Variables

### Mandatory Variables


| Variable Name | Description              | Default Value |
|---------------|--------------------------|---------------|
|HOSTS |In this special usecase, you need to specify the Target Host as HOSTS.|none|
|duplicate_source_host|The source host on which the duplicate_source_sid is running. <br>Only needed when starting the playbook with the "duplicate" tag, for duplicating a Database.|none|
|duplicate_target_host|The target host on which the duplicate_target_sid is running. <br>Only needed when starting the playbook with the "duplicate" tag, for duplicating a Database.|none|
|duplicate_source_sid|The source SID of the Database to duplicate. Only needed when starting <br>the playbook with the "duplicate" tag, for duplicating a Database.|none|
|duplicate_target_sid|The target SID of the Database to duplicate to. Only needed when starting <br>the playbook with the "duplicate" tag, for duplicating a Database.|none|

### Optional Variables


| Variable Name | Description              | Default Value |
|---------------|--------------------------|---------------|
|duplicate_remove_target|Controls if you have acknowledged that the Target Database will be removed before starting the actual duplicate|FALSE|
|duplicate_preserve_parameter|Controls which parameters are considered during Duplication. <br>Can be either `source` or `target`. So either the Source DBs Parameters will be preserved <br>or the Target DBs Parameters will be preserved|source|
|duplicate_preserve_passwords|Controls if you want to preserve the Passwords of an already <br>existing Target Database and set them after Duplication|TRUE|
|duplicate_preserve_pwd_user_list|A List of Users (comma separated and in Quotes) of which <br>the Passwords should be preserved|'SYS','SYSTEM','DBSNMP'|
|duplicate_rate_limit_per_channel|Controls the RMAN RATE Limit that comes to play in a duplicate job. <br>Each Channel will not exceed this Rate in Byte while doings a duplicate.|40M|
|duplicate_max_runtime|Number of Seconds of the maximum RMAN Duplicate runtime.|54000|
|duplicate_run_post_script|Controls if some SQL Script should be run in Post-processing <br>(so after the duplicate has finished). The SQL Script should be placed under <br>files/default/duplicate_<duplicate_source_sid>_post.sql|FALSE|

## Examples

Example: Duplicate a Database named CLONESRC to a Database named CLONEDST on the host "vmdbsoraduplicatetarget". As HOST, the Target Host must be specified:
Attention!: The SYS Password for the Source Database is needed for the duplicate. The Password has to be provided within the vault.yml (using ansible-vault) as vault_sys_<SOURCESID>
Attention!: The Target Database will be overwritten / deleted during the duplicate process. All data will be lost! 

    - ansible-playbook /etc/ansible/pythia/pythia.yml -e "HOSTS=vmdbsoraduplicatetarget duplicate_source_host=vmdbsoraduplicatesource duplicate_target_host=vmdbsoraduplicatetarget duplicate_source_sid=CLONESRC duplicate_target_sid=CLONEDST duplicate_remove_target=true" --tags "duplicate" -k -K -u <username> --vault-password-file /etc/ansible/vault_password.pwd

Also you're able to specify, that the SPFILE of your maybe existing Target Database will be preserved after the cloning. So the Database will be restarted after successfull cloning and the original SPFILE will be restored. Therefore you can use the duplicate_preserve_parameter=target Variable.

    - ansible-playbook /etc/ansible/pythia/pythia.yml -e "HOSTS=vmdbsoraduplicatetarget duplicate_source_host=vmdbsoraduplicatesource duplicate_target_host=vmdbsoraduplicatetarget duplicate_source_sid=CLONESRC duplicate_target_sid=CLONEDST duplicate_remove_target=true duplicate_preserve_parameter=target" --tags "duplicate" -k -K -u <username> --vault-password-file /etc/ansible/vault_password.pwd

## Further Documentation

This is only were the fun begins, next let's have a look on how to create a Database using Pythia and how to install Patches on top of your RDBMS and Database.

  - [Install a RDBMS](https://github.com/thedatabaseme/pythia/blob/master/docs/02_INSTALL_RDBMS.md)
  - [Install Patches and Updates](https://github.com/thedatabaseme/pythia/blob/master/docs/04_INSTALL_PATCH.md)