# General Informations
In this section, you can find some more in detail examples using Pythia. 


## TAGs

Pythia is based on working with (Ansible) TAGs. When creating the command to run Pythia, you have to hand over at least one of the Tags (also listed in the [README.md](https://github.com/thedatabaseme/pythia/blob/master/roles/pythia/README.md)). You can mostly combine the TAGs as you like. So for instance, you may combine the TAGs rdbms, db and patch, to get an RDBMS installed, a Database on top of this and of course, you want to have it patched. All in one command.

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


## Extra Variables

Beside from specifying a TAG, you need to provide at least these Variable (regardless of which TAG you have specified). You may specify the HOSTS Variable directly in the Playbook, as an Extra Variable or in your Inventory. In these Instructions, we will always hand them over as Extra Variables.

  - HOSTS: Within this Variable, you provide a list of Hosts, you want to get Pythia to do her magic work for you.


## Workflow

Pythia works in the following order. This is important to know, which steps will be done in which order.


                +---------------+
                |               |
                | Prerequisites |
                |               |
                +-------+-------+
                        |
                +-------v-------+
                |               |
                | Install RDBMS |
                |               |
                +-------+-------+
                        |
                +-------v-------+
                |               |
                | Patch RDBMS / |
                |  existing DB  |
                |               |
                +-------+-------+
                        |
                +-------v-------+
                |               |
                |  Install DB   |
                |               |
                +-------+-------+
                        |
                +-------v-------+
                |               |
                |  Upgrade DB   |
                |               |
                +-------+-------+
                        |
                +-------v-------+
                |               |
                |  Install add. |
                |   Software    |
                |               |
                +-------+-------+
                        |
                +-------v--------+
                |                |
                | Run SQL Script |
                |                |
                +-------+--------+
                        |
                +-------v--------+
                |                |
                | Install Client |
                |                |
                +-------+--------+
                        |
                +-------v--------+
                |                |
                |  Duplicate DB  |
                |                |
                +----------------+


## Further Documentation

We try to provide a detailed documentation for each usecase of Pythia. Please have a look into these:

  - [Install an Oracle Database RDBMS](https://github.com/thedatabaseme/pythia/blob/master/docs/02_INSTALL_RDBMS.md)
  - [Create a Database](https://github.com/thedatabaseme/pythia/blob/master/docs/03_CREATE_DB.md)
  - [Install Patches and Updates](https://github.com/thedatabaseme/pythia/blob/master/docs/04_INSTALL_PATCH.md)