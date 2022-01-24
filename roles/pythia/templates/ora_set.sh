ORACLE_BASE={{ rdbms[oracle_version|string].oracle_base | default("/oracle") }}; export ORACLE_BASE
if [ -s $HOME/ora_hostname ]
then
	ORACLE_HOSTNAME=$(cat $HOME/ora_hostname); export ORACLE_HOSTNAME
else
	ORACLE_HOSTNAME=$(hostname); export ORACLE_HOSTNAME
fi
NLS_LANG=AMERICAN_AMERICA.AL32UTF8; export NLS_LANG
NLS_DATE_FORMAT="DD.MM.YYYY HH24:MI:SS"; export NLS_DATE_FORMAT
ECHO="echo -e"; export ECHO
ORAVERS=19.3.0.0
SCRIPT="ora_set.sh"
OS=$(uname -s)

ORATAB=/etc/oratab; export ORATAB
EGREP=$(which egrep | awk '$0!~/alias/ {print $1}')
WGREP="$(which grep | awk '$0!~/alias/ {print $1}') -w"
AWK=$(which awk)

case $# in 
	1 ) 
		if [ "$1" == "INSTALL" ]
		then
			${ECHO} "\n\t!!!!!  No valid ORACLE_HOME specified  !!!!!"
			${ECHO} "\n\t\tUsage:\n\t${SCRIPT} INSTALL [ORACLE_HOME]\n"
			${ECHO} "\n\t Exiting without any changes ...\n"
			exit 99
		else
			OSID=$1
			OHOME=$(${WGREP} ^"${OSID}" ${ORATAB} | cut -f2 -d: -s)
			if [ -z ${OHOME} ]
			then 
				${ECHO} "\n\t!!!!!  No valid ORACLE_SID specified  !!!!!"
				${ECHO} "\n\t Valid values for ORACLE_SID are:\n"
				${AWK} -F: '$1!~/^#|^$|^\s/ {printf "%s (ORACLE_HOME = %s)\n", $1, $2;}' ${ORATAB}
				${ECHO} "\n\t Exiting without any changes ...\n"
				exit 99
			else
				ORACLE_SID=${OSID}
				ORACLE_HOME=${OHOME}
			fi
		fi
		;;
	2 ) 
		if [ "$1" == "INSTALL" ]
		then
			${ECHO} "\n\t------------------------------------------------"
			${ECHO} "\tATTENTION !!! Automated Installation ongoing !!!"
			${ECHO} "\t------------------------------------------------\n"
			ORACLE_SID=ORADUMMY
			ORACLE_HOME=$2
			if [ ! -d ${ORACLE_HOME} ]
			then
				${ECHO} "\n\t!!!!!  ORACLE_HOME ${ORACLE_HOME} does not exist  !!!!!"
				${ECHO} "\n\t\tUsage:\n\t${SCRIPT} INSTALL [ORACLE_HOME]\n"
				${ECHO} "\n\t Exiting without any changes ...\n"
				exit 99
			fi
		else
			${ECHO} "\n\t!!!!!  No valid options submitted  !!!!!"
			${ECHO} "\n\t\tUsage:\n\t${SCRIPT} INSTALL [ORACLE_HOME]\n"
			${ECHO} "\n\t Exiting without any changes ...\n"
			exit 99
		fi
    ;;
	* ) 
		if [ -f ${ORATAB} ]
		then
			LINES=$(${EGREP} -v "^#|^$|^\s" ${ORATAB} | wc -l | awk '{print $1}')
			case "$LINES" in
				0)	
					${ECHO}
					${ECHO} "\n\t\tNo ORACLE_SID Entries exist in ${ORATAB}:\n"
					${ECHO} "Choose Oracle SID and Home Location"
					${ECHO} "ORACLE_SID will be ? \c"
					read -t 10 ORACLE_SID
					${ECHO} "ORACLE_HOME will be ? \c"
					read -t 10 ORACLE_HOME
					if [ -z "${ORACLE_HOME}" -o ! -d "${ORACLE_HOME}" ]
					then
						clear
						${ECHO} "No valid ORACLE_HOME Directory !!!"
						exit 1
					fi
					;;
				1)	
					ORACLE_SID=$(cat ${ORATAB} | ${EGREP} -v "^#|^$|^\s" | cut -f1 -d: -s)
					ORACLE_HOME=$(cat ${ORATAB} | ${EGREP} -v "^#|^$|^\s" | ${WGREP} ${ORACLE_SID} | cut -f2 -d: -s)
					;;

				*)	
					${ECHO} "\n\t\t Found ${LINES} ORACLE_SID Entries exist in ${ORATAB}:\n"
					${ECHO}
					for OSID in $(${EGREP} -v "^#|^$|^\s" ${ORATAB} | cut -f1 -d: -s)
					do
						ORACLE_HOME=$(${WGREP} ^"${OSID}" ${ORATAB}| cut -f2 -d: -s)
						${ECHO} "ORACLE_SID  = ${OSID}\t/  ORACLE_HOME = ${ORACLE_HOME}"
					done
					${ECHO}
					${ECHO} "Choose Oracle SID"
					${ECHO} "ORACLE_SID will be ? \c"
					read -t 10 ORACLE_SID
					ORACLE_HOME=$(${WGREP} ^"${ORACLE_SID}" ${ORATAB} | cut -f2 -d: -s)
					;;
			esac
		else
				${ECHO}
				${ECHO} "File ${ORATAB} does not exist"
				${ECHO} "Choose Oracle SID and Home Location"
				${ECHO} "ORACLE_SID will be ? \c"
				read -t 10 ORACLE_SID
				${ECHO} "ORACLE_HOME will be ? \c"
				read -t 10 ORACLE_HOME
				if [ -z "${ORACLE_HOME}" -o ! -d "${ORACLE_HOME}" ]
				then
					clear
					${ECHO} "No valid ORACLE_HOME Directory !!!"
					exit 1
				fi
				${ECHO} "Parameter NLS_LANG is set to ${NLS_LANG} - do you want to change it ? \c"
				read -t 10 answer
				case "$answer" in
					[yY]*) ${ECHO} "NLS_LANG will be ? \c"; read -t 10 NLS_LANG ; export NLS_LANG ;;
					[nN]*) ${ECHO} "Parameter NLS_LANG will stay ${NLS_LANG}" ;;
					*) ${ECHO} "Parameter NLS_LANG will stay ${NLS_LANG}" ;;
				esac
		fi
	;;
esac

### Checking for RAC instances
OSID=$ORACLE_SID
HCANZ=$(ls $ORACLE_HOME/dbs/hc_${OSID}?.dat 2>/dev/null | wc -l)
if [ $HCANZ -eq 1 ]
then
	DBNAME=$ORACLE_SID
	ORACLE_SID="$(echo $(basename $(ls $ORACLE_HOME/dbs/hc_${OSID}?.dat) .dat) | cut -d"_" -f2)"
	${ECHO} "\n##############################  ATTENTION  ##############################"
	${ECHO} "#####  \tRAC instance $ORACLE_SID of database $DBNAME will be used !!!"
	${ECHO} "#########################################################################"
fi
ORACLE_BASE=$(echo $ORACLE_HOME | awk '{gsub(/\/product.*$/, ""); print $0}')
export OSID ORACLE_HOME ORACLE_SID ORACLE_BASE

${ECHO} $PATH | grep "$HOME/bin" > /dev/null
if [ $? -ne 0 ]
then
	PATH=$HOME/bin:$PATH; export PATH
fi
${ECHO} $PATH | grep "$ORACLE_HOME/bin" > /dev/null
if [ $? -ne 0 ]
then
	PATH=${ORACLE_HOME}/bin:$PATH; export PATH
fi

PS1="${ORACLE_SID}@$(hostname) $ "
TNS_ADMIN=${ORACLE_HOME}/network/admin; export TNS_ADMIN
for LD in lib lib64 ctx/lib
do
	${ECHO} $LD_LIBRARY_PATH | grep "${ORACLE_HOME}/$LD" > /dev/null
	if [ $? -ne 0 ]
	then
		LD_LIBRARY_PATH=${ORACLE_HOME}/$LD:$LD_LIBRARY_PATH
	fi
done
export LD_LIBRARY_PATH

DBSTATUS=DOWN
ORACLE_UNQNAME=${ORACLE_SID}; export ORACLE_UNQNAME
DBNAME=$(${ECHO} ${ORACLE_SID} | tr "[:upper:]" "[:lower:]"); export DBNAME
case ${ORACLE_SID} in
  +ASM* ) PMON=asm_pmon_${ORACLE_SID}; export PMON ;;
  -MGMTDB ) PMON=mdb_pmon_${ORACLE_SID}; export PMON ;;
  * ) PMON=ora_pmon_${ORACLE_SID}; export PMON ;;
esac
PMID=$(ps -ef | awk -v PSID=${PMON} '$NF==PSID {print $2}')
if [ ! -z ${PMID} ]
then
	DBSTATUS=RUNNING
	${ECHO} "\n\t found DB >${ORACLE_SID}< running with PMON process ${PMID} (${PMON})\n"
else
	${ECHO} "\n\t PMON process ${PMON} for DB >${ORACLE_SID}< NOT found  => DB NOT running \n"
fi

# get DB Release and Version
FULLVERS=""
if [ "${DBSTATUS}" == "RUNNING" ]
then
	FULLVERS="$(echo "exit" | sqlplus / as sysdba)"
	DBVERS=$(echo $FULLVERS | awk -F"Version" '{print $2}' | cut -d"." -f1-4); export DBVERS
	DBREL=$(echo $DBVERS | cut -d"." -f1); export DBREL
	##### check for DIOGNOSTIC_DEST ans set some variables and aliases
	DIAG="{{ diag_dest }}/diag/rdbms/$DBNAME/$ORACLE_SID/trace"; export DIAG

	if [ -z "${DIAG}" ]
	then
		${ECHO} "\n\t\t !!! DIAGNOSTIC_DEST not found => omit variable ALOG and some aliases !!!"
		${ECHO} "\n\t According to Oracle Standard you should set following aa SYSDBA:"
		${ECHO} "\n\t\t SQL> alter system set diagnostic_dest='/db_data/${ORACLE_SID}/dump';\n"
		ALOG="DIAGNOSTIC_DEST_NOT_FOUND_CHECK_PLEASE"; export ALOG
		alias diag='echo "!!! DIAGNOSTIC_DEST not found => check please !!!"'
		alias lalert='echo "!!! DIAGNOSTIC_DEST not found => check please !!!"'
		alias talert='echo "!!! DIAGNOSTIC_DEST not found => check please !!!"'
	else
		ALOG="$DIAG/alert_${ORACLE_SID}.log"; export ALOG
		alias diag="cd $DIAG; pwd"
		alias lalert='less $ALOG'
		alias talert='tail -30f $ALOG'
	fi
else
	DBVERS="###  NO DB >${ORACLE_SID}< running  ###"; export DBVERS
	DBREL="###  NO DB >${ORACLE_SID}< running  ###"; export DBREL
	DIAG="###  NO DB >${ORACLE_SID}< running  ###"; export DIAG
	ALOG="###  NO DB >${ORACLE_SID}< running  ###"; export ALOG
	alias diag='echo "###  NO DB >${ORACLE_SID}< running  ###"'
	alias lalert='echo "###  NO DB >${ORACLE_SID}< running  ###"'
	alias talert='echo "###  NO DB >${ORACLE_SID}< running  ###"'
fi

##### set some useful aliases
alias cdh='cd ${ORACLE_HOME}'
alias s+='sqlplus / as sysdba'
alias dg+='dgmgrl / '

### activate orabin tools, if existing
if [ -d $HOME/orabin ]
then
	PATH=$PATH:$HOME/orabin; export PATH
	alias ora_show='ora_show.sh'
	alias ora_exe='ora_exe.sh'
fi

TMPDIR=/tmp; export TMPDIR
EDITOR=vi; export EDITOR

${ECHO}
${ECHO} "DB Release      = $DBREL"
${ECHO} "DB Version      = $DBVERS"
${ECHO} "ORACLE_SID      = ${ORACLE_SID}"
${ECHO} "ORACLE_BASE     = ${ORACLE_BASE}"
${ECHO} "ORACLE_HOME     = ${ORACLE_HOME}"
${ECHO} "TNS_ADMIN       = ${TNS_ADMIN}"
${ECHO} "DIAG            = ${DIAG}"
${ECHO} "LD_LIBRARY_PATH = ${LD_LIBRARY_PATH}"
${ECHO} "ORACLE_HOSTNAME = ${ORACLE_HOSTNAME}"
${ECHO}

${ECHO} "~/${SCRIPT} executed ..."
${ECHO}
