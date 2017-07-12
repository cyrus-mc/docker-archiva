#!/bin/bash

DATA_PATH=/var/archiva

# initialize volume
i=0
DATA_DIRS[((i++))]="data"
DATA_DIRS[((i++))]="logs"
DATA_DIRS[((i++))]="repositories"
DATA_DIRS[((i++))]="conf"
DATA_DIRS[((i++))]="temp"

cd /opt/apache-archiva
for datadir in "${DATA_DIRS[@]}"; do
  if [ ! -e "${DATA_PATH}/${datadir}" ]
  then
    mkdir -p ${DATA_PATH}/${datadir}

    # copy images files to volume
    if [ -e "${datadir}" ]
    then
      echo "Copying files"
      cp -pr ${datadir}/* ${DATA_PATH}/${datadir}/ 
    fi
  fi

  rm -rf ${datadir}
  echo "linking"
  ln -s ${DATA_PATH}/${datadir} .

done

# first check if we're passing flags, if so
# prepend (this actually doesn't work as parameter to init can't start with -)
if [ "${1:0:1}" = '-' ]; then
  set -- /opt/apache-archiva/bin/archiva "$@"
else
  set -- /opt/apache-archiva/bin/archiva "console"
fi

# execute
exec "$@"
