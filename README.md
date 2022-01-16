# Pythia
Pythia is a Role for ansible that helps you to automate the following tasks when working with Oracle Databases on Linux Systems.

  - Install Oracle RDBMS (Starting with Version 18) on a target system
  - Create a Database on top of a new or an existing RDBMS
  - Adjust all needed Kernel Parameters to run an Oracle Database
  - Creates OS Users and Groups implicitly
  - Install Patches on top of a new and existing RDBMS and or Database
  - Runs SQL Scripts against a specified Oracle Database
  - Upgrade a Oracle DB to a new Version
  - Duplicate a Database with RMAN "duplicate from active database"
  - Datapump Export / Import over NETWORK_LINK
  - Install Oracle Client
  
Thereby several Prerequisites are fullfilled and or checked. E.G.

  - Create oracle user and dba group of not existant
  - Create all needed directory structures
  - Install required Packages and set required Kernel Parameters

You can adapt Pythia to your needs by configure variables when running the Playbook. E.G.

  - Version you want to install
  - Patch you want to install
  - Listener Configuration
  - Oracle User- and Group IDs
  - Implement Autostart of the Database
  - Install additional RPMs or run SQL Scripts

**See README.md under roles/pythia/README.md for more Details.**
 
Requirements
------------

Pythia requires you to run Ansible 2.9 or higher. The Oracle Software you want to install / configure by Pythia has to be located on a "Staging Area" mounted on the Control Server. Keep in Mind, that you need to licence Oracle Software separately!

Installation and Configuration
------------------------------

  1. Clone the Repository to your Ansible Controlserver: `git clone https://github.com/theoracleme/pythia.git`
  2. Setup a Fileshare, that includes the Oracle Software you want to install and mount it to the Ansible Controlserver.
  3. Configure the Fileshare as "Staging Area" by changing the "local_stage_directory" variable in the `vars/main.yml`
  4. Configure all Variables fitting your environment. A description for all Variables can be found in the Roles [README.md](https://github.com/thedatabaseme/pythia/blob/master/roles/pythia/README.md) or the `vars/main.yml` File.
  5. Configure the `vars/rdbms_dict.yml`, `vars/patch_dict.yml` and `vars/sid_directories.yml` to suite your needs. A description for all Variables can be found in the Dictionary File or the README.md.
     Further Informations about what to change, can also be found in the [INSTALL.md](https://github.com/thedatabaseme/pythia/blob/master/INSTALL.md)
  6. Define your Hosts or Hostgroups in the Ansible Host Inventory. (e.G. hosts)
  7. Place User-Defined SQL Scripts under the files/default directory of the Role. 

**For first time Installation and further informations what to change and setup, please see the [INSTALL.md](https://github.com/thedatabaseme/pythia/blob/master/INSTALL.md) for Details. This is important, else Pythia won't work correctly!**

Example Playbook Runs
---------------------

**More detailed Examples and instructions can be found under the docs folder**

Pythia works with tags to combine the actions of installation, configuration, patching and so on. The following Tags are defined:
  - rdbms: Specifies, that you want a RDBMS installed. When tagging rdbms, you also may want to specify the Variable oracle_version when starting the playbook with `rdbms` TAG.
  - db: Specifies, that you want to install a Database on top a new RDBMS (when specifying `rdbms` as a TAG alongside with the `db` TAG) or an already installed RDBMS on the target system. You may also want to specify the Variable oracle_version when starting the playbook with the `db` TAG. You need to specify the `oracle_sid` Variable when calling the playbook for naming the new Database.
  - patch: Specifies, that you want to install a Patch on top of a new RDBMS (when specifying `rdbms` as a TAG alongside with the `patch` TAG) or an already installed RDBMS. When specifying the `patch` TAG, you need to also specify the `install_patch` Variable when running the playbook. While running under the `patch` TAG, the Patch Archive will be uncompressed to the target system. The Patch Files will be deleted after successfully installing the Patch.
  - patchonly: Like `patch` TAG but implies, that the Patch Archive already exists on the target system. No cleanup will be done after the Patch Installation.
  - cleanup: Forces a cleanup after sucessfull Patch Installation. Also forces that the created backup Files under the RDBMS that are created by OPatch when patching are deleted. Handle with caution if you may want to rollback the Patch.
  - listener: Only creates a listener for the Specified Database with the `oracle_sid` Variable.
  - sqlscript: Triggers, that SQL Scripts (.sql) under `files/default` (or specified by `local_sql_stage_directory`) directory will be executed against the specified `oracle_sid`. Be aware, the Scripts will be executed without any precheck. Bad SQL can cause immense harm.
  - rpm: Triggers that additional RPMs have to be installed. When specifying `rpm` TAG, you need also to specify the `install_rpm` Variable when running the playbook. The RPM will be transfered to the target system. After installing the RPM, the file will be removed.
  - autostart: Controls that the automatic startup of the Database you specified will be implemented. When specifying the autostart TAG, you also must specify the `oracle_sid` Variable when calling the Playbook.
  - hugepage: Triggers, that Hugepages have to be configured. Can only be triggered when also tagging `db`. Hugepages will be calculated by given `sga_max_size` (Default 2G)
  - converttohugepage: Converts a non Hugepage configured System to use Hugepages. Disables transparent_hugepages. Needs `sga_max_size` Variable set to the absolute Size (in GB) of all SGA's on the System
  - prepare: Prepares the Target System for an upcomming Oracle Installation. Can be combined with the `hugepage` TAG and needs `sga_max_size` (Default 2G) specified to calculate Shared Memory and Hugepages
  - client: Specifies, that you want to install an Oracle Client. When tagging `client`, you also may to want to specify the Variable `client_version` when starting the playbook with `client` TAG.
  - duplicate: Specifies, that you want to duplicate a Source Database to a Target Database. Uses RMAN duplicate from active Database. You need to specify the `duplicate_source_host`, `duplicate_target_host`, `duplicate_source_sid` and `duplicate_target_sid` Variable. As HOSTS you need to specify the Target Host.  
  - upgrade: Specifies that you want to upgrade a Database to a new Version. You need to specify the Variables `oracle_source_version`, `oracle_target_version`, `oracle_sid` and `upgrade_mode` when starting the Playbook with the `upgrade` TAG.
  - datapump: Specifies, that you want to do an Datapump Export / Import over NETWORK_LINK. You need to specify the `datapump_source_host`, `datapump_target_host`, `datapump_source_sid` and `datapump_target_sid` Variable. As HOSTS you need to specify the Target Host.

Example: Install Oracle RDBMS with Version 19c and Enterprise Edition on Host "ansibletest", install the 19.5 RU (Patch ID: 30125133). Build a Database named "ORA19" on top:

    - ansible-playbook /etc/ansible/pythia/pythia.yml -e "HOSTS=ansibletest" --tags "rdbms, db, patch" -e "oracle_sid=ORA19 oracle_version=19EE install_patch=30125133" -k -K -u <username>

Example: Patch an existing Oracle RDBMS (and all Databases under the Oracle Home) to 19.5 RU (Patch ID: 30125133):

    - ansible-playbook /etc/ansible/pythia/pythia.yml -e "HOSTS=ansibletest" --tags "patch" -e "oracle_version=19EE install_patch=30125133" -k -K -u <username>
 
Example: Build a Database named "ORA18" on an already installed 18c RDBMS (defined in Dictionary under 18EE):

    - ansible-playbook /etc/ansible/pythia/pythia.yml -e "HOSTS=ansibletest" --tags "db" -e "oracle_sid=ORA18 oracle_version=18EE" -k -K -u <username>

Example: Build a Database named "ORA18" on an already installed 18c RDBMS (defined in Dictionary under 18EE) and execute Scripts after DB Creation (for creating some Users e.G.):

    - ansible-playbook /etc/ansible/pythia/pythia.yml -e "HOSTS=ansibletest" --tags "db, sqlscript" -e "oracle_sid=ORA18 oracle_version=18EE" -k -K -u <username>

Example: Install additional Software named "DEMO" on the target system (defined in Dictionary under DEMO):

    - ansible-playbook /etc/ansible/pythia/pythia.yml -e "HOSTS=ansibletest" --tags "rpm" -e "install_rpm=DEMO" -k -K -u <username>

Example: Install Oracle RDBMS with Version 19c and Enterprise Edition on Host "ansibletest", install the 19.5 RU (Patch ID: 30125133). Build a Database named "ORA19" on top, which will use Hugepages and a SGA Size of 16GB:
Attention! Configuring Hugepages will most likely lead to a system reboot. Therefore the reboot_ack switch has to be set when calling the playbook.

    - ansible-playbook /etc/ansible/pythia/pythia.yml -e "HOSTS=ansibletest" --tags "rdbms, db, patch, hugepage" -e "oracle_sid=ORA19 oracle_version=19EE install_patch=30125133 reboot_ack=true sga_max_size=16" -k -K -u <username>

Example: Install an Oracle Database Client in Version 18c on Host "ansibletest":
   
    - ansible-playbook /etc/ansible/pythia/pythia.yml -e "HOSTS=ansibletest" --tags "client" -e "client_version=18CLNT" -k -K -u <username>
    
Example: Duplicate a Database named CLONESRC to a Database named CLONEDST on the host "vmdbsoraduplicatetarget". As HOST, the Target Host must be specified:
Attention!: The SYS Password for the Source Database is needed for the duplicate. The Password has to be provided within the vault.yml (using ansible-vault) as vault_sys_<SOURCESID>
Attention!: The Target Database will be overwritten / deleted during the duplicate process. All data will be lost! 

    - ansible-playbook /etc/ansible/pythia/pythia.yml -e "HOSTS=vmdbsoraduplicatetarget duplicate_source_host=vmdbsoraduplicatesource duplicate_target_host=vmdbsoraduplicatetarget duplicate_source_sid=CLONESRC duplicate_target_sid=CLONEDST duplicate_remove_target=true" --tags "duplicate" -k -K -u <username> --vault-password-file /etc/ansible/vault_password.pwd

Also you're able to specify, that the SPFILE of your maybe existing Target Database will be preserved after the cloning. So the Database will be restarted after successfull cloning and the original SPFILE will be restored. Therefore you can use the duplicate_preserve_parameter=target Variable.

    - ansible-playbook /etc/ansible/pythia/pythia.yml -e "HOSTS=vmdbsoraduplicatetarget duplicate_source_host=vmdbsoraduplicatesource duplicate_target_host=vmdbsoraduplicatetarget duplicate_source_sid=CLONESRC duplicate_target_sid=CLONEDST duplicate_remove_target=true duplicate_preserve_parameter=target" --tags "duplicate" -k -K -u <username> --vault-password-file /etc/ansible/vault_password.pwd

Example: Upgrade an Oracle Database in Version 18 to Oracle Database in Version 19 on Host "ansibletest":

    - ansible-playbook /etc/ansible/pythia/pythia.yml -e "oracle_source_version=18EE oracle_target_version=19EE oracle_sid=ORAUPGRD upgrade_mode=deploy HOSTS=ansibletest" --tags "upgrade" -k -K -u <username>

Example: Do a Datapump Export / Import over NETWORK_LINK. Source Database named EXPSRC to a Database named EXPDST on the host "vmdbsoradatapumptarget". As HOST, the Target Host must be specified:
Attention!: The Passwords for the Source and Target Database is needed for the datapump process. The Password has to be provided within the vault.yml (using ansible-vault) as vault_datapump_<SOURCESID> and vault_datapump_<TARGETSID>

    - ansible-playbook /etc/ansible/pythia/pythia.yml -e "HOSTS=vmdbsoradatapumptarget datapump_source_host=vmdbsdatapumpsource datapump_target_host=vmdbsoradatapumptarget datapump_source_sid=EXPSRC datapump_target_sid=EXPDST datapump_full=False datapump_schema_list='USER1,USER2'" --tags "datapump" -k -K -u <username> --vault-password-file /etc/ansible/vault_password.pwd

    - ansible-playbook /etc/ansible/pythia/pythia.yml -e "HOSTS=vmdbsoradatapumptarget datapump_source_host=vmdbsdatapumpsource datapump_target_host=vmdbsoradatapumptarget datapump_source_sid=EXPSRC datapump_target_sid=EXPDST" --tags "datapump" -k -K -u <username> --vault-password-file /etc/ansible/vault_password.pwd