#!/bin/bash

set -e

DB_HOST=${DB_HOST:-db}
APP_HOST=${APP_HOST:-app}

set_properties()
{
 local prop_file="$1"
 if [[ $(cat $prop_file | grep FOO | wc -l) -ge "1" ]]; then
	sed -Ei "s/FOO_DBMS/$DB_HOST/g" $prop_file
	sed -Ei "s/FOO_APP/$APP_HOST/g" $prop_file
 fi
}

wait_dbms()
{
 until nc -z $DB_HOST 5432
 do
   sleep 1
 done
}

run_metasfresh()
{
 cd /opt/metasfresh-webui-api/ && java -jar metasfresh-webui-api.jar
}


set_properties /opt/metasfresh-webui-api/metasfresh.properties
set_properties /opt/metasfresh-webui-api/local_settings.properties

wait_dbms
run_metasfresh

exit 0 
