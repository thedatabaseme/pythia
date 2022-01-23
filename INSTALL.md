# Installation Instructions
For first time installation, please read this Instructions carefully. Else, Pythia will not work as expected!

General
===============

You will need to provide several Files to ensure, that Pythia will work correctly. All Files you need to create are listed in this Instruction. These files can and should be changed by you, to fulfill your needs for installing and maintaining an Oracle Database. You may want to adapt all Variables or Templates to meet your or your companies requirements. Hence you want to change the Folder Structure to fulfill your needs.
For every File that needs to exist, there is an *EXAMPLE* file in the respective directory. If you want to, you can copy the *EXAMPLE* file (and remove the EXAMPLE from the filename) and Pythia will work. This is not the recommended way however.

Variables
===============

Variables are defined under the role/pythia/vars/ directory.

client_dict.yml
---------------
The client_dict.yml contains Variables / Dictionaries regarding the Oracle Client Installation. There is an *client_dict_EXAMPLE.yml* file.
There is a dictionary structure for every Client Version you may want to install (e.G. 19CLNT for all Variables, when you want to install a 19c Client).

You may want to adapt the following Variables in the file to suffice your needs:

  - client_dir: Path where the Client Installation Archives are located on the Stage Directory (Ansible Host), relative to the local_stage_directory Variable
  - oracle_base: Oracle Base Directory for the specified Client
  - oracle_home: Oracle Home Directory for the specified Client
  - oracle_inventory: Path to the Oracle Inventory Location

patch_dict.yml
---------------
The patch_dict.yml contains Variables / Dictionaries regarding the Oracle Database Patches (RUs). There is an *patch_dict_EXAMPLE.yml* file.
There is a dictionary structure for every Patchset you may want to install (e.G. 30125133 for all Variables, when you want to install the 19.5 Release Update).

You may want to adapt the following Variables in the file to suffice your needs:

  - patch_dir: Path where the patch is located, relative to the local_stage_directory variable. Must reside under local_stage_directory.
  - opatch_dir: Path where the needed OPATCH for patch installation is located. Relative to the local_stage_directory variable. Must reside under local_stage_directory.

When you want to create a new entry for a new Release Update (RU) you want to rollout using Pythia, you need to provide a new dictionary entry with the correct Patch ID, also insert the corresponding Opatch Archive on your local_stage_directory and specify the Archive filename in the opatch_file Variable.
The same applies for the Release Update Archive itself. You need to specify the Archive filename under the Variable patch_file.

rdbms_dict.yml
---------------
The rdbms_dict.yml contains Variables / Dictionaries regarding the Oracle Database RDBMS. There is an *rdbms_dict_EXAMPLE.yml* file.
There is a dictionary structure for every Database Release / Edition you may want to install (e.G. 19EE for all Variables, when you want to install the 19c Enterprise Edition).

You may want to adapt the following Variables in the file to suffice your needs:

  - rdbms_dir: Path where the RDBMS is located on the Stage Directory, relative to the local_stage_directory Variable
  - oracle_base: Oracle Base Directory for the specified Client
  - oracle_home: Oracle Home Directory for the specified Client
  - oracle_inventory: Path to the Oracle Inventory Location
  - additional_dir: You may specify an additional directory that should be created / permission set when install RDBMS

When you want to create a new entry for a new Database Release (e.G. 21c) you want to rollout using Pythia, you need to provide a new dictionary entry with any ID that you want to reference during the Installation with Pythia.
You want to specify RDBMS Archive itself. You need to specify the Archive filename under the Variable rdbms_file.

rpm_dict.yml
---------------
The RPM Dictionary is a bit of a special case in Pythia. Pythia is able to install user specific RPMs (e.G. Backup Agents). There is an *rpm_dict_EXAMPLE.yml* file.
Please be aware, that to Install a RPM, you also need to provide the Playbook under roles/pythia/tasks/ directory (like the rpm_DEMO.yml) which handles the RPM Installation and pre- / post-tasks.

The rpm_dict.yml contains Variables / Dictionaries regarding user specific RPMs you want to install. 

  - rpm_dir: Path where the patch is located, relative to the local_stage_directory variable. Must reside under local_stage_directory.
  - rpm_file: Filename of the RPM / Archive.
  - archive: Controls if the RPM is contained within a TAR or ZIP Archive
  - unarchive_file: Specifies the filename when the RPM is unarchived

sid_directories.yml
---------------
The Variables in the sid_directories.yml specify your Installation / Folder Structure for the Database itself. All Folders specified here will be created during the Installation Process and are relevant in the Database Creation response files (see below *Database.rsp.j2). For instance, you can specify a user defined location for your Online Redologs or Datafiles. When you want to mirror your Redologs to an additional folder / Volume, you also need to specify this in the DBCA Responsefiles (see below).

  - sid_directory_list: A list of Directories that are created when installing a Database. All Directories that are configured in the Response Files for Database Creation (can be found under the template folder) are created before installing the database. If you want to change your Datafile, Redo Log Location, you may also have to change the list of Directories that are created here.

All other Variables in here are referenced in the respective Responsefile for the DBCA. 

  - diag_dest: Specifies the Diagnostic Dest. This Variable is referenced in the DBCA Templates and the Listener configuration Templates
  - fast_recovery_area: Specifies the Fast Recovery Area location of your Database (db_recovery_file_dest). This Variable is referenced in the DBCA Templates (*_Database.rsp.j2)
  - admin_dest: Specifies the Admin Destination Folder for your Database Installation. Here one of the controlfile will be places. This Variable is referenced in the DBCA Templates (*_Database.rsp.j2)
  - data_dest: Specifies the Location of the Database Datafiles. This Variable is referenced in the DBCA Templates (*_Database.rsp.j2)
  - temp_dest: Specifies the Location of the Database Tempfiles. This Variable is referenced in the DBCA Templates (*_Database.rsp.j2)
  - redo_dest1, redo_dest2: Specifies the Location of the Online Redo Logs. This Variable is referenced in the DBCA Templates (*_Database.rsp.j2)
  - archive_dest: Specifies the Location of the Archived Redo Logs. This Variable is referenced in the DBCA Templates (*_Database.rsp.j2)
  - audit_dest: Specifies the Location of the Audit Files. This Variable is referenced in the DBCA Templates (*_Database.rsp.j2)

sid_parameters.yml
---------------
There is no need to adapt the `dbca` template if you want to get an additional parameter included during DB creation. For this, you can use the `sid_parameters.yml` under the `vars` folder. There is an *sid_parameters_EXAMPLE.yml* file which shows you an example content. It is not mandatory, that this file exists, it will only get included, when it's existing and only when using the `db` TAG. In the `sid_parameters.yml` you can specify a dictionary of parameters you want to specify per SID. For instance, if you plan to adjust the parameters `filesystemio_options` and `fast_start_mttr_target` when a database `ORA21` is getting created, your `sid_parameters.yml` should look like this.

```
sid_parameters:
  ORA21:
    parameters:
      FILESYSTEMIO_OPTIONS: setall
      FAST_START_MTTR_TARGET: 150
```

You are able to specify parameters for multiple instances in one file.

> :warning: Defining the same parameters multiple times with conflicting values will lead to unknown behavior during the DB creation. Please check the dbca templates under the templates directory to understand, which parameters are set there.

Templates
===============

Templates can be found under the role/pythia/templates/ directory.

*_Client.rsp.j2
---------------
There is a Template for every Oracle Client Version you want to deploy with Pythia. There needs to be an according entry in the client_dict.yml for the Version. For instance 19CLNT_Client.rsp.j2 for Version 19c which is defined as 19CLNT in the client_dict.yml. The Client.rsp.j2 Templates are used, to provide a Responsefile for the Oracle Installer when installing an Oracle Client with Pythia.

*_listener.ora
---------------
There is a listener.ora Template for every Database Version and Edition you want to deploy with Pythia. There needs to be an according entry in the rdbms_dict.yml for the Version. For instance 19EE_listener.ora for Version 19c Enterprise Edition which is defined as 19EE in the rdbms_dict.yml. The listener.ora Templates are used, to create a valid Listener when you deploy a database with Pythia.

*_SoftwareOnly.rsp.j2
---------------
There is a Template for every Database Version you want to deploy with Pythia. There needs to be an according entry in the rdbms_dict.yml for the Version. For instance 19EE_SoftwareOnly.rsp.j2 for Version 19c Enterprise Edition which is defined as 19EE in the rdbms_dict.yml. The SoftwareOnly.rsp.j2 Templates are used, to provide a Responsefile for the Oracle Installer when installing the Oracle Database Software (and Software Only, no Database) with Pythia.

*_Database.rsp.j2
---------------
There is a Template for every Database Version you want to deploy with Pythia. There needs to be an according entry in the rdbms_dict.yml for the Version. For instance 19EE_Database.rsp.j2 for Version 19c Enterprise Edition which is defined as 19EE in the rdbms_dict.yml. The Database.rsp.j2 Templates are used, to provide a Responsefile for the Oracle Installer when installing the Oracle Database Software and Database with Pythia. There is an *Database_EXAMPLE.rsp.j2* file for every Database Version and Edition.

As mentioned above (see sid_directories.yml), the sid_directories.yml and the Database.rsp.j2 Template are directly related. When you add a Directory in the sid_directories.yml, you may also need to change the Database Template as well. (e.G. adding another Archive Destination or another Mirrorlog). Be aware, that the Responsefiles are XML formatted, so any Syntax Error might lead to an Error during the Database Creation with Pythia. But don't blame the Hammer if you want to bang a Screw in the wall with it.