#!/bin/sh

MYUSER="postgres"
MYGID="10014"
MYUID="10014"

AutoUpgrade(){
  if [ -e /etc/alpine-release ]; then
    /sbin/apk --no-cache upgrade
    /bin/rm -rf /var/cache/apk/*
  elif [ -e /etc/os-release ]; then
    if /bin/grep -q "NAME=\"Ubuntu\"" /etc/os-release ; then 
      export DEBIAN_FRONTEND=noninteractive
      /usr/bin/apt-get update
      /usr/bin/apt-get -y --no-install-recommends dist-upgrade
      /usr/bin/apt-get -y autoclean
      /usr/bin/apt-get -y clean 
      /usr/bin/apt-get -y autoremove
      /bin/rm -rf /var/lib/apt/lists/*
    fi
  fi
}

ConfigureUser () {
  # Managing user
  if [ -n "${DOCKUID}" ]; then
    MYUID="${DOCKUID}"
  fi
  # Managing group
  if [ -n "${DOCKGID}" ]; then
    MYGID="${DOCKGID}"
  fi
  local OLDHOME="/home/${MYUSER}"
  local OLDGID
  local OLDUID
  
  if /bin/grep -q "${MYUSER}" /etc/passwd; then
    OLDUID=$(/usr/bin/id -u "${MYUSER}")
    OLDGID=$(/usr/bin/id -g "${MYUSER}")
    if [ "${DOCKUID}" != "${OLDUID}" ]; then
      OLDHOME=$(grep ${MYUSER} /etc/passwd | awk -F: '{print $6}')
      /usr/bin/logger "Deleting user: ${MYUSER}"
      /usr/sbin/deluser "${MYUSER}"
    fi
    
    if /bin/grep -q "${MYUSER}" /etc/group; then
      local OLDGID=$(/usr/bin/id -g "${MYUSER}")
      if [ "${DOCKGID}" != "${OLDGID}" ]; then
        /usr/bin/logger "Deleting group: ${MYUSER}"
        /usr/sbin/delgroup "${MYUSER}"
      fi
    fi
  fi
  if ! /bin/grep -q "${MYUSER}" /etc/group; then
    /usr/bin/logger "Creating group: ${MYUSER}"
    /usr/sbin/addgroup --system --gid "${MYGID}" "${MYUSER}"
  else
    /usr/bin/logger "Group: ${MYUSER} already configured"
  fi
  if ! /bin/grep -q "${MYUSER}" /etc/passwd; then
    /usr/bin/logger "Creating user: ${MYUSER}"
    /usr/sbin/adduser --system --shell /sbin/nologin --gid "${MYGID}" --home "${OLDHOME}" --uid "${MYUID}" "${MYUSER}"
  else
    /usr/bin/logger "User: ${MYUSER} already configured"
  fi
  if [ -n "${OLDUID}" ] && [ "${DOCKUID}" != "${OLDUID}" ]; then
    /usr/bin/logger "Fixing user ownership for uid ${OLDUID}"
    /usr/bin/find / -user "${OLDUID}" -exec /bin/chown ${MYUSER} {} \;
  fi
  if [ -n "${OLDGID}" ] && [ "${DOCKGID}" != "${OLDGID}" ]; then
    /usr/bin/logger "Fixing group ownership for gid ${OLDGID}"
    /usr/bin/find / -group "${OLDGID}" -exec /bin/chgrp ${MYUSER} {} \;
  fi
}

AutoUpgrade
ConfigureUser

if [ "$1" = "postgres" ]; then

fi

exec "$@"
