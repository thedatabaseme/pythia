Pythia
=========

Pythia is a Role for ansible that helps you to automate the following tasks when working with Oracle Databases on Linux Systems.

- Install Oracle RDBMS on a target system
- Create a Database on top of a new or an existing RDBMS
- Adjust all needed Kernel Parameters to run an Oracle Database
- Creates OS Users and Groups implicitly
- Install Patches on top of a new and existing RDBMS and or Database
- Upgrade a Oracle DB to a new Version
- Duplicate a Database with RMAN "duplicate from active database"
- Duplicate a Database with RMAN "duplicate from active database"
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

Requirements
------------

Pythia requires you to run Ansible 2.7 or higher. The Oracle Software you want to install / configure by Pythia has to be located on a "Staging Area" mounted on the Control Server. Keep in Mind, that you need to licence Oracle Software separately!

Role Variables
--------------

main.yml Variables (can be set when calling the playbook, see Examples):
  - oracle_user (Default oracle): OS Username under which the Database is running
  - oracle_group (Default dba): OS Groupname under which the Database is running
  - oracle_uid (Default 1500): User ID of the Oracle OS User
  - oracle_gid (Default 1500): Group ID of the Oracle OS Group
  - oracle_home_dir (Default /home/{{ oracle_user }}: Home Directory of the Oracle OS User
  - local_stage_directory (Default /mnt/oracle_stage): Software Stage Directory on the Ansible Control Server
  - remote_stage_directory (Default /oracle/sources): Software Stage Directory on the Target Server. E.G. Patches are staged here before applying it to a RDBMS or Database
  - local_sql_stage_directory (Default roles/pythia/files/default): Stage Directory for SQL Scripts on Ansible Control Server.
  - remote_sql_stage_directory (Default {{ remote_stage_directory }}/scripts): Stage Directory for SQL Scripts on Target Server.
  - oracle_version (Default 19EE): The Version of the RDBMS and Database you want to deploy or change. The Version String has to be existant within the RDBMS Dictionary (rdbms_dict.yml under vars folder)
  - client_version (Default 19CLNT): The Version of the Oracle Client you want to deploy. The Version String has to be existant within the Client Dictionary (client_dict.yml under vars folder)
  - oracle_sid (Default NULL): The SID of the Oracle Database you want to install. Only needed when starting the playbook with the "db" tag, for creating a Database.
  - space_needed_gb: Space approximately in GB for installing the RDBMS. Respects, that there is probably a Patch installed on top. OVERLOADS rdbms_dict.yml space_needed_gb. SHOULD NOT BE SPECIFIED WITHIN HERE. SHOULD BE SPECIFIED AS EXTRA VARIABLE IN PLAYBOOK CALL.
  - nls_length_semantics (Default BYTE): Oracle Parameter NLS_LENGTH_SEMANTICS, can be BYTE or CHAR. When set, it will be placed in the Database creation Response Files
  - character_set (Default AL32UTF8): Character Set of the Database when creating.
  - national_character_set (Default AL16UTF16): National Character Set of the Database when creating
  - management_pack_access (Default NONE): Controls the Parameter control_management_pack_access when creating a new Database. Values can be in: "NONE", "DIAGNOSTIC" or "DIAGNOSTIC+TUNING". Be sure, that you have licenced the corrent Enterprise Option (Tuning and or Diagnostic Pack) before setting this Parameter other than NONE. In the Standard Edition 2 of Oracle, it is not possible to licence this Features, so the Variable will not have impact on this Response File Templates.
  - install_patch (Default NULL): The Patch ID you want to install on a new Database or an existing RDBMS / Database. Only needed when starting the playbook with the "patch" or "patchonly" tag. Optional when starting the playbook with the "db" or "rdbms" tag. The Value of the install_patch Variable has to be defined in the patch_dictionary.yml File under the vars folder.
  - install_rpm (Default NULL): The RPM Name you want to install on the Database Server. Only needed when starting the playbook with the "rpm" tag. The Value of the install_rpm Variable has to be defined in the rpm_dictionary.yml File under the vars folder.
  - listener_port (Default 1521): Port on which a new listener will be created. Only needed when starting the playbook with the "db" or "listener" tag.
  - listener_prefix (Default LSNR_): The Prefix with which a new listener will be created after the Database creation. The SID of the Database will always be appended to the prefix. Only needed when starting the playbook with the "db" or "listener" tag.
  - emexpress (Default DBEXPRESS): Specifies if the EM Express should be installed / configured when creating a Database. There are two valid values for this Variable: DBEXPRESS and NONE
  - autoextend (Default false): Specifies if the created Datafiles should be autoextensible or not
  - listener_logging (Default OFF): Specifies if a created listener will be configured to log or not. Can be either OFF or ON.
  - generated_password: A Password generator which is used for generating a complex password for the Oracle OS User when it is created. If so, the password will be printed.
  - generated_db_password: A Password generator which is used for generating a less complex password for the Oracle Database Users SYS and SYSTEM when creating a database.
  - generated_default_password: A Password generator which is used for generating a less complex password for the Oracle Database Default Users when creating a database.
  - sles15_packages, sles12_packages, rhel7_packages: A list of Packages that will be installed before installing the Oracle RDBMS Software. The list can be found in the Oracle Installation Guide Documentation for each OS.
  - shmall (Default 2097152): Will be calculated during Playbook Runtime. Will be included to the sysctl Configuration when deploying a Database
  - shmmax (Default 4294967295): Will be calculated during Playbook Runtime. Will be included to the sysctl Configuration when deploying a Database
  - current_shmall (Default 0): Just for initializing the Variable. Must not be modified
  - current_shmmax (Default 0): Just for initializing the Variable. Must not be modified
  - current_hugepages (Default 0): Just for initializing the Variable. Must not be modified
  - hugepages (Default 0): Will be calculated during Playbook Runtime. Will be included to the sysctl Configuration when deploying a Database
  - client_install_type (Default Administrator): Choose Which Client Install Type you want to install. Can be Administrator, Runtime, InstantClient or Custom
  - duplicate_source_host (Default NULL): The source host on which the duplicate_source_sid is running. Only needed when starting the playbook with the "duplicate" tag, for duplicating a Database.
  - duplicate_target_host (Default NULL): The target host on which the duplicate_target_sid is running. Only needed when starting the playbook with the "duplicate" tag, for duplicating a Database.
  - duplicate_source_sid (Default NULL): The source SID of the Database to duplicate. Only needed when starting the playbook with the "duplicate" tag, for duplicating a Database.
  - duplicate_target_sid (Default NULL): The target SID of the Database to duplicate to. Only needed when starting the playbook with the "duplicate" tag, for duplicating a Database.
  - duplicate_remove_target (Default False): Controls if you have acknowledged that the Target Database will be removed before starting the actual duplicate
  - duplicate_preserve_parameter (Default source): Controls which parameters are considered during Duplication. Can be either source or target. So either the Source DBs Parameters will be preserved or the Target DBs Parameters will be preserved
  - duplicate_preserve_passwords (Default true): Controls if you want to preserve the Passwords of an already existing Target Database and set them after Duplication
  - duplicate_preserve_pwd_user_list (Default 'SYS','SYSTEM','DBSNMP'): A List of Users (comma separated and in Quotes) of which the Passwords should be preserved
  - duplicate_clone_spfile (Default spfile): Will be set to preservespfile when duplicate_preserve_parameter is set to target. Must not be modified
  - duplicate_rate_limit_per_channel (Default 40M): Controls the RMAN RATE Limit that comes to play in a duplicate job. Each Channel will not exceed this Rate in Byte while doings a duplicate.
  - duplicate_max_runtime (Default 54000): Number of Seconds of the maximum RMAN Duplicate runtime.
  - duplicate_run_post_script (Default false): Controls if some SQL Script should be run in Post-processing (so after the duplicate has finished). The SQL Script shoudl be placed under files/default/duplicate_<duplicate_source_sid>_post.sql
  - oracle_source_version (Default 18EE): The version of the Database to upgrade. This is needed for checking the oracle home directory.
  - oracle_target_version: (Default 19EE): The version the Database will be upgraded to. This is needed for checking the oracle home directory.
  - upgrade_log_dir: ("/oracle/cfgtoollogs/autoupgrade/<date><time>): Creates a path for a upgrade log directory
  - upgrade_mode (Default: analyze): Defines the mode the autoupgrade is running at. Options: analyze / fixup / deploy
  - autoupgrade_jar_dir (Default: ): Path where the up to date autoupgrade.jar is located, relative to the local_stage_directory variable. Must reside under local_stage_directory
  - create_grp (Default: no): Controls if a Restore Point is made during an Autoupgrade Process

patch_dict.yml (a Dictionary File for Patches that can be installed by Pythia):
  - patch_id: Unique Patch ID of the Patch
  - patch_dir: Path where the Patch is located on the Stage Directory, relative to the local_stage_directory Variable
  - patch_file: Filename of the Patch Archive
  - opatch_dir: Path where the needed OPatch Version is located on the Stage Directory, relative to the local_stage_directory Variable
  - opatch_file: Filename of the OPatch Archive
  - desc: Description of the Patch

rdbms_dict.yml (a Dictionary File for RDBMS that can be installed by Pythia):
  - rdbms_dir: Path where the RDBMS is located on the Stage Directory, relative to the local_stage_directory Variable
  - rdbms_file: Filename of the RDBMS Archive
  - oracle_base: Oracle Base Directory for the specified RDBMS
  - oracle_home: Oracle Home Directory for the specified RDBMS
  - oracle_inventory: Path to the Oracle Inventory Location
  - space_needed_gb: Space approximately needed in GB for installing the RDBMS. This value is checked in precheck_fsfree.yml before installing a RDBMS. The value should respect, that you are planning to install a Patchset on Top of the RDBMS. Good initial Value are 12GB of Free Space. 
  - desc: Description of the RDBMS

rpm_dict.yml (a Dictionary File for RPMs that can be installed by Pythia):
  - rpm_dir: Path where the Patch is located on the Stage Directory, relative to the local_stage_directory Variable
  - rpm_file: Filename of the Patch Archive
  - desc: Description of the RPM

Dependencies
------------

Tags that can be specified:
  - rdbms: Specifies, that you want a RDBMS installed. When tagging rdbms, you also may want to specify the Variable oracle_version when starting the playbook with "rdbms" tag.
  - db: Specifies, that you want to install a Database on top a new RDBMS (when specifying "rdbms" as a tag alongside with the "db" tag) or an already installed RDBMS on the target system. You may also want to specify the Variable oracle_version when starting the playbook with the "db" tag. You need to specify the oracle_sid Variable when calling the playbook for naming the new Database.
  - patch: Specifies, that you want to install a Patch on top of a new RDBMS (when specifying "rdbms" as a tag alongside with the "patch" tag) or an already installed RDBMS. When specifying the "patch" tag, you need to also specify the "install_patch" Variable when running the playbook. While running under the "patch" tag, the Patch Archive will be uncompressed to the target system. The Patch Files will be deleted after successfully installing the Patch.
  - patchonly: Like "patch" tag but implies, that the Patch Archive already exists on the target system. No cleanup will be done after the Patch Installation.
  - cleanup: Forces a cleanup after sucessfull Patch Installation. Also forces that the created backup Files under the RDBMS that are created by OPatch when patching are deleted. Handle with caution if you may want to rollback the Patch.
  - listener: Only creates a listener for the Specified Database with the oracle_sid Variable.
  - sqlscript: Triggers, that SQL Scripts (.sql) under files/default (or specified by local_sql_stage_directory) directory will be executed against the specified oracle_sid. Be aware, the Scripts will be executed without any precheck. Bad SQL can cause immense harm.
  - rpm: Triggers that additional RPMs have to be installed. When specifying "rpm" tag, you need also to specify the "install_rpm" Variable when running the playbook. The RPM will be transfered to the target system. After installing the RPM, the file will be removed.
  - autostart: Controls that the automatic startup of the Database you specified will be implemented. When specifying the autostart tag, you also must specify the oracle_sid Variable when calling the Playbook.
  - hugepage: Triggers, that Hugepages have to be configured. Can only be triggered when also tagging db. Hugepages will be calculated by given sga_max_size (Default 2G)
  - converttohugepage: Converts a non Hugepage configured System to use Hugepages. Disables transparent_hugepages. Needs sga_max_size Variable set to the absolute Size (in GB) of all SGA's on the System
  - prepare: Prepares the Target System for an upcomming Oracle Installation. Can be combined with the hugepage Tag and needs sga_max_size (Default 2G) specified to calculate Shared Memory and Hugepages
  - client: Specifies, that you want to install an Oracle Client. When tagging client, you also may to want to specify the Variable client_version when starting the playbook with "client" tag.
  - duplicate: Specifies, that you want to duplicate a Source Database to a Target Database. Uses RMAN duplicate from active Database. You need to specify the duplicate_source_host, duplicate_target_host, duplicate_source_sid and duplicate_target_sid Variable. As HOSTS you need to specify the Target Host.
  - upgrade: Specifies that you want to upgrade a Database to a new Version. You need to specify the Variables oracle_source_version, oracle_target_version, oracle_sid and upgrade_mode when starting the Playbook with the "upgrade" tag.


Example Playbook
----------------

An example Playbook is included within the GIT Repository as pythia.yml:

    - hosts: " {{ HOSTS }}"
      become_user: root
      roles:
         - /roles/pythia

License
-------

GPL 3.0

Author Information
------------------

Pythia was created by Philip Haberkern.
