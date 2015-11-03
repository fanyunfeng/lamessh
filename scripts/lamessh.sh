#!/bin/bash

HOST_NAME=192.168.60.17

EXEC_COMMAND=ls

expect <<EOF  
spawn ssh ${GATE_LOGIN_NAME}@${GATE_HOME_NAME}

expect "password:"
send "${GATE_LOGIN_PASSWD}\n"

expect "Ip:"
send "${HOST_NAME}\n"

#set LC_ALL
expect "]\\\\\$"
send "export LC_ALL=en_US.UTF-8;echo \"START COMMAND:\"\n"

#send command 
expect "]\\\\\$"
send "${EXEC_COMMAND}\n"

expect "]\\\\\$"
exit

EOF
