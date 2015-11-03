#!/bin/bash

SOURCE_FILE_NAME=lamessh.sh
DEST_FILE_NAME=xlamessh.ssh

HOST_NAME=192.168.60.17

EOF_ESCAPE=XXEOFXX

cat ${SOURCE_FILE_NAME} | sed -e "s/^EOF/${EOF_ESCAPE}/" > ${SOURCE_FILE_NAME}.tmp

expect -d <<EOF > /dev/null
spawn ssh ${GATE_LOGIN_NAME}@${GATE_HOME_NAME}

expect "password:"
send "${GATE_LOGIN_PASSWD}\n"

expect "Ip:"
send "${HOST_NAME}\n"

expect "]\\\\\$"
send "export LC_ALL=en_US.UTF-8\n"

expect "]\\\\\$"
send "cat <<EOF > ${DEST_FILE_NAME}\n"

set fd [open "${SOURCE_FILE_NAME}.tmp" r]

while { [gets \$fd line] >= 0 } { 
  expect -re "\\[\n\r\\].*> $"
  send "\$line\n"
}

close \$fd

expect -re "\\[\n\r\\].*> "
send "EOF\n"

expect "]\\\\\$"
send "sed -i -e \"s/^${EOF_ESCAPE}/EOF/\" ${DEST_FILE_NAME}\n"

expect "]\\\\\$"
exit

EOF
