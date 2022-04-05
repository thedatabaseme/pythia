#!/usr/bin/python

# Copyright: (c) 2022, Philip Haberkern / TheDatabaseMe <info@thedatabaseme.de>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)
from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

DOCUMENTATION = r'''
---
module: oracle_sql

short_description: This module runs SQL queries on an Oracle database

version_added: "1.0.0"

description: This module runs SQL queries on an Oracle database.

options:
    orahome:
        description: Oracle Home Directory.
        type: str
        required: true
    sql:
        description: SQL command to run on Oracle database.
        type: str
        required: true

author:
    - Philip Haberkern (@thedatabaseme)
'''

EXAMPLES = r'''
- name: Run SQL query on Oracle database
  oracle_sql:
    orahome: "/oracle/product/19_ENT/"
    sql: "select * from dba_users where username = 'SYSTEM';"
  environment:
    ORACLE_HOME: "/oracle/product/19_ENT"
    ORACLE_SID: "ORA19"
  become: yes
  become_user: "oracle"
'''

RETURN = r'''
query_command:
    description: The final sqlplus command after it has been built.
    type: str
    returned: always
    sample: "echo select account_status from dba_users where username = 'SYSTEM' | /oracle/product/19_ENT/bin/sqlplus -s / as sysdba"
query_result:
    description: The query result / output that the module generates.
    type: str
    returned: always
    sample: 'OPEN'
'''

from ansible.module_utils.basic import AnsibleModule


def run_module():
    # define available arguments/parameters a user can pass to the module
    module_args = dict(
        orahome=dict(type='str', required=True),
        sql=dict(type='str', required=True)
    )

    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    if module.check_mode:
        module.exit_json(msg="Running |" + module.params['sql'] )

    cmd='echo "' + module.params['sql'] + '" | ' + module.params['orahome'] + '/bin/sqlplus -s / as sysdba'
    rc, out, err = module.run_command(cmd, use_unsafe_shell=True)

    if rc != 0:
        module.fail_json(msg='failed with error:' + err)

    if module.params['sql'].lower().startswith('select'):
        result['changed']=False

    # in the event of a successful module execution, you will want to
    # simple AnsibleModule.exit_json(), passing the key/value results
    module.exit_json(**result)

    result = dict(
        changed=True,
        query_command=cmd,
        query_result=out,
        rc=rc
    )

def main():
    run_module()


if __name__ == '__main__':
    main()